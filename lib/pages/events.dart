import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'eventListing.dart';

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
  print(k);

  while(j < dataList.length){
    if (EventListing.getJulianDate(dataList[j].dateStart) > k){
      weeks.add([]);
    }else{
      while(j < dataList.length && EventListing.getJulianDate(dataList[j].dateStart) <= k){
        j++;                  
      }    
      weeks.add(dataList.sublist(i, j));
      print("${dataList.sublist(i, j).length}  $i  $j");
      
      i = j;
    }
    k += 7;

  }
  return weeks;
}



class _EventsState extends State<Events> {
  late Future<List<EventListing>> allEventListings;

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

                if(weekListings.isNotEmpty){
                  ExpansionTile tile = ExpansionTile(
                    title: Text("Week ${index+1}"),
                    collapsedBackgroundColor: const Color.fromARGB(255, 197, 197, 197),
                    backgroundColor:  const Color.fromARGB(255, 223, 223, 223),
                    children:[],
                  );
                  int i = 0;
                  while(i < weekListings.length){
                    tile.children.add(ListTile(
                      title: Text(weekListings[i].name),
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