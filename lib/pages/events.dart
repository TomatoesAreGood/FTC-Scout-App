// import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'eventListing.dart';
import 'package:myapp/main.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}


Future<List<EventListing>> fetchEvents() async {
  String user = "jwong123";
  String token = "091C1981-05E0-48C6-A3FB-FA579BCFA261";
  String authorization = "$user:$token";
  String encodedToken = base64.encode(utf8.encode(authorization));

  final response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/2023/events'), headers: {"Authorization": "Basic $encodedToken"});

  if(response.statusCode == 200){
    print("API CALL SUCCESS");
    return EventListing.fromJson(json.decode(response.body) as Map<String,dynamic>);
  }else{
    throw Exception(response.statusCode);
  }
}

List<List<EventListing>> splitWeeks(String seasonStart, List<EventListing> dataList){
  List<List<EventListing>> weeks = [];
  int i = 0;
  int j = 0;
  int k = EventListing.getJulianDate(seasonStart);
  
  while(j < dataList.length){
    if (EventListing.getJulianDate(dataList[j].dateStart) > k){
      weeks.add([]);
    }else{
      while(j < dataList.length && EventListing.getJulianDate(dataList[j].dateStart) <= k){
        j++;                  
      }    
      weeks.add(dataList.sublist(i, j));
      i = j;
    }
    k += 7;
  }
  return weeks;
}


Text getDateRange(DateTime start, DateTime end, List<String> monthStrings){
  if(start.month == end.month && start.year == end.year){
    return Text("${monthStrings[start.month-1]} ${start.day} - ${end.day}, ${start.year}", style: const TextStyle(fontStyle: FontStyle.italic));
  }else if(start.month != end.month && start.year == end.year){
    return Text("${monthStrings[start.month-1]} ${start.day} - ${monthStrings[end.month-1]} ${end.day}, ${start.year}", style: const TextStyle(fontStyle: FontStyle.italic));
  }else{
    return Text("${monthStrings[start.month-1]} ${start.day}, ${start.year} - ${monthStrings[end.month-1]} ${end.day}, ${end.year}", style: const TextStyle(fontStyle: FontStyle.italic));
  }
}



class _EventsState extends State<Events> {
  late Future<List<EventListing>> allEventListings;
  List<String> monthStrings = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

  @override
  void initState(){
    super.initState();
    allEventListings = fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<EventListing>>(
        future: allEventListings,
        builder: (context, data){
          if (data.hasData){
            List<EventListing> dataList = data.data!;
            EventListing.mergeSortDate(dataList);
            List<List<EventListing>> weeks = splitWeeks("2023-09-09", dataList);

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: weeks.length,
              itemBuilder: (context, index){
                final weekListings = weeks[index];
                int endDay = EventListing.getJulianDate("2023-09-09") + index*7;
                int startDay = endDay - 6;

                DateTime end = DateTime.utc(0,0,endDay);
                DateTime start = DateTime.utc(0,0,startDay);

                if(weekListings.isNotEmpty){
                  ExpansionTile tile = ExpansionTile(
                    title: Text("Week ${index+1}"),
                    subtitle: getDateRange(start, end, monthStrings),
                    collapsedBackgroundColor: const Color.fromARGB(255, 197, 197, 197),
                    children:[],
                  );
                  int i = 0;
                  while(i < weekListings.length){
                    tile.children.add(ListTile(
                      title: Text(weekListings[i].name),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black,width: 1),
                        borderRadius: BorderRadius.circular(1),
                      )
                    ));
                    i++;
                  }
                  return Column(children: [tile, const Padding(padding: EdgeInsets.all(1))],);
                }else{
                  return const Padding(padding: EdgeInsets.all(0));
                }
              },
            );

            // return ListView.builder(
            //   padding: const EdgeInsets.all(8),
            //   itemCount: dataList.length,
            //   itemBuilder: (context, index){
            //     final eventListing = dataList[index];
            //     return ListTile(title: Text(eventListing.name));
            //   },
            // );

          }else{
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      
    );
  }
}