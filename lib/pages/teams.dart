import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/data/sizeConfig.dart';
import 'package:myapp/data/teamListing.dart';
import 'dart:convert';
import 'dart:async';
import '../data/eventListing.dart';
import '../main.dart';
import '../expandedTile.dart';
import 'eventSubpage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Teams extends StatefulWidget {
  const Teams({super.key});

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  final List<String> years = ["2019", "2020", "2021", "2022", "2023", "2024"];
  late dynamic teams; 

  bool isCallingAPI = false;

  String selectedYear = "2024";
  String countryFilter = "All";
  static int pageNum = 1;

  final controller = ScrollController();


  dynamic getTeams(String year, int page) async{
    if(MyApp.yearlyTeamListings.containsKey(year) && page <= MyApp.yearlyTeamListings[selectedYear]!.page){
      pageNum = MyApp.yearlyTeamListings[year]!.page;
      return MyApp.yearlyTeamListings[year]!.teams; 
    }

    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    var response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/$year/teams?page=$page'), headers: {"Authorization": "Basic $encodedToken"});

    if(response.statusCode == 200){
      print("API CALL SUCCESS");
      List<TeamListing> teamList = TeamListing.fromJson(json.decode(response.body) as Map<String, dynamic>);

      if(page == 1){
        MyApp.yearlyTeamListings[year] = YearlyTeamListing(page: page, teams: teamList);
        return teamList;
      }else{
        MyApp.yearlyTeamListings[year]!.teams.addAll(teamList);
        MyApp.yearlyTeamListings[year]!.page = page;
        return MyApp.yearlyTeamListings[year]!.teams;
      }
    }else{
      throw Exception("API error ${response.statusCode} on page ${page}");
    }
  }

  dynamic refreshTeams() async{
    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    isCallingAPI = true;
    var response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/$selectedYear/teams?page=1'), headers: {"Authorization": "Basic $encodedToken"});

    if(response.statusCode == 200){
      print("API CALL SUCCESS");
      List<TeamListing> teamList = TeamListing.fromJson(json.decode(response.body) as Map<String, dynamic>);
      MyApp.yearlyTeamListings[selectedYear] = YearlyTeamListing(page: 1, teams: teamList);
      isCallingAPI = false;
      return teamList;
    }else{
      throw Exception("API error ${response.statusCode}");
    }
  }

  Future refresh() async{
    setState(() {
      pageNum = 1;
      teams = refreshTeams();
    });
  }
  
  @override
  void initState(){
    teams = getTeams(selectedYear, pageNum);
    controller.addListener((){
      if(controller.position.maxScrollExtent == controller.offset){
        setState(() {
          pageNum++;
          teams = getTeams(selectedYear, pageNum);
        });
      }
    });
    super.initState();
  }

  @override 
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  Widget generateListView(List<TeamListing> teamList){
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        controller: controller,
        itemCount: teamList.length + 1,
        itemBuilder: (context, index){
          if(index < teamList.length){
            TeamListing team = teamList[index];
            return ListTile(
              leading: SizedBox(width: 80, child: Text("${team.teamNumber}", style: const TextStyle(fontSize: 21), textAlign: TextAlign.center,)),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(team.teamName, overflow: TextOverflow.ellipsis,),
                  Text(team.getDisplayLocation(), style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),)
                ],
              )
            );
          }else{
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        }
      ),
    ); 
  }

  @override
  Widget build(BuildContext context) {
   return FutureBuilder<dynamic>(
      future: teams,
      builder: (context, data){
        if(data.hasData && !isCallingAPI){
          List<TeamListing> teamList = data.data!;
          print(teamList.length);
          return generateListView(teamList);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );;
  }
}