// import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import '../eventListing.dart';
import '../main.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

dynamic fetchEvents(String year) async {
  if(MyApp.yearlyEventListings.containsKey(year)){
    return MyApp.yearlyEventListings[year];
  }

  String user = "jwong123";
  String token = "091C1981-05E0-48C6-A3FB-FA579BCFA261";
  String authorization = "$user:$token";
  String encodedToken = base64.encode(utf8.encode(authorization));

  final response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/$year/events'), headers: {"Authorization": "Basic $encodedToken"});

  if(response.statusCode == 200){
    print("API CALL SUCCESS");
    List<EventListing> eventList = EventListing.fromJson(json.decode(response.body) as Map<String,dynamic>);
    addKVPToYearlyListing(year, eventList);
    return eventList;
  }else{
    throw Exception(response.statusCode);
  }
}

void addKVPToYearlyListing(String year, List<EventListing> eventList){
  if(!MyApp.yearlyEventListings.containsKey(year)){
      MyApp.yearlyEventListings[year] = eventList;
  }} 

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

List<ListTile> generateListTiles(List<EventListing> weekListings){
  List<ListTile> listings = [];
  int i = 0;
  while(i < weekListings.length){
    listings.add(ListTile(
      title: Text(weekListings[i].name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${weekListings[i].city}, ${weekListings[i].country}"),
          Text(weekListings[i].dateStart)
        ],
      ),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black,width: 1),
        borderRadius: BorderRadius.circular(1),
      ),
    ));
    i++;
  }
  return listings;
}


class _EventsState extends State<Events> {
  late dynamic allEventListings;
  List<String> monthStrings = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

  @override
  void initState(){
    allEventListings = fetchEvents("2023");
    super.initState();
  }

  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(allEventListings is List<EventListing>){
      EventListing.mergeSortDate(allEventListings);
      List<List<EventListing>> weeks = splitWeeks("2023-09-09", allEventListings);

      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: weeks.length,
        itemBuilder: (context, index){
          List<EventListing> weekListings = weeks[index];
          int endDay = EventListing.getJulianDate("2023-09-09") + index*7;
          int startDay = endDay - 6;

          DateTime end = DateTime.utc(0,0,endDay);
          DateTime start = DateTime.utc(0,0,startDay);

          if(weekListings.isNotEmpty){
            return Column(
              children: [
                ExpansionTile(
                  title: Text("Week ${index+1}"),
                  subtitle: getDateRange(start, end, monthStrings),
                  collapsedBackgroundColor: const Color.fromARGB(255, 197, 197, 197),
                  children:generateListTiles(weekListings),
                ), 
                const Padding(padding: EdgeInsets.all(1))
              ],
            );
          }else{
            return const Padding(padding: EdgeInsets.all(0));
          }
        },
      );
    }else{
      return Scaffold(
        body: FutureBuilder<dynamic>(
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
                  List<EventListing> weekListings = weeks[index];
                  int endDay = EventListing.getJulianDate("2023-09-09") + index*7;
                  int startDay = endDay - 6;

                  DateTime end = DateTime.utc(0,0,endDay);
                  DateTime start = DateTime.utc(0,0,startDay);

                  if(weekListings.isNotEmpty){
                    return Column(
                      children: [
                        ExpansionTile(
                          title: Text("Week ${index+1}"),
                          subtitle: getDateRange(start, end, monthStrings),
                          collapsedBackgroundColor: const Color.fromARGB(255, 197, 197, 197),
                          children:generateListTiles(weekListings),
                        ), 
                        const Padding(padding: EdgeInsets.all(1))
                      ],
                    );
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
}