import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/hybridMatchData.dart';
import 'package:myapp/teamEventData.dart';
import 'dart:convert';
import '../eventListing.dart';

class EventSubpage extends StatefulWidget {
  final String code;
  final String name;
  final int year;
  static final Map<String, dynamic> storedResults = {};

  const EventSubpage({super.key, required this.name, required this.code, required this.year});

  @override
  State<EventSubpage> createState() => _EventSubpageState();
}


class _EventSubpageState extends State<EventSubpage> {
  int selectedIndex = 0;
  Color? selectedColor = Colors.grey[300];

  Map<String, dynamic> storedResults = {};

  Widget horizontalScrollable(){
    List<Color?> buttonColors = [null, null, null, null];
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
                      }
                    });
                  }, 
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColors[0]
                  ),
                  child: Text("Teams")
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      if(selectedIndex != 1){
                        selectedIndex = 1;
                      }
                    });
                  }, 
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColors[1]
                  ),
                  child: Text("Rankings")
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      if(selectedIndex != 2){
                        selectedIndex = 2;
                      }
                    });
                  }, 
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColors[2]
                  ),
                  child: Text("Schedule")
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      if(selectedIndex != 3){
                        selectedIndex = 3;
                      }
                    });
                  }, 
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColors[3]
                  ),
                  child: Text("Awards")
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget Awards(){
    return Center(child: Text("Awards"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(widget.name)
              )
            ),
          ]
        ),
        actions: [
          IconButton(onPressed: (){print("favouited");}, icon: Icon(Icons.star_border))
        ],
      ),
      body: Column(
        children: [
          horizontalScrollable(),
          [EventTeams(code: widget.code, year: widget.year),EventRankings(code: widget.code, year: widget.year),EventSchedule(code: widget.code, year: widget.year), Awards()][selectedIndex]
        ],
      ),
    );
  }
}

class EventSchedule extends StatefulWidget {
  final String code;
  final int year;

  const EventSchedule({super.key, required this.code, required this.year});

  @override
  State<EventSchedule> createState() => _EventScheduleState();
}

class _EventScheduleState extends State<EventSchedule> {
  late dynamic data;

  bool isCallingAPI = false;

  dynamic getSchedule() async{
    if(EventSubpage.storedResults.containsKey("schedule") && EventSubpage.storedResults["schedule"].isNotEmpty){
      return EventSubpage.storedResults["schedule"];
    }
    isCallingAPI = true;
    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final qualResponse = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/${widget.year}/schedule/${widget.code}/qual/hybrid'), headers: {"Authorization": "Basic $encodedToken"});
    final playoffResponse = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/${widget.year}/schedule/${widget.code}/playoff/hybrid'), headers: {"Authorization": "Basic $encodedToken"});

    if(qualResponse.statusCode == 200 && playoffResponse.statusCode == 200){
      print("API CALL SUCCESS");
      List<HybridMatchData> qualSchedule = HybridMatchData.fromJson(json.decode(qualResponse.body) as Map<String,dynamic>);
      List<HybridMatchData> playoffSchedule = HybridMatchData.fromJson(json.decode(playoffResponse.body) as Map<String,dynamic>);
      List<List<HybridMatchData>> scheduleData = [qualSchedule, playoffSchedule];

      if(!EventSubpage.storedResults.containsKey("schedule")){
        EventSubpage.storedResults["schedule"] = scheduleData;
      }
      isCallingAPI = false;
      return scheduleData;
    }else{
      throw Exception("API error ${qualResponse.statusCode}, ${playoffResponse.statusCode}");
    }
  }

  dynamic refreshSchedule() async{
    isCallingAPI = true;
    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final qualResponse = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/${widget.year}/schedule/${widget.code}/qual/hybrid'), headers: {"Authorization": "Basic $encodedToken"});
    final playoffResponse = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/${widget.year}/schedule/${widget.code}/playoff/hybrid'), headers: {"Authorization": "Basic $encodedToken"});

    if(qualResponse.statusCode == 200 && playoffResponse.statusCode == 200){
      print("API CALL SUCCESS");
      List<HybridMatchData> qualSchedule = HybridMatchData.fromJson(json.decode(qualResponse.body) as Map<String,dynamic>);
      List<HybridMatchData> playoffSchedule = HybridMatchData.fromJson(json.decode(playoffResponse.body) as Map<String,dynamic>);
      List<List<HybridMatchData>> scheduleData = [qualSchedule, playoffSchedule];

      if(!EventSubpage.storedResults.containsKey("schedule")){
        EventSubpage.storedResults["schedule"] = scheduleData;
      }
      isCallingAPI = false;
      return scheduleData;
    }else{
      throw Exception("API error ${qualResponse.statusCode}, ${playoffResponse.statusCode}");
    }
  }

