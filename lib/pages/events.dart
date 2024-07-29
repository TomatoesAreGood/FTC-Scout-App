// import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import '../eventListing.dart';
import '../main.dart';

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
  List<String> monthStrings = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  List<String> countries = ["All"];
  List<String> years = ["2019", "2020", "2021", "2022", "2023", "2024"];

  String selectedYear = "2024";
  late String seasonStart;
  late dynamic allEventListings;

  int typeFilter = -1;
  String countryFilter = "All";

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
      seasonStart = fetchStartDate(selectedYear);
      return MyApp.yearlyEventListings[year];
    }

    //TODO: migrate to env
    String user = "jwong123";
    String token = "091C1981-05E0-48C6-A3FB-FA579BCFA261";
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/$year/events'), headers: {"Authorization": "Basic $encodedToken"});

    if(response.statusCode == 200){
      print("API CALL SUCCESS");
      List<EventListing> eventList = EventListing.fromJson(json.decode(response.body) as Map<String,dynamic>);
      addKVPToYearlyListing(year, eventList);
      seasonStart = fetchStartDate(selectedYear);
      return eventList;
    }else{
      throw Exception(response.statusCode);
    }
  }

  List<Column> generateListTiles(List<EventListing> weekListings){
      List<Column> listings = [];
      int i = 0;
      while(i < weekListings.length){
        if(i == 0){
          listings.add(
            Column(
              children: [
                  Container(
                    height: 1,
                    color: Colors.black,
                  )
              ]
            )
          );
        }
        listings.add(Column (
          children: [
            ListTile(
              title: Text(weekListings[i].name, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${weekListings[i].city}, ${weekListings[i].country}"),
                  Text(weekListings[i].dateStart)
                ],
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

  ListView generateListView(List<List<EventListing>> weeks){
    return ListView.builder(
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
                ExpansionTile(
                  title: Text("Week ${index+1}"),
                  subtitle: getDateRange(start, end, monthStrings),
                  collapsedBackgroundColor: const Color.fromARGB(255, 197, 197, 197),
                  children: generateListTiles(weekListings),
                ), 
                const Padding(padding: EdgeInsets.all(1))
              ],
            );
          }else{
            return const Padding(padding: EdgeInsets.all(0));
          }
        },
      );
  }

  Scaffold generateScaffold(List<EventListing> eventListings){
    // print("GENERATE SCAFFOLD");
    EventListing.mergeSortDate(eventListings);
    List<List<EventListing>> weeks = splitWeeks(seasonStart, eventListings);
    
    return Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      const Text("Season"),
                      DropdownButton<String>(
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
                          });
                          allEventListings = fetchEvents(selectedYear);
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
            ),
          const TextField(
            decoration: InputDecoration(
              labelText: "Search",
              suffixIcon: Icon(Icons.search)
            ),
          ),
          const SizedBox(
            height: 20
          ),   
          Expanded(child: generateListView(weeks))
        ]
        )
    );
  }


  @override
  void initState(){
    allEventListings = fetchEvents(selectedYear);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    if(allEventListings is List<EventListing>){
      countries = getCountries(allEventListings);
      allEventListings = filterEvents(allEventListings);
      return generateScaffold(allEventListings);
    }
    return FutureBuilder<dynamic>(
        future: allEventListings,
        builder: (context, data){
          if (data.hasData){
            List<EventListing> dataList = data.data!;
            countries = getCountries(dataList);
            dataList = filterEvents(dataList);
            return generateScaffold(dataList);
          }
          return const Center(child: CircularProgressIndicator());
        },
    );
  }
}