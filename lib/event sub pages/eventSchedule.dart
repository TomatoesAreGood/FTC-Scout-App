import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/data/hybridMatchData.dart';
import 'package:myapp/pages/eventSubpage.dart';
import 'dart:convert';

import 'package:myapp/userPreferences.dart';

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

  dynamic fetchSchedule() async{
    if(EventSubpage.storedResults.containsKey("schedule") && EventSubpage.storedResults["schedule"][0].isNotEmpty){
      return EventSubpage.storedResults["schedule"];
    }
    isCallingAPI = true;
    String? user = UserPreferences.getSavedUser();
    String? token = UserPreferences.getSavedToken();
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final qualResponse = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/${widget.year}/schedule/${widget.code}/qual/hybrid'), headers: {"Authorization": "Basic $encodedToken"});
    final playoffResponse = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/${widget.year}/schedule/${widget.code}/playoff/hybrid'), headers: {"Authorization": "Basic $encodedToken"});

    if(qualResponse.statusCode == 200 && playoffResponse.statusCode == 200){
      List<HybridMatchData> qualSchedule = HybridMatchData.fromJson(json.decode(qualResponse.body) as Map<String,dynamic>);
      List<HybridMatchData> playoffSchedule = HybridMatchData.fromJson(json.decode(playoffResponse.body) as Map<String,dynamic>);
      List<List<HybridMatchData>> scheduleData = [qualSchedule, playoffSchedule];
      EventSubpage.storedResults["schedule"] = scheduleData;
      isCallingAPI = false;
      return scheduleData;
    }else if(qualResponse.statusCode == 200){
      List<HybridMatchData> qualSchedule = HybridMatchData.fromJson(json.decode(qualResponse.body) as Map<String,dynamic>);
      List<List<HybridMatchData>> scheduleData = [qualSchedule];
      EventSubpage.storedResults["schedule"] = scheduleData;
      isCallingAPI = false;
      return scheduleData;
    }else if(playoffResponse.statusCode == 200){
      List<HybridMatchData> playoffSchedule = HybridMatchData.fromJson(json.decode(qualResponse.body) as Map<String,dynamic>);
      List<List<HybridMatchData>> scheduleData = [playoffSchedule];
      EventSubpage.storedResults["schedule"] = scheduleData;
      isCallingAPI = false;
      return scheduleData;
    }else{
      throw Exception("API error ${qualResponse.statusCode}, ${playoffResponse.statusCode}");
    }
  }

  dynamic refreshSchedule() async{
    isCallingAPI = true;
    String? user = UserPreferences.getSavedUser();
    String? token = UserPreferences.getSavedToken();
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final qualResponse = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/${widget.year}/schedule/${widget.code}/qual/hybrid'), headers: {"Authorization": "Basic $encodedToken"});
    final playoffResponse = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/${widget.year}/schedule/${widget.code}/playoff/hybrid'), headers: {"Authorization": "Basic $encodedToken"});

    if(qualResponse.statusCode == 200 && playoffResponse.statusCode == 200){
      List<HybridMatchData> qualSchedule = HybridMatchData.fromJson(json.decode(qualResponse.body) as Map<String,dynamic>);
      List<HybridMatchData> playoffSchedule = HybridMatchData.fromJson(json.decode(playoffResponse.body) as Map<String,dynamic>);
      List<List<HybridMatchData>> scheduleData = [qualSchedule, playoffSchedule];
      EventSubpage.storedResults["schedule"] = scheduleData;
      isCallingAPI = false;
      return scheduleData;
    }else if(qualResponse.statusCode == 200){
      List<HybridMatchData> qualSchedule = HybridMatchData.fromJson(json.decode(qualResponse.body) as Map<String,dynamic>);
      List<List<HybridMatchData>> scheduleData = [qualSchedule];
      EventSubpage.storedResults["schedule"] = scheduleData;
      isCallingAPI = false;
      return scheduleData;
    }else if(playoffResponse.statusCode == 200){
      List<HybridMatchData> playoffSchedule = HybridMatchData.fromJson(json.decode(qualResponse.body) as Map<String,dynamic>);
      List<List<HybridMatchData>> scheduleData = [playoffSchedule];
      EventSubpage.storedResults["schedule"] = scheduleData;
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
    data = fetchSchedule();
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
    }else if (arr.length == 2){
      if(arr[0] > arr[1]){
        return [arr[1], arr[0]];
      }else{
        return arr;
      }
    }
    return arr;
  }

  List<Widget> generateListTiles(List<HybridMatchData> matches){
    List<Widget> listTiles = [Container(height: 5,color: Colors.blue,)];
    if(matches.isEmpty){
      listTiles.add(const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: Text("No recorded matches", textScaler: TextScaler.linear(1.2),)),
      ));
      return listTiles;
    }
    for(var i = 0; i < matches.length; i++){
      HybridMatchData match = matches[i];
      String leadingStr = "";
      if(match.tournamentLevel == 1){
        leadingStr = "Q-${match.matchNumber}";
      }else if(match.tournamentLevel == 2){
        leadingStr = "SF-${match.matchNumber}.${match.seriesNumber}";
      }else if(match.tournamentLevel == 3){
        leadingStr = "F-${match.matchNumber}.${match.seriesNumber}";
      }else{
        leadingStr = "P-${match.matchNumber}.${match.seriesNumber}";
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
              SizedBox(
                width: 48,
                child: Column(
                  children: intToWidget(sortArr(match.redTeam), true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:15, right: 9),
                child: redScore
              ),
              Padding(
                padding: const EdgeInsets.only(right: 9),
                child: blueScore
              ),
              SizedBox(
                width: 48,
                child: Column(
                  children: intToWidget(sortArr(match.blueTeam), false)
                ),
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
    if(schedules.isEmpty || schedules[0].isEmpty){
      return const Expanded(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
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
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: schedules.length,
          itemBuilder: (context, index){
            String title;
            if(schedules[index][0].tournamentLevel == 1){
              title = "Qualifications";
            }else if(schedules[index][0].tournamentLevel == 2){
              title = "Semifinals";
            }else if(schedules[index][0].tournamentLevel == 3){
              title = "Finals";
            }else if(schedules[index][0].tournamentLevel == 4){
              title = "Playoffs";
            }else{
              title = "Other";
            }
            return Column(
              children: [
                ExpansionTile(
                  key: PageStorageKey(title),
                  title: Text(title),
                  children: generateListTiles(schedules[index])
                ),
                const Padding(padding: EdgeInsets.all(1))
              ],
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

          if(schedules.length == 1){
            return generateListView(schedules);
          }
          List<HybridMatchData> qual = schedules[0];
          List<HybridMatchData> semis = getTournamentType(schedules[1], 2);
          List<HybridMatchData> finals = getTournamentType(schedules[1], 3);
          List<HybridMatchData> playoffs = getTournamentType(schedules[1], 4);

          if(playoffs.isNotEmpty){
            return generateListView([qual, playoffs]);
          }
          return generateListView([qual, semis, finals]);
        }
        return const Expanded(child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
