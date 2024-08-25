
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
  static Map<String, dynamic> storedResults = {};

  const TeamSubpage({super.key, required this.teamNumber, required this.year});

  @override
  State<TeamSubpage> createState() => _TeamSubpageState();
}

class _TeamSubpageState extends State<TeamSubpage> {
  late Future<TeamListing?> team;
  late Future<List> events;

  Future<List> getEvents(int teamNum, int year) async{
    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    var response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/$year/events?teamNumber=$teamNum'), headers: {"Authorization": "Basic $encodedToken"});

    if(response.statusCode == 200){
      return EventListing.fromJson(json.decode(response.body) as Map<String, dynamic>);
    }else{
      throw Exception("API error ${response.statusCode}");
    }
  }

  @override
  void initState(){
    team = TeamListing.getTeam("${widget.year}", YearlyTeamDivisions.getPageNum("${widget.year}", widget.teamNumber), widget.teamNumber);
    events = getEvents(widget.teamNumber, widget.year);
    super.initState();
  }

  Widget generateScaffold(Widget child){
    return Scaffold(
      appBar: AppBar(title: Text("${widget.teamNumber}")),
      body: child,
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
          print(team.city);
          print(eventList.length);
          return generateScaffold(Text("among us"));
        }
        return generateScaffold(Center(child: CircularProgressIndicator()));
      },
    );
  }
}