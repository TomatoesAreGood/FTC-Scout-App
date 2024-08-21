import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/data/sizeConfig.dart';
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
  late dynamic allTeams; 
  final List<String> years = ["2019", "2020", "2021", "2022", "2023", "2024"];
  bool isCallingAPI = false;

  dynamic getTeams(String year)async{
    if(MyApp.yearlyEventListings.containsKey(year)){
      return MyApp.yearlyEventListings[year];
    }

    isCallingAPI = true;
    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/$year/events'), headers: {"Authorization": "Basic $encodedToken"});

    if(response.statusCode == 200){
      print("API CALL SUCCESS");
      List<EventListing> eventList = EventListing.fromJson(json.decode(response.body) as Map<String,dynamic>);
      // addKVPToYearlyListing(year, eventList);
      isCallingAPI = false;
      return eventList;
    }else{
      throw Exception("API error ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}