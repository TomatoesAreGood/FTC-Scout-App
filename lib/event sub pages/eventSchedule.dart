import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/hybridMatchData.dart';
import 'package:myapp/pages/eventSubpage.dart';
import 'dart:convert';

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
