import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/data/sizeConfig.dart';
import 'package:myapp/data/teamListing.dart';
import 'package:myapp/data/yearlyTeamDivisions.dart';
import 'package:myapp/pages/teamSubpage.dart';
import 'package:myapp/widgets/drawer.dart';
import 'dart:convert';
import 'dart:async';
import '../main.dart';
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
  final textController = TextEditingController();

  bool filtersExpanded = false;

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

  dynamic getNewTeams() async{
    if(MyApp.yearlyTeamListings.containsKey(selectedYear)){
      pageNum = MyApp.yearlyTeamListings[selectedYear]!.page;
      return MyApp.yearlyTeamListings[selectedYear]!.teams; 
    }

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
    textController.dispose();
    super.dispose();
  }

  void scrollUp(){
    int seconds = 0;
    int milliseconds = 200;
    if(controller.position.pixels > 2500){
      milliseconds = 400;
      seconds = 0;
    }
    if(controller.position.pixels > 5000){
      milliseconds = 650;
      seconds = 0;
    }
    if(controller.position.pixels > 10000){
      seconds = (controller.position.pixels/10000).round();
      milliseconds = 0;
    }
    controller.animateTo(0, duration: Duration(seconds: seconds, milliseconds: milliseconds), curve: Curves.easeIn);
  }

  Widget generateVerticalScaffold(Widget child){
    FloatingActionButton? button;
    if(pageNum > 1){
      button = FloatingActionButton(
        onPressed: scrollUp,
        child: const Icon(Icons.arrow_upward),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Teams"),
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(onPressed: (){ setState(() {
            filtersExpanded = !filtersExpanded;
          });}, 
          icon: const Icon(Icons.filter_list_rounded))
        ],
        ),
      drawer: const MyDrawer(),
      floatingActionButton: button,
      body: filtersExpanded ? Column(children: [generateFilterMenu(),child],) : Column(children:[child,])
    );
  }

  Widget generateHorizontalScaffold(Widget child){
    FloatingActionButton? button;
    if(pageNum > 1){
      button = FloatingActionButton(
        onPressed: scrollUp,
        child: const Icon(Icons.arrow_upward),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Teams"),
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(onPressed: (){ setState(() {
            filtersExpanded = !filtersExpanded;
          });}, 
          icon: const Icon(Icons.filter_list_rounded))
        ],
        ),
      drawer: const MyDrawer(),
      floatingActionButton: button,
      body: filtersExpanded ? Column(children: [generateFilters(),child],) : Column(children:[child,])
    );
  }

  Widget generateScaffold(Widget child){
    if(SizeConfig.screenHeight < 500){
      return generateHorizontalScaffold(child);
    }
    return generateVerticalScaffold(child);
  }

   Widget generateFilters(){
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              const Text("Season"),
              DropdownButton<String>(
                isDense: true,
                isExpanded: true,
                value: selectedYear,
                items: years.map((String year){
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year)
                  );
                }).toList(),
                onChanged: (String? newValue){
                  setState((){
                    print("Set State");
                    selectedYear = newValue!;
                    teams = getNewTeams();
                  });
                }
              )
            ],
          ),
        )
      ],
    );
  }

  searchTeam(String teamNum) async{
    if(teamNum.isEmpty){
      return;
    }
    try{
      int teamNumber = int.parse(teamNum);
      TeamListing? team = await TeamListing.getTeam(selectedYear, YearlyTeamDivisions.getPageNum(selectedYear, teamNumber), teamNumber);
      if(team == null){
        return showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            title: AutoSizeText("Team does not exist. Try a different year or double check your search.", maxLines: 2,maxFontSize: 18, minFontSize: 10,textAlign: TextAlign.center),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
          )
        );
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => 
            TeamSubpage(data: ExtendedTeamListing(teamNumber: team.teamNumber, rookieYear: team.rookieYear, teamName: team.teamName, city: team.city, stateProv: team.stateProv, country: team.country, fullTeamName: team.fullTeamName, year: int.parse(selectedYear)))
        )
      );
    }
    on FormatException{
      return showDialog(
        context: context,
        builder: (BuildContext context) => 
          AlertDialog(
            contentPadding: EdgeInsets.zero,
            title: AutoSizeText("Search query can only include numbers", maxLines: 2,maxFontSize: 18, minFontSize: 10,textAlign: TextAlign.center),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
          )
        );
      }
  }



  Widget generateFilterMenu(){
    return Column(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            generateFilters(),
            TextField(
              controller: textController,
              onSubmitted: (value) => searchTeam(value),
              decoration: InputDecoration(
                labelText: "Search",
                suffixIcon: IconButton( onPressed: (){searchTeam(textController.text); }, icon:const Icon(Icons.search))
              ),
            ),
            const SizedBox(
              height: 20
            ),   
          ],
        )
      ]
    );
  }


  Widget generateListView(List<TeamListing> teamList){
    return Expanded(
      flex: 3,
      child: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          controller: controller,
          itemCount: teamList.length + 1,
          itemBuilder: (context, index){
            if(index < teamList.length){
              TeamListing team = teamList[index];
              return ListTile(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => 
                        TeamSubpage(data: ExtendedTeamListing(teamNumber: team.teamNumber, rookieYear: team.rookieYear, teamName: team.teamName, city: team.city, stateProv: team.stateProv, country: team.country, fullTeamName: team.fullTeamName, year: int.parse(selectedYear)))
                    )
                  );
                },
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
          return generateScaffold(generateListView(teamList));
        }
        return generateScaffold(const Expanded(flex: 3, child: Center(child: CircularProgressIndicator())));
      },
    );
  }
}