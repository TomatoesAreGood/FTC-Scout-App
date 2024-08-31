
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/data/eventListing.dart';
import 'package:myapp/data/teamListing.dart';
import 'package:myapp/data/yearlyTeamDivisions.dart';
import 'package:myapp/main.dart';
import 'package:myapp/pages/eventSubpage.dart';

class TeamSubpage extends StatefulWidget {
  final ExtendedTeamListing data;
  static Map<int, dynamic> storedResults = {};

  const TeamSubpage({super.key, required this.data});

  @override
  State<TeamSubpage> createState() => _TeamSubpageState();
}

class _TeamSubpageState extends State<TeamSubpage> {
  late Future<List> events;

  Color? selectedColor = Colors.grey[300];

  final List years = [2019, 2020, 2021, 2022, 2023, 2024];
  int selectedIndex = 0;
  late int selectedYear = years[selectedIndex];

  bool isCallingAPI = false;
  bool isFavorited = false;

  Future<List> getEvents(int year) async{
    if(TeamSubpage.storedResults.containsKey(year)){
      return TeamSubpage.storedResults[year];
    }

    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    isCallingAPI = true;
    var response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/$year/events?teamNumber=${widget.data.teamNumber}'), headers: {"Authorization": "Basic $encodedToken"});
    print("API CALL SUCCESS");

    if(response.body[0] != '{'){  
      isCallingAPI = false;
      List<EventListing> eventList = [];
      TeamSubpage.storedResults[year] = eventList;
      return eventList;
    }

    if(response.statusCode == 200){
      List eventList = EventListing.fromJson(json.decode(response.body) as Map<String, dynamic>);
      TeamSubpage.storedResults[year] = eventList;
      isCallingAPI = false;
      return eventList;
    }else{
      throw Exception("API error ${response.statusCode}");
    }
  }

  @override
  void initState(){
    TeamSubpage.storedResults = {};
    events = getEvents(selectedYear);
    if(MyApp.findObject(MyApp.favoritedTeams, widget.data) >= 0){
      isFavorited = true;
    }else{
      isFavorited = false;
    }
    super.initState();
  }