  Future refresh() async{
    setState(() {
      data = refreshSchedule();
    });
  }

  @override
  void initState(){
    data = getSchedule();
    super.initState();
  }

  List<Widget> intToWidget(List<int> teams, bool isRed){
    List<Widget> widgetList = [];
    for (var i = 0; i < teams.length; i++){
      if(isRed){
        widgetList.add(
        Text("${teams[i]}", style: const TextStyle(color: Colors.red))
        );
      }else{
        widgetList.add(
        Text("${teams[i]}", style: TextStyle(color: Colors.blue[600]))
        );
      }
    }
    return widgetList;
  }

  List<int> sortArr(List<int> arr){
    if (arr.length == 3){
      if(arr[0] < arr[1]){
        if(arr[0] < arr[2]){  
          if(arr[1] < arr[2]){
            return [arr[0], arr[1], arr[2]];
          }else{
            return [arr[0], arr[2], arr[1]];
          }
        }else{
          return [arr[2], arr[0], arr[1]];
        }
      }else{
        if(arr[0] > arr[2]){
          if(arr[1] > arr[2]){
            return [arr[2], arr[1], arr[0]];
          }else{
            return [arr[1], arr[2], arr[0]];
          }
        }else{
          return [arr[1], arr[0], arr[2]];
        }
      }
    }else{
      if(arr[0] > arr[1]){
        return [arr[1], arr[0]];
      }else{
        return arr;
      }
    }
   
  }

  List<Widget> generateListTiles(List<HybridMatchData> matches){
    List<Widget> listTiles = [Container(height: 1,color: Colors.black,)];
    for(var i = 0; i < matches.length; i++){
      HybridMatchData match = matches[i];
      String leadingStr = "";
      if(match.tournamentLevel == 1){
        leadingStr = "Q-${match.matchNumber}";
      }else if(match.tournamentLevel == 2){
        leadingStr = "SF-${match.matchNumber}.${match.seriesNumber}";
      }else{
        leadingStr = "F-${match.matchNumber}.${match.seriesNumber}";
      }
      Widget redScore = SizedBox(width:40, child: Text("${match.scoreRedFinal}", style: const TextStyle(color: Colors.red, fontSize: 20)));
      Widget blueScore = SizedBox(width: 40, child: Text("${match.scoreBlueFinal}", style: TextStyle(color: Colors.blue[600], fontSize: 20)));

      if(match.isRedWin){
        redScore = SizedBox(
          width:40, 
          child: Text("${match.scoreRedFinal}", 
          style: const TextStyle(
            fontSize: 20, 
            color: Colors.red, 
            decoration: TextDecoration.underline, 
            decorationColor: Colors.red, 
            decorationThickness: 2)
          )
        ); 
      }else{
        blueScore = SizedBox(
          width: 40,
          child: Text("${match.scoreBlueFinal}",
          style: TextStyle(
            color: Colors.blue[600],
            fontSize: 20,
            decoration: TextDecoration.underline, 
            decorationColor: Colors.blue[600], 
            decorationThickness: 2
            )
          )
        );
      }

      listTiles.add(
        ListTile(
          title: Row(
            children: [
              SizedBox(width:70, child: Text(leadingStr, style: const TextStyle(height: 0.7, fontSize: 21))),
              Column(
                children: intToWidget(sortArr(match.redTeam), true),
              ),
              Padding(
                padding: const EdgeInsets.only(left:17, right: 9),
                child: redScore
              ),
              blueScore,
              Column(
                children: intToWidget(sortArr(match.blueTeam), false)
              ),
            ],
          ),
        )
      );
      listTiles.add(Container(height: 1,color:Colors.black));
    }
    return listTiles;
  }

