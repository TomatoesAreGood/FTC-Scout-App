import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/data/sizeConfig.dart';
import 'dart:convert';
import 'dart:async';
import '../data/eventListing.dart';
import '../main.dart';
import '../expandedTile.dart';
import 'eventSubpage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}


String fetchStartDate(String year){
  if(MyApp.yearlyStartDates.containsKey(year)){
    print("FETCH START DATE SUCCESS");
    return MyApp.yearlyStartDates[year] as String;
  }else{
    throw Exception("Yearly Start Dates does not contain $year");
  }
}

void addKVPToYearlyListing(String year, List<EventListing> eventList){
  if(!MyApp.yearlyEventListings.containsKey(year)){
      MyApp.yearlyEventListings[year] = eventList;
  }} 

List<List<EventListing>> splitWeeks(String seasonStart, List<EventListing> dataList){
  List<List<EventListing>> weeks = [];
  int i = 0;
  int j = 0;
  int k = EventListing.getJulianDate(seasonStart);
  
  while(j < dataList.length){
    if (EventListing.getJulianDate(dataList[j].dateStart) > k){
      weeks.add([]);
    }else{
      while(j < dataList.length && EventListing.getJulianDate(dataList[j].dateStart) <= k){
        j++;                  
      }    
      weeks.add(dataList.sublist(i, j));
      i = j;
    }
    k += 7;
  }
  return weeks;
}

Text getDateRange(DateTime start, DateTime end, List<String> monthStrings){
  if(start.month == end.month && start.year == end.year){
    return Text("${monthStrings[start.month-1]} ${start.day} - ${end.day}, ${start.year}", style: const TextStyle(fontStyle: FontStyle.italic));
  }else if(start.month != end.month && start.year == end.year){
    return Text("${monthStrings[start.month-1]} ${start.day} - ${monthStrings[end.month-1]} ${end.day}, ${start.year}", style: const TextStyle(fontStyle: FontStyle.italic));
  }else{
    return Text("${monthStrings[start.month-1]} ${start.day}, ${start.year} - ${monthStrings[end.month-1]} ${end.day}, ${end.year}", style: const TextStyle(fontStyle: FontStyle.italic));
  }
}

List<String> getCountries(List<EventListing> eventList){
  List<String> countries = ["All"];
  for (var i = 0; i < eventList.length; i++){
    if(!countries.contains(eventList[i].country)){
      countries.add(eventList[i].country);
    }
  }
  countries.sort();
  return countries;
}


class _EventsState extends State<Events> {
  final List<String> monthStrings = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  final List<String> years = ["2019", "2020", "2021", "2022", "2023", "2024"];
  List<String> countries = ["All"];

  String selectedYear = "2024";
  late String seasonStart;
  late dynamic allEventListings;

  int typeFilter = -1;
  String countryFilter = "All";
  bool isCallingAPI = false;
  bool isExpandedFilters = false;

  String? searchedWord;
  String? searchLabelText = "Search";

  void updateSearchedWord(String enteredWord){
    setState(() {
      if(enteredWord.isEmpty){
        searchedWord = null;
        searchLabelText = "Search";
      }else{
        searchedWord = enteredWord;
        searchLabelText = null;
      }
    });
  }

  List<EventListing> filterSearches(List<EventListing> eventList){
    if(searchedWord == null){
      return eventList;
    }
    return eventList.where((eventListing) => eventListing.name.toLowerCase().contains(searchedWord!.toLowerCase())).toList();
  }

  List<EventListing> filterEvents(List<EventListing> eventList){
    bool isAllCountries = countryFilter == "All";
    bool isAllTypes = typeFilter == -1;

    if(!countries.contains(countryFilter)){
      countryFilter = "All";
      isAllCountries = true;
    }

    if(isAllCountries && isAllTypes){
      return eventList;
    }

    List<EventListing> filteredList = [];

    if(isAllCountries){
      for(var i = 0; i < eventList.length; i++){
        if(eventList[i].type == typeFilter){
          filteredList.add(eventList[i]);
        }
      }
    }else if(isAllTypes){
      for(var i = 0; i < eventList.length; i++){
        if(eventList[i].country == countryFilter){
          filteredList.add(eventList[i]);
        }
      }
    }else{
      for(var i = 0; i < eventList.length; i++){
        if(eventList[i].type == typeFilter && eventList[i].country == countryFilter){
          filteredList.add(eventList[i]);
        }
      }
    }

    return filteredList;
  }