  Widget horizontalScrollable(){
    List<Color?> buttonColors = [for (var i = 0; i < years.length; i++) null];
    buttonColors[selectedIndex] = selectedColor;

    return Container(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                TextButton(
                  onPressed: (){
                    setState(() {
                      if(selectedIndex != 0){
                        selectedIndex = 0;
                        selectedYear = years[selectedIndex];
                        events = getEvents(selectedYear);
                      }
                    });
                  }, 
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColors[0]
                  ),
                  child: const Text("2019")
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      if(selectedIndex != 1){
                        selectedIndex = 1;
                        selectedYear = years[selectedIndex];
                        events = getEvents(selectedYear);
                      }
                    });
                  }, 
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColors[1]
                  ),
                  child: const Text("2020")
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      if(selectedIndex != 2){
                        selectedIndex = 2;
                        selectedYear = years[selectedIndex];
                        events = getEvents(selectedYear);
                      }
                    });
                  }, 
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColors[2]
                  ),
                  child: const Text("2021")
                ),
                TextButton(
                  onPressed: (){
                    setState(() { 
                      if(selectedIndex != 3){
                        selectedIndex = 3;
                        selectedYear = years[selectedIndex];
                        events = getEvents(selectedYear);
                      }
                    });
                  }, 
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColors[3]
                  ),
                  child: const Text("2022")
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      if(selectedIndex != 4){
                        selectedIndex = 4;
                        selectedYear = years[selectedIndex];
                        events = getEvents(selectedYear);
                      }
                    });
                  }, 
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColors[4]
                  ),
                  child: const Text("2023")
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      if(selectedIndex != 5){
                        selectedIndex = 5;
                        selectedYear = years[selectedIndex];
                        events = getEvents(selectedYear);
                      }
                    });
                  }, 
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColors[5]
                  ),
                  child: const Text("2024")
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget generateListView(List<EventListing> events){
    if(events.isEmpty){
      return const Padding(
        padding: EdgeInsets.all(40.0),
        child: Text("No events to show"),
      );
    }
    return Column(
      children: generateListTiles(events),
    );
  }

  List<Column> generateListTiles(List<EventListing> events){
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
    while(i < events.length){
      String code = events[i].code;
      String name = events[i].name;
      String country = events[i].country;
      String city = events[i].city;
      String dateStart = events[i].dateStart;
      int type = events[i].type;

      listings.add(
        Column(
          children: [
            Tooltip(
              message: name,
              child: ListTile(
                title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$city, $country"),
                    Text(dateStart)
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => 
                        EventSubpage(data:EventListing(city: city, code: code, country: country, dateStart: "$selectedYear", name: name, type: type))
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

  Widget generateScaffold(Widget child){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                if(!isFavorited){
                  MyApp.favoritedTeams.add(widget.data);
                  isFavorited = true;
                }else{
                  int index = MyApp.findObject(MyApp.favoritedTeams, widget.data);
                  MyApp.favoritedTeams.removeAt(index);
                  isFavorited = false;
                }
              });
            }, 
            icon: isFavorited ? const Icon(Icons.star): const Icon(Icons.star_border)
          )
        ],
        title: 
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text("${widget.data.teamNumber} - ${widget.data.teamName}")
                )
              ),
            ]
          ),
      ),
      body: child
    );
  }

  Widget generateBody(Widget child, ExtendedTeamListing team){
    String fullTeamName = team.fullTeamName;
    String? sponsors;
    String? schoolName;

    if(fullTeamName.contains("&")){
      List dividedSchool = fullTeamName.split("&");
      schoolName = dividedSchool[dividedSchool.length-1];
      if(schoolName!.startsWith(" ")){
        schoolName = schoolName.substring(1);
      }
    }else if(!fullTeamName.contains("/")){
      schoolName = fullTeamName;
    }else if(fullTeamName.contains("Family/Community")){
      schoolName = "Family/Community";
    }

    List? dividedSponsors;

    if(fullTeamName != "Family/Community"){
      if(fullTeamName.contains("&")){
        String substring = fullTeamName.substring(0, fullTeamName.lastIndexOf("&"));
        if(substring.contains("/")){
          dividedSponsors = substring.split("/");
        }else{
          if(substring.isNotEmpty){
            sponsors = substring;
          }
        }
      }else if(fullTeamName.contains("/")){
        dividedSponsors = fullTeamName.split("/");
      }
    }
    if(dividedSponsors != null){
      sponsors = dividedSponsors.join(", ");
    }

    return Column(
      children: [
        const Padding(padding: EdgeInsets.all(5)),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("General Information", style: TextStyle(fontSize: 22)),
        ),
        Container(height: 6, color: Colors.lightBlue,),
        (schoolName != null) ?  ListTile(
          leading: const Icon(Icons.school),
          title: Text(schoolName),
        ) : Container(height: 0),
        (sponsors != null) ?  ListTile(
          leading: const Icon(Icons.handshake_rounded),
          title: Text(sponsors),
        ) : Container(height: 0),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: Text(team.getDisplayLocation()),
        ),
        ListTile(
          leading: const Icon(Icons.cake),
          title: Text("Rookie Year: ${team.rookieYear}"),
        ),
        const Padding(padding: EdgeInsets.all(5)),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("Events", style: TextStyle(fontSize: 22)),
        ),
        Container(height: 6, color: Colors.lightBlue,),
        horizontalScrollable(),
        child
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: events,
      builder: (context, data){
        if(data.hasData && !isCallingAPI){
          List<EventListing> eventList = data.data!;
          return generateScaffold(SingleChildScrollView(child: generateBody(generateListView(eventList), widget.data)));
        }
        return generateScaffold(SingleChildScrollView(child: generateBody(const Padding(padding: EdgeInsets.all(55), child: CircularProgressIndicator()), widget.data)));
      },
    );
  }
}