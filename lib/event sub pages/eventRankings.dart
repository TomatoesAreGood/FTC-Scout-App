import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/pages/eventSubpage.dart';
import 'package:myapp/data/teamPerformanceData.dart';
import 'dart:convert';

import 'package:myapp/userPreferences.dart';

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

  void mergeSortRank(List<TeamPerfomanceData> arr){
    if (arr.length <= 1){
      return;
    }
    int mid = (arr.length / 2).floor() ;
    List<TeamPerfomanceData> L = arr.sublist(0, mid);
    List<TeamPerfomanceData> R = arr.sublist(mid, arr.length);
  
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

  dynamic fetchRankings() async{
    if(EventSubpage.storedResults.containsKey("rankings") && EventSubpage.storedResults["rankings"].isNotEmpty){
      return EventSubpage.storedResults["rankings"];
    }
    isCallingAPI = true;
    String? user = UserPreferences.getSavedUser();
    String? token = UserPreferences.getSavedToken();
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

  dynamic refreshRankings() async{
    isCallingAPI = true;
    String? user = UserPreferences.getSavedUser();
    String? token = UserPreferences.getSavedToken();
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/${widget.year}/rankings/${widget.code}'), headers: {"Authorization": "Basic $encodedToken"});

    if(response.statusCode == 200){
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
    data = fetchRankings(); 
    super.initState();
  }

  Future refresh() async{
    setState(() {
      data = refreshRankings();
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
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: Text("${team.teamNumber}", style: const TextStyle(height: 1.7, fontSize: 20))),
                      const SizedBox(height: 1),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: "${team.rank} ", style: TextStyle(fontWeight: FontWeight.bold,height: 0.5, fontSize: 17, color: Colors.red[700])),
                              TextSpan(text: "(${team.wins}-${team.ties}-${team.losses})", style: TextStyle(height: 0.5, fontSize: 15, color: Colors.red[700]))
                            ],
                          ),
                        )
                      )
                    ],
                  ),
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
          mergeSortRank(teamList);
          return generateListTiles(teamList); 
        }
        return const Expanded(child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}