  Widget generateListView(List<List<HybridMatchData>> schedules){
    if(schedules.isEmpty){
      return const Expanded(
        child: Center(
            child: AutoSizeText(
              "No information has been published about this event. Please check back later.", 
              maxLines: 2, 
              textAlign: TextAlign.center,
            ),
        )
      );
    }

    return Expanded(
      child: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: schedules.length,
          itemBuilder: (context, index){
            String title;
            if(index == 0){
              title = "Qualifications";
            }else if(index == 1){
              title = "Semifinals";
            }else{
              title = "Finals";
            }
            return ExpansionTile(
              title: Text(title),
              children: generateListTiles(schedules[index])
            );
          }
        ),
      ),
    );
  }


  List<HybridMatchData> getTournamentType(List<HybridMatchData> schedule, int type){
    List<HybridMatchData> foundMatches = [];
    for(var i = 0; i < schedule.length; i++){
      if(schedule[i].tournamentLevel == type){
        foundMatches.add(schedule[i]);
      }
    }
    return foundMatches;
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: data,
      builder: (context, data){
        if(data.hasData && !isCallingAPI){
          List<List<HybridMatchData>> schedules = data.data!;
          List<HybridMatchData> qual = schedules[0];
          List<HybridMatchData> playoffs = schedules[1];
          List<HybridMatchData> semis = getTournamentType(playoffs, 2);
          List<HybridMatchData> finals = getTournamentType(playoffs, 3);

          return generateListView([qual, semis, finals]);
        }
        return const Expanded(child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class EventTeams extends StatefulWidget {
  final String code; 
  final int year;

  const EventTeams({super.key, required this.code, required this.year});

  @override
  State<EventTeams> createState() => _EventTeamsState();
}

class _EventTeamsState extends State<EventTeams> {
  late dynamic data;
  bool isCallingAPI = false;

  void mergeSortTeamNum(List<TeamEventData> arr){
    if (arr.length <= 1){
      return;
    }
    int mid = (arr.length / 2).floor() ;
    List<TeamEventData> L = arr.sublist(0, mid);
    List<TeamEventData> R = arr.sublist(mid, arr.length);
  
    mergeSortTeamNum(L);
    mergeSortTeamNum(R);
    int i = 0;
    int j = 0;
    int k = 0;
  
    while(i < L.length && j < R.length){
      if (L[i].teamNumber < R[j].teamNumber){
        arr[k] = L[i];
        i++;
      }else{
        arr[k] = R[j];
        j++;
      }
      k++;
    }
    
    while(i < L.length){
      arr[k] = L[i];
      i++;
      k++;
    }
    while(j < R.length){
      arr[k] = R[j];
      j++;
      k++;
    }
  }

  dynamic getTeams() async{
    if(EventSubpage.storedResults.containsKey("rankings") && EventSubpage.storedResults["rankings"].isNotEmpty){
      return EventSubpage.storedResults["rankings"];
    }
    isCallingAPI = true;
    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/${widget.year}/rankings/${widget.code}'), headers: {"Authorization": "Basic $encodedToken"});

    if(response.statusCode == 200){
      print("API CALL SUCCESS");
      List<TeamEventData> teamList = TeamEventData.fromJson(json.decode(response.body) as Map<String,dynamic>);
      if(!EventSubpage.storedResults.containsKey("rankings")){
        EventSubpage.storedResults["rankings"] = teamList;
      }
      isCallingAPI = false;
      return teamList;
    }else{
      throw Exception("API error ${response.statusCode}");
    }
  }

  dynamic refreshTeams() async{
    isCallingAPI = true;
    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/${widget.year}/rankings/${widget.code}'), headers: {"Authorization": "Basic $encodedToken"});

    if(response.statusCode == 200){
      print("API CALL SUCCESS");
      List<TeamEventData> teamList = TeamEventData.fromJson(json.decode(response.body) as Map<String,dynamic>);
      if(!EventSubpage.storedResults.containsKey("rankings")){
        EventSubpage.storedResults["rankings"] = teamList;
      }
      isCallingAPI = false;
      return teamList;
    }else{
      throw Exception("API error ${response.statusCode}");
    }
  }
  
  @override
  void initState(){
    data = getTeams(); 
    super.initState();
  }

  Future refresh() async{
    setState(() {
      data = refreshTeams();
    });
  }

  Widget generateListTiles(List<TeamEventData> teamList){
    if(teamList.isEmpty){
      return Expanded(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: const Center(
            child: AutoSizeText(
              "No information has been published about this event. Please check back later.", 
              maxLines: 2, 
              textAlign: TextAlign.center,
            ),
          ),
        )
      );
    }

    return Expanded(
      child: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: teamList.length,
          itemBuilder: (context, index){
            TeamEventData team = teamList[index];
            return Column(
              children: [
                ListTile(
                  leading: Text("${team.teamNumber}", style: TextStyle(height: 1.7, fontSize: 20)),
                  title: Text(team.teamName, overflow: TextOverflow.ellipsis),
                  subtitle: Text("${team.rankingPoints} RP   ${team.tieBreakerPoints} TBP", overflow: TextOverflow.ellipsis),
                ),
                Container(
                  height: 1,
                  color: Colors.black,
                )
              ]
            );
          }
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: data,
      builder: (context, data){
        if(data.hasData && !isCallingAPI){
          List<TeamEventData> teamList = data.data!;
          mergeSortTeamNum(teamList);
          return generateListTiles(teamList); 
        }
        return const Expanded(child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class EventRankings extends StatefulWidget {
  final String code; 
  final int year;

  const EventRankings({super.key, required this.code, required this.year});

  @override
  State<EventRankings> createState() => _EventRankingsState();
}

class _EventRankingsState extends State<EventRankings> {
  late dynamic data;
  bool isCallingAPI = false;

  void mergeSortRank(List<TeamEventData> arr){
    if (arr.length <= 1){
      return;
    }
    int mid = (arr.length / 2).floor() ;
    List<TeamEventData> L = arr.sublist(0, mid);
    List<TeamEventData> R = arr.sublist(mid, arr.length);
  
    mergeSortRank(L);
    mergeSortRank(R);
    int i = 0;
    int j = 0;
    int k = 0;
  
    while(i < L.length && j < R.length){
      if (L[i].rank < R[j].rank){
        arr[k] = L[i];
        i++;
      }else{
        arr[k] = R[j];
        j++;
      }
      k++;
    }
    
    while(i < L.length){
      arr[k] = L[i];
      i++;
      k++;
    }
    while(j < R.length){
      arr[k] = R[j];
      j++;
      k++;
    }
  }

  dynamic getRankings() async{
    if(EventSubpage.storedResults.containsKey("rankings") && EventSubpage.storedResults["rankings"].isNotEmpty){
      return EventSubpage.storedResults["rankings"];
    }
    isCallingAPI = true;
    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/${widget.year}/rankings/${widget.code}'), headers: {"Authorization": "Basic $encodedToken"});

    if(response.statusCode == 200){
      print("API CALL SUCCESS");
      List<TeamEventData> teamList = TeamEventData.fromJson(json.decode(response.body) as Map<String,dynamic>);
      if(!EventSubpage.storedResults.containsKey("rankings")){
        EventSubpage.storedResults["rankings"] = teamList;
      }
      isCallingAPI = false;
      return teamList;
    }else{
      throw Exception("API error ${response.statusCode}");
    }
  }

  dynamic refreshRankings() async{
    isCallingAPI = true;
    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/${widget.year}/rankings/${widget.code}'), headers: {"Authorization": "Basic $encodedToken"});

    if(response.statusCode == 200){
      print("API CALL SUCCESS");
      List<TeamEventData> teamList = TeamEventData.fromJson(json.decode(response.body) as Map<String,dynamic>);
      if(!EventSubpage.storedResults.containsKey("rankings")){
        EventSubpage.storedResults["rankings"] = teamList;
      }
      isCallingAPI = false;
      return teamList;
    }else{
      throw Exception("API error ${response.statusCode}");
    }
  }

  @override
  void initState(){
    data = getRankings(); 
    super.initState();
  }

  Future refresh() async{
    setState(() {
      data = refreshRankings();
    });
  }

  Widget generateListTiles(List<TeamEventData> teamList){
    if(teamList.isEmpty){
      return Expanded(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: const Center(
            child: AutoSizeText(
              "No information has been published about this event. Please check back later.", 
              maxLines: 2, 
              textAlign: TextAlign.center,
            ),
          ),
        )
      );
    }

    return Expanded(
      child: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: teamList.length,
          itemBuilder: (context, index){
            TeamEventData team = teamList[index];
            return Column(
              children: [
                ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: Text("${team.teamNumber}", style: TextStyle(height: 1.7, fontSize: 20))),
                      Expanded(child: Text("${team.rank} (${team.wins}-${team.ties}-${team.losses})", style: TextStyle(height: 0.5, fontSize: 13)))
                    ],
                  ),
                  title: Text(team.teamName, overflow: TextOverflow.ellipsis),
                  subtitle: Text("${team.rankingPoints} RP   ${team.tieBreakerPoints} TBP", overflow: TextOverflow.ellipsis),
                ),
                Container(
                  height: 1,
                  color: Colors.black,
                )
              ]
            );
          }
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: data,
      builder: (context, data){
        if(data.hasData && !isCallingAPI){
          List<TeamEventData> teamList = data.data!;
          mergeSortRank(teamList);
          return generateListTiles(teamList); 
        }
        return const Expanded(child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}