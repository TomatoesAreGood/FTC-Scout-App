import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/pages/eventSubpage.dart';
import 'dart:convert';
import 'package:myapp/data/teamPerformanceData.dart';


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

  void mergeSortTeamNum(List<TeamPerfomanceData> arr){
    if (arr.length <= 1){
      return;
    }
    int mid = (arr.length / 2).floor() ;
    List<TeamPerfomanceData> L = arr.sublist(0, mid);
    List<TeamPerfomanceData> R = arr.sublist(mid, arr.length);
  
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

  dynamic fetchTeams() async{
    if(EventSubpage.storedResults.containsKey("rankings") && EventSubpage.storedResults["rankings"].isNotEmpty){
      return EventSubpage.storedResults["rankings"];
    }
    isCallingAPI = true;
    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/${widget.year}/rankings/${widget.code}'), headers: {"Authorization": "Basic $encodedToken"});
    
    if(response.body[0] != '{'){  
      isCallingAPI = false;
      List<TeamPerfomanceData> teamList = [];
      EventSubpage.storedResults["rankings"] = teamList;
      return teamList;
    }

    if(response.statusCode == 200){
      List<TeamPerfomanceData> teamList = TeamPerfomanceData.fromJson(json.decode(response.body) as Map<String,dynamic>);
      EventSubpage.storedResults["rankings"] = teamList;
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
      List<TeamPerfomanceData> teamList = TeamPerfomanceData.fromJson(json.decode(response.body) as Map<String,dynamic>);
      EventSubpage.storedResults["rankings"] = teamList;
      isCallingAPI = false;
      return teamList;
    }else{
      throw Exception("API error ${response.statusCode}");
    }
  }
  
  @override
  void initState(){
    data = fetchTeams(); 
    super.initState();
  }

  Future refresh() async{
    setState(() {
      data = refreshTeams();
    });
  }

  Widget generateListTiles(List<TeamPerfomanceData> teamList){
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
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: teamList.length,
          itemBuilder: (context, index){
            TeamPerfomanceData team = teamList[index];
            return Column(
              children: [
                ListTile(
                  leading: Text("${team.teamNumber}", style: TextStyle(height: 1.7, fontSize: 20)),
                  title: Text(team.teamName ?? "Unknown", overflow: TextOverflow.ellipsis),
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
          List<TeamPerfomanceData> teamList = data.data!;
          mergeSortTeamNum(teamList);
          return generateListTiles(teamList); 
        }
        return const Expanded(child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

