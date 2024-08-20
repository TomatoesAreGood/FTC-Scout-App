import 'package:flutter/material.dart';
import 'package:myapp/event%20sub%20pages/eventAwards.dart';
import 'package:myapp/event%20sub%20pages/eventRankings.dart';
import 'package:myapp/event%20sub%20pages/eventSchedule.dart';
import 'package:myapp/event%20sub%20pages/eventTeams.dart';

class EventSubpage extends StatefulWidget {
  final String code;
  final String name;
  final int year;
  static Map<String, dynamic> storedResults = {};

  const EventSubpage({super.key, required this.name, required this.code, required this.year});

  @override
  State<EventSubpage> createState() => _EventSubpageState();
}


class _EventSubpageState extends State<EventSubpage> {
  int selectedIndex = 0;
  Color? selectedColor = Colors.grey[300];

  Widget horizontalScrollable(){
    List<Color?> buttonColors = [null, null, null, null];
    buttonColors[selectedIndex] = selectedColor;

    return Container(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                TextButton(
                  onPressed: (){
                    setState(() {
                      if(selectedIndex != 0){
                        selectedIndex = 0;
                      }
                    });
                  }, 
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColors[0]
                  ),
                  child: Text("Teams")
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      if(selectedIndex != 1){
                        selectedIndex = 1;
                      }
                    });
                  }, 
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColors[1]
                  ),
                  child: Text("Rankings")
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      if(selectedIndex != 2){
                        selectedIndex = 2;
                      }
                    });
                  }, 
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColors[2]
                  ),
                  child: Text("Schedule")
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      if(selectedIndex != 3){
                        selectedIndex = 3;
                      }
                    });
                  }, 
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColors[3]
                  ),
                  child: Text("Awards")
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState(){
    EventSubpage.storedResults = {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(widget.name)
              )
            ),
          ]
        ),
        actions: [
          IconButton(onPressed: (){print("favouited");}, icon: Icon(Icons.star_border))
        ],
      ),
      body: Column(
        children: [
          horizontalScrollable(),
          [EventTeams(code: widget.code, year: widget.year),EventRankings(code: widget.code, year: widget.year), EventSchedule(code: widget.code, year: widget.year), EventAwards(code: widget.code, year: widget.year)][selectedIndex]
        ],
      ),
    );
  }
}


