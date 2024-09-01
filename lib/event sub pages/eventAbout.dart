import 'package:flutter/material.dart';
import 'package:myapp/data/eventListing.dart';

class About extends StatefulWidget {
  final ExtendedEventListing data;
  const About({super.key, required this.data});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  final Map<int, String> typeToString = {
    1: "League Meet",
    2: "Qualifier",
    3: "League Tournament",
    4: "Championship",
    5: "Other",
    6: "FIRST Championship",
    7: "Super Qualifier",
    10: "Off-Season"
  };


  Text getDateRange(DateTime start, DateTime end){
    final List<String> monthStrings = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  
    if(start.month == end.month && start.year == end.year && start.day == end.day){
      return Text("${monthStrings[start.month-1]} ${start.day}, ${start.year}");
    }else if(start.month == end.month && start.year == end.year){
      return Text("${monthStrings[start.month-1]} ${start.day} - ${end.day}, ${start.year}");
    }else if(start.month != end.month && start.year == end.year){
      return Text("${monthStrings[start.month-1]} ${start.day} - ${monthStrings[end.month-1]} ${end.day}, ${start.year}");
    }else{
      return Text("${monthStrings[start.month-1]} ${start.day}, ${start.year} - ${monthStrings[end.month-1]} ${end.day}, ${end.year}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.type_specimen),
          title: Text(typeToString[widget.data.type] ?? "Other"),
        ),
        ListTile(
          leading: Icon(Icons.place),
          title: Text("${widget.data.venue}, ${widget.data.city}, ${widget.data.country}")
        ),
        ListTile(
          leading: Icon(Icons.calendar_month),
          title: getDateRange(DateTime.parse(widget.data.dateStart), DateTime.parse(widget.data.dateStart))
        ),
        (widget.data.website != null && widget.data.website!.isNotEmpty) ?  ListTile(
          leading: Icon(Icons.link),
          title: Text(widget.data.website!),
        ) : Container(height: 0),
        (widget.data.liveStream != null && widget.data.liveStream!.isNotEmpty) ? ListTile(
          leading: Icon(Icons.live_tv_outlined),
          title: Text(widget.data.liveStream!),
        ) : Container(height: 0)
      ],
    );
  }
}