import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myapp/data/eventListing.dart';
import 'package:myapp/event%20sub%20pages/eventAbout.dart';
import 'package:myapp/event%20sub%20pages/eventAwards.dart';
import 'package:myapp/event%20sub%20pages/eventRankings.dart';
import 'package:myapp/event%20sub%20pages/eventSchedule.dart';
import 'package:myapp/event%20sub%20pages/eventTeams.dart';
import 'package:myapp/main.dart';

class EventSubpage extends StatefulWidget {
  final ExtendedEventListing data;
  static Map<String, dynamic> storedResults = {};

  const EventSubpage({super.key, required this.data});

  @override
  State<EventSubpage> createState() => _EventSubpageState();
}


class _EventSubpageState extends State<EventSubpage> {
  int selectedIndex = 0;
  Color? selectedColor = Colors.grey[300];
  
  bool isFavorited = false;

  Widget horizontalScrollable(){
    List<Color?> buttonColors = [null, null, null, null, null];
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
                TextButton(
                  onPressed: (){
                    setState(() {
                      if(selectedIndex != 4){
                        selectedIndex = 4;
                      }
                    });
                  }, 
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColors[4]
                  ),
                  child: Text("About")
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
    if(MyApp.findObject(MyApp.favoritedEvents, widget.data) >= 0){
      isFavorited = true;
    }else{
      isFavorited = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int year = widget.data.year;
    String code = widget.data.code;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(widget.data.name)
              )
            ),
          ]
        ),
        actions: [
          IconButton(
            onPressed: (){
              bool showPopUp = false;
              setState(() {
                if(MyApp.favoritedEvents.length < 10){
                  if(!isFavorited){
                    MyApp.favoritedEvents.add(widget.data);
                    isFavorited = true;
                  }else{
                    int index = MyApp.findObject(MyApp.favoritedEvents, widget.data);
                    MyApp.favoritedEvents.removeAt(index);
                    isFavorited = false;
                  }
                }else{
                  showPopUp = true;
                }
              });
              if(showPopUp){
                showDialog(
                  context: context,
                  builder: (BuildContext context) => 
                    AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("You can only favorite up to 10 events", maxLines: 2,textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Ok'),
                        ),
                      ],
                    )
                  );
              }
            }, 
            icon: isFavorited ?  const Icon(Icons.star): const Icon(Icons.star_border)
          )
        ],
      ),
      body: Column(
        children: [
          horizontalScrollable(),
          [EventTeams(code: code, year: year),EventRankings(code: code, year: year), EventSchedule(code: code, year: year), EventAwards(code: code, year: year), About(data: widget.data)][selectedIndex]
        ],
      ),
    );
  }
}


