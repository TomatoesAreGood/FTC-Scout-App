import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/pages/eventSubpage.dart';
import 'package:myapp/teamEventData.dart';
import 'dart:convert';

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