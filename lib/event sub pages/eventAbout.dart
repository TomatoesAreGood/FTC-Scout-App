import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
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
    return Expanded(
      child: ListView(
        children: [
          ListTile(
            leading: const Tooltip(message: "Event Type", child: Icon(Icons.type_specimen)),
            title: Text(typeToString[widget.data.type] ?? "Other"),
          ),
          ListTile(
            leading: const Tooltip(message: "Country", child: Icon(HeroIcons.flag)),
            title:Text(widget.data.country)
          ),
          ListTile(
            leading: const Tooltip(message: "City", child: Icon(MingCute.building_2_fill)),
            title:Text(widget.data.city)
          ),
          (widget.data.venue != null) ? ListTile(
            leading: const Tooltip(message: "Venue", child: Icon(FontAwesome.house_chimney_solid, size: 20)),
            title: AutoSizeText("${widget.data.venue}", maxLines: 1)
          ) : Container(height: 0),
          ListTile(
            leading: const Tooltip(message: "Date", child: Icon(Icons.calendar_month)),
            title: getDateRange(DateTime.parse(widget.data.dateStart), DateTime.parse(widget.data.dateEnd))
          ),
          (widget.data.website != null && widget.data.website!.isNotEmpty) ?  ListTile(
            leading: const Tooltip(message: "Website", child: Icon(Icons.link)),
            title: Text(widget.data.website!),
          ) : Container(height: 0),
          (widget.data.liveStream != null && widget.data.liveStream!.isNotEmpty) ? ListTile(
            leading: const Tooltip(message: "Live Stream", child: Icon(Icons.live_tv_outlined)),
            title: Text(widget.data.liveStream!),
          ) : Container(height: 0)
        ],
      ),
    );
  }
}