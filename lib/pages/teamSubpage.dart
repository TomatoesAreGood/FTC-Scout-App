
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/data/eventListing.dart';
import 'package:myapp/data/teamListing.dart';
import 'package:myapp/data/yearlyTeamDivisions.dart';

class TeamSubpage extends StatefulWidget {
  final int teamNumber;
  final int year;
  final String teamName;
  static Map<int, dynamic> storedResults = {};

  const TeamSubpage({super.key, required this.teamNumber, required this.year, required this.teamName});

  @override
  State<TeamSubpage> createState() => _TeamSubpageState();
}

class _TeamSubpageState extends State<TeamSubpage> {
  late Future<TeamListing?> team;
  late Future<List> events;

  Color? selectedColor = Colors.grey[300];

  final List years = [2019, 2020, 2021, 2022, 2023, 2024];
  int selectedIndex = 0;
  late int selectedYear = years[selectedIndex];

  bool isCallingAPI = false;

  Future<List> getEvents(int year) async{
    if(TeamSubpage.storedResults.containsKey(year)){
      return TeamSubpage.storedResults[year];
    }

    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    isCallingAPI = true;
    var response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/$year/events?teamNumber=${widget.teamNumber}'), headers: {"Authorization": "Basic $encodedToken"});
    if(response.body[0] != '{'){  
      isCallingAPI = false;
      List<EventListing> eventList = [];
      return eventList;
    }

    if(response.statusCode == 200){
      print("API CALL SUCCESS");
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
    team = TeamListing.getTeam("${widget.year}", YearlyTeamDivisions.getPageNum("${widget.year}", widget.teamNumber), widget.teamNumber);
    events = getEvents(selectedYear);
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
                  child: Text("2019")
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
                  child: Text("2020")
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
                  child: Text("2021")
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
                  child: Text("2022")
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
                  child: Text("2023")
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
                  child: Text("2024")
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
      return Center(child: Text("No events to show"));
    }
    return ListView(
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
      String date = events[i].dateStart;
      listings.add(
        Column(
          children: [
            ListTile(
              title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${events[i].city}, ${events[i].country}"),
                  Text(date)
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

  Widget generateScaffold(Widget child){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(onPressed: (){print("favouited");}, icon: Icon(Icons.star_border))
        ],
        title: 
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text("${widget.teamNumber} - ${widget.teamName}")
                )
              ),
            ]
          ),
      ),
      body: child
    );
  }

  Widget generateBody(Widget child, TeamListing team){
    String fullTeamName = team.fullTeamName;
    String? sponsors;
    String? schoolName;

    if(fullTeamName.contains("&")){
      List dividedSchool = fullTeamName.split("&");
      schoolName = dividedSchool[dividedSchool.length-1];
      if(schoolName!.startsWith(" ")){
        schoolName = schoolName!.substring(1);
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
          sponsors = substring;
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
        Padding(padding: EdgeInsets.all(5)),
        Align(
          child: Text("General Information", style: TextStyle(fontSize: 22)),
          alignment: Alignment.centerLeft,
        ),
        Container(height: 6, color: Colors.lightBlue,),
        (schoolName != null) ?  ListTile(
          leading: Icon(Icons.school),
          title: Text(schoolName),
        ) : Container(height: 0),
        (sponsors != null) ?  ListTile(
          leading: Icon(Icons.handshake_rounded),
          title: Text(sponsors),
        ) : Container(height: 0),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text(team.getDisplayLocation()),
        ),
        ListTile(
          leading: Icon(Icons.cake),
          title: Text("Rookie Year: ${team.rookieYear}"),
        ),
        Padding(padding: EdgeInsets.all(5)),
        Align(
          child: Text("Events", style: TextStyle(fontSize: 22)),
          alignment: Alignment.centerLeft,
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
      future: Future.wait([team, events]),
      builder: (context, data){
        if(data.hasData){
          TeamListing team = data.data![0];
          List<EventListing> eventList = data.data![1];

          if(!isCallingAPI){
            return generateScaffold(generateBody(Expanded(child: generateListView(eventList)), team));
          }
          // print(team.city);
          return generateScaffold(generateBody(Expanded(child: Center(child: CircularProgressIndicator())), team));
        }
        return generateScaffold(Column(children: [Expanded(child: Center(child: CircularProgressIndicator()))]));
      },
    );
  }
}