  dynamic fetchEvents(String year) async {
    if(MyApp.yearlyEventListings.containsKey(year)){
      return MyApp.yearlyEventListings[year];
    }
    isCallingAPI = true;
    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/$year/events'), headers: {"Authorization": "Basic $encodedToken"});

    if(response.statusCode == 200){
      print("API CALL SUCCESS");
      print(response.body.length);
      List<EventListing> eventList = EventListing.fromJson(json.decode(response.body) as Map<String,dynamic>);
      addKVPToYearlyListing(year, eventList);
      isCallingAPI = false;
      return eventList;
    }else{
      throw Exception("API error ${response.statusCode}");
    }
  }

  dynamic refreshEvents(String year) async {
    isCallingAPI = true;
    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/$year/events'), headers: {"Authorization": "Basic $encodedToken"});

    if(response.statusCode == 200){
      print("API CALL SUCCESS");
      List<EventListing> eventList = EventListing.fromJson(json.decode(response.body) as Map<String,dynamic>);
      addKVPToYearlyListing(year, eventList);
      isCallingAPI = false;
      return eventList;
    }else{
      throw Exception("API error ${response.statusCode}");
    }
  }

  Widget generateFilters(){
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              const Text("Season"),
              DropdownButton<String>(
                isDense: true,
                isExpanded: true,
                value: selectedYear,
                items: years.map((String year){
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year)
                  );
                }).toList(),
                onChanged: (String? newValue){
                  setState((){
                    print("Set State");
                    selectedYear = newValue!;
                    allEventListings = fetchEvents(selectedYear);
                    seasonStart = fetchStartDate(selectedYear);
                  });
                }
              )
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              const Text("Region"),
              DropdownButton<String>(
                isDense: true,
                isExpanded: true,
                value: countryFilter,
                items: countries.map((String item){
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue){
                  setState((){
                    countryFilter = newValue!;
                  });
                },
              )
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              const Text("Type"),
              DropdownButton<int>(
                isDense: true,
                isExpanded:  true,
                value: typeFilter,
                items: const [
                  DropdownMenuItem(
                    value: -1,
                    child: Text("All")
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text("League Meet")
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text("Qualifier")
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text("League Tournament")
                  ),
                  DropdownMenuItem(
                    value: 4,
                    child: Text("Championship")
                  ),
                  DropdownMenuItem(
                    value: 5,
                    child: Text("Other")
                  ),
                  DropdownMenuItem(
                    value: 6,
                    child: Text("FIRST Championship")
                  ),
                  DropdownMenuItem(
                    value: 7,
                    child: Text("Super Qualifier")
                  ),
                  DropdownMenuItem(
                    value: 10,
                    child: Text("Off-Season")
                  ),
                ],
                onChanged: (int? newValue){
                  setState((){
                    typeFilter = newValue!;
                  });
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  List<Column> generateListTiles(List<EventListing> weekListings){
    List<Column> listings = [
      Column(
        children: [
          Container(
            height: 1,
            color: Colors.black,
          )
        ]
      )
    ];
    int i = 0;
    while(i < weekListings.length){
      String code = weekListings[i].code;
      String name = weekListings[i].name;
      String country = weekListings[i].country;
      String city = weekListings[i].city;
      String dateStart = weekListings[i].dateStart;
      int type = weekListings[i].type;
      listings.add(
        Column (
          children: [
            Tooltip(
              message: name,
              child: ListTile(
                title: Text(weekListings[i].name, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$city, $country"),
                    Text(dateStart)
                  ],
                ),
                onTap: (){
                  print(name);
                  print(selectedYear);
                  print(code);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => 
                        EventSubpage(data:ExtendedEventListing(city: city, code: code, country: country, dateStart: dateStart, name: name, type: type, year: int.parse(selectedYear)))
                    )
                  );
                },
              ),
            ), 
            Container(
              height: 1,
              color: Colors.black,
            )
          ],
        ) 
      );
      i++;
    }
    return listings;
  }

  Future refresh() async{
    setState(() {
      allEventListings = refreshEvents(selectedYear);
    });
  }

  Widget generateListView(List<List<EventListing>> weeks){
    if(weeks.isEmpty){
      return const Center(child: Text("No events found"));
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: weeks.length,
        itemBuilder: (context, index){
          List<EventListing> weekListings = weeks[index];
          int endDay = EventListing.getJulianDate(seasonStart) + index*7;
          int startDay = endDay - 6;
      
          DateTime end = DateTime.utc(0,0,endDay);
          DateTime start = DateTime.utc(0,0,startDay);
      
          if(weekListings.isNotEmpty){
            return Column(
              children: [
                ExpandedTile(subtitle: getDateRange(start, end, monthStrings), weekNum: index+1, children: generateListTiles(weekListings)),
                const Padding(padding: EdgeInsets.all(1))
              ],
            );
          }else{
            return const Padding(padding: EdgeInsets.all(0));
          }
        },
      ),
    );
  } 

  Scaffold generateScaffold(Widget widget){
    if(SizeConfig.screenHeight < 500){
      return generateHorizontalScaffold(widget);
    }
    return generateVerticalScaffold(widget);
  }

  Widget generateFilterMenu(){
    return Column(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            generateFilters(),
            TextField(
              onChanged: (value) => updateSearchedWord(value),
              decoration: InputDecoration(
                labelText: searchLabelText ?? "",
                suffixIcon: const Icon(Icons.search)
              ),
            ),
            const SizedBox(
              height: 20
            ),   
          ],
        )
      ]
    );
  }

  Scaffold generateVerticalScaffold(Widget widget){
    List<Widget> scaffoldChildren = [];
    if(isExpandedFilters){
      scaffoldChildren = [
        generateFilterMenu(),
        widget
      ];
    }else{
      scaffoldChildren = [widget];
    }

    return Scaffold(
      appBar : AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text("Events"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            tooltip: "Filter",
            onPressed: (){
              setState(() {
                isExpandedFilters = !isExpandedFilters;
                searchLabelText = "Search";
                searchedWord = null;
              });
            }
          ),
        ],
      ),
      drawer: const Drawer(),
      body: Column(
        children: scaffoldChildren
      ) 
    );
}

  Scaffold generateHorizontalScaffold(Widget widget){
    List<Widget> scaffoldChildren = [];
    if(isExpandedFilters){
      scaffoldChildren = [
        Expanded(
          flex:1,
          child: Column(
            children: [
              Expanded(
                flex:1,
                child: Column(
                  children: [
                    const Expanded(
                      flex:1,
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    generateFilters(),
                    const Expanded(
                      flex:1,
                      child: SizedBox(
                        height: 20
                      ),
                    ),   
                  ],
                ),
              )
            ]
          )
        ),
        widget
      ];
    }else{
      scaffoldChildren = [widget];
    }

    return Scaffold(
      appBar : AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text("Events"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            tooltip: "Filter",
            onPressed: (){
              setState(() {
                isExpandedFilters = !isExpandedFilters;
                searchLabelText = "Search";
                searchedWord = null;
              });
            }
          ),
        ],
      ),
      drawer: const Drawer(),
      body: Column(
        children: scaffoldChildren
      ) 
    );
  }

  @override
  void initState(){
    allEventListings = fetchEvents(selectedYear);
    seasonStart = fetchStartDate(selectedYear);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder<dynamic>(
      future: allEventListings,
      builder: (context, data){
        if (data.hasData && !isCallingAPI){
          List<EventListing> dataList = data.data!;
          countries = getCountries(dataList);
          dataList = filterEvents(dataList);
          dataList = filterSearches(dataList);
          if(searchedWord != null){
            if(dataList.isEmpty){
              return generateScaffold(const Expanded(flex:3, child: Center(child: Text("No events found"))));
            } 
            return generateScaffold(Expanded(flex:3,child:ListView(children:generateListTiles(dataList))));  
          }
          EventListing.mergeSortDate(dataList);
          List<List<EventListing>> weeks = splitWeeks(seasonStart, dataList);
          return generateScaffold(Expanded(flex:3,child:generateListView(weeks)));      
        }
        return generateScaffold(
          const Expanded(
            flex: 3, 
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.all(8)),
                  Text("If loading persists, exit and reload the page")
                ],
              ),
            )
          )
        );
      },
    );
  }
}