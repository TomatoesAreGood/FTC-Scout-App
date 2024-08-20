import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/pages/eventSubpage.dart';
import 'dart:convert';
import 'package:myapp/teamEventData.dart';

class EventAwards extends StatefulWidget {
  final String code;
  final int year;

  const EventAwards({super.key, required this.code, required this.year});

  @override
  State<EventAwards> createState() => _EventAwardsState();
}

class _EventAwardsState extends State<EventAwards> {
  late dynamic data;
  bool isCallingAPI = false;

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

  dynamic getAwards() async{
    if(EventSubpage.storedResults.containsKey("awards") && EventSubpage.storedResults["awards"].isNotEmpty){
      return EventSubpage.storedResults["awards"];
    }
    isCallingAPI = true;
    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/${widget.year}/awards/${widget.code}'), headers: {"Authorization": "Basic $encodedToken"});

    if(response.statusCode == 200){
      print("API CALL SUCCESS");
      List<Award> awards = Award.fromJson(json.decode(response.body) as Map<String,dynamic>);
      EventSubpage.storedResults["awards"] = awards;
      isCallingAPI = false;
      return awards;
    }else{
      throw Exception("API error ${response.statusCode}");
    }
  }

  dynamic refreshAwards() async{
    isCallingAPI = true;
    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/${widget.year}/awards/${widget.code}'), headers: {"Authorization": "Basic $encodedToken"});

    if(response.statusCode == 200){
      print("API CALL SUCCESS");
      List<Award> awards = Award.fromJson(json.decode(response.body) as Map<String,dynamic>);
      EventSubpage.storedResults["awards"] = awards;
      isCallingAPI = false;
      return awards;
    }else{
      throw Exception("API error ${response.statusCode}");
    }
  }
  
  Future refresh() async{
    setState(() {
      data = refreshAwards();
    });
  }

  List<Widget> generateListTiles(List<String?> teams){
    List<Widget> children = [
      Container(height: 5, color: Colors.blue,)
    ];
    for (var i = 0; i < teams.length; i++){
      children.add(
        ListTile(
          title: Text("${i+1}.   ${teams[i]!}", overflow: TextOverflow.ellipsis,),
        )
      );
    }
    return children;
  }

  Widget generateListView(Map<String?, List<String?>> awards){
    if(awards.isEmpty){
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
          itemCount: awards.length,
          itemBuilder: (context, index){
            var teams = awards.values.elementAt(index);
            var awardName = awards.keys.elementAt(index);

            return Column(
              children: [
                ExpansionTile(
                  title: Text(awardName!),
                  children: generateListTiles(teams)
                ),
                const Padding(padding: EdgeInsets.all(1))
              ],
            );
          }
        ),
      ),
    );
  }

  Map<int, String> getTeamDisplayNames(){
    Map<int, String> teamDisplayNames = {};
    List<TeamEventData> teamData = EventSubpage.storedResults["rankings"];
    for(var i = 0; i < teamData.length; i++){
      teamDisplayNames[teamData[i].teamNumber] = teamData[i].teamName ?? "Unknown";
    }
    return teamDisplayNames;
  }

  Map<String?, List<String?>> splitAwards(List<Award> awards){
    Map<int, String> displayNames = getTeamDisplayNames();
    Map<String?, List<String?>> awardList = {};
    for (var i = 0; i < awards.length; i++){
      if(awardList.containsKey(awards[i].name) && awards[i].awardId == 10){
        awardList[awards[i].name]!.add("${awards[i].person} (${awards[i].teamNumber} - ${displayNames[awards[i].teamNumber]})");
      }else if(awards[i].awardId == 10){
        awardList[awards[i].name] = ["${awards[i].person} (${awards[i].teamNumber} - ${displayNames[awards[i].teamNumber]})"];
      }else if(awardList.containsKey(awards[i].name)){
        awardList[awards[i].name]!.add("${awards[i].teamNumber} - ${displayNames[awards[i].teamNumber]}");
      }else{
        awardList[awards[i].name] = ["${awards[i].teamNumber} - ${displayNames[awards[i].teamNumber]}"];
      }
    }
    return awardList;
  }

  @override
  void initState(){
    data = getAwards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: data,
      builder: (context, data){
        if(data.hasData && !isCallingAPI){
          List<Award> awards = data.data!;
          Map<String?, List<String?>> awardList = splitAwards(awards);
          return generateListView(awardList);
        }
        return const Expanded(child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class Award{
  final int? teamNumber;
  final int awardId;
  final int series;
  final String? name;
  final String? person;

  static final Map<int, String> idToAward = {
    1: "Judges' Choice Award",
    2: "Compass Award",
    3: "Promote Award",
    4: "Control Award",
    5: "Motivate Award",
    6: "Design Award",
    7: "Innovate Award",
    8: "Connect Award",
    9: "Think Award",
    10: "Dean's List Finalists",
    11:"Inspire Award",
    12: "Finalist Alliance",
    13: "Winning Alliance",
  };

  const Award({required this.awardId, required this.series, required this.teamNumber, required this.name, required this.person});

  static List<Award> fromJson(Map<String, dynamic> json){
    List awards = json['awards'];
    List<Award> awardList = [];

    for (var i = 0; i < awards.length; i++){
      if(idToAward.containsKey(awards[i]['awardId']) && awards[i]['teamNumber'] != null){
        awardList.add(
          Award(
            awardId: awards[i]['awardId'],
            series: awards[i]['series'],
            teamNumber: awards[i]['teamNumber'],
            name: idToAward[awards[i]['awardId']],
            person: awards[i]['person']
          )
        );
      }
    }
    return awardList;
  }
}