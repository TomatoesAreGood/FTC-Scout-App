import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class EventListing {
  final String name;
  final String country;
  final String city;
  final String dateStart;

  const EventListing({
    required this.name,
    required this.country,
    required this.city,
    required this.dateStart,
  });

  static fromJson(Map<String, dynamic> json){
    List<EventListing> allEvents = [];
    List eventList = json['events'];
    
    for (var i = 0; i < eventList.length; i++){
      if(int.parse(eventList[i]['type']) < 12 || int.parse(eventList[i]['type']) > 16){
        allEvents.add(EventListing(
          name: eventList[i]['name'], 
          country: eventList[i]['country'], 
          city: eventList[i]['city'], 
          dateStart: eventList[i]['dateStart'].substring(0, 10), 
        ));
      }   
    }

    mergeSortDate(allEvents);

    for (var i = 0; i < allEvents.length; i++){
      String name = allEvents[i].name;
      String country = allEvents[i].country;
      String city = allEvents[i].city;
      String dateStart = allEvents[i].dateStart;

      print("$i: $name, $country, $city, $dateStart");
    }

    return allEvents;
  }

  static int toJulianDate(String date){
    return int.parse(date.substring(0,4) + date.substring(5, 7) + date.substring(8, 10));
  }

  static void mergeSortDate(List<EventListing> arr){
      if (arr.length <= 1){
        return;
      }

      int mid = (arr.length / 2).floor() ;
      
      List<EventListing> L = arr.sublist(0, mid);
      List<EventListing> R = arr.sublist(mid, arr.length);
    
      mergeSortDate(L);
      mergeSortDate(R);

      int i = 0;
      int j = 0;
      int k = 0;

      while(i < L.length && j < R.length){
        if (toJulianDate(L[i].dateStart) < toJulianDate(R[j].dateStart)){
          arr[k] = L[i];
          i++;
        }else{
          arr[k] = R[j];
          j++;
        }
        k++;
      }

      while(i < L.length){
        arr[k] = L[i];
        i++;
        k++;
      }

      while(j < R.length){
        arr[k] = R[j];
        j++;
        k++;
      }
  } 
}

Future<List<EventListing>> fetchEvents() async {
  String user = "jwong123";
  String token = "091C1981-05E0-48C6-A3FB-FA579BCFA261";
  String authorization = "$user:$token";
  String encodedToken = base64.encode(utf8.encode(authorization));

  final response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/2023/events'), headers: {"Authorization": "Basic $encodedToken"});

  if(response.statusCode == 200){
    return EventListing.fromJson(json.decode(response.body) as Map<String,dynamic>);
  }else{
    throw Exception(response.statusCode);
  }

}


class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
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
            

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: dataList.length,
              itemBuilder: (context, index){
                final eventListing = dataList[index];
                return ListTile(title: Text(eventListing.name));
              },
            );
          }else{
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      
      
      // Container(
      //   child: Text(allEvents[0].name),
      //   alignment: Alignment.center,
      // )
    );
  }
}