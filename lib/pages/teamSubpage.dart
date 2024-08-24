
import 'package:flutter/material.dart';
import 'package:myapp/event%20sub%20pages/eventAwards.dart';
import 'package:myapp/event%20sub%20pages/eventRankings.dart';
import 'package:myapp/event%20sub%20pages/eventSchedule.dart';
import 'package:myapp/event%20sub%20pages/eventTeams.dart';

class TeamSubpage extends StatefulWidget {
  final int teamNumber;
  final int year;
  static Map<String, dynamic> storedResults = {};

  const TeamSubpage({super.key, required this.teamNumber, required this.year});

  @override
  State<TeamSubpage> createState() => _TeamSubpageState();
}

class _TeamSubpageState extends State<TeamSubpage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.teamNumber}"),),
    );
  }
}