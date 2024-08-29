import 'package:flutter/material.dart';
import 'package:myapp/data/eventListing.dart';
import 'package:myapp/main.dart';
import 'package:myapp/pages/eventSubpage.dart';

class Favorited extends StatefulWidget {
  const Favorited({super.key});

  @override
  State<Favorited> createState() => _FavoritedState();
}

class _FavoritedState extends State<Favorited> {
  List<Column> generateListTiles(List<EventListing> weekListings){
    List<Column> listings = [
      Column(
        children: [
          Container(
            height: 1,
            color: Colors.black,
          )
        ]
      )
    ];
    int i = 0;
    while(i < weekListings.length){
      String code = weekListings[i].code;
      String name = weekListings[i].name;
      String country = weekListings[i].country;
      String city = weekListings[i].city;
      String dateStart = weekListings[i].dateStart;
      int type = weekListings[i].type;
      listings.add(
        Column (
          children: [
            Tooltip(
              message: name,
              child: ListTile(
                title: Text(weekListings[i].name, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$city, $country"),
                    Text(dateStart)
                  ],
                ),
                onTap: (){
                  print(name);
                  print(int.parse(dateStart.substring(0,4)));
                  print(code);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => 
                        EventSubpage(data:EventListing(city: city, code: code, country: country, dateStart: dateStart, name: name, type: type),)
                    )
                  ).then((_){setState((){});});
                },
              ),
            ), 
            Container(
              height: 1,
              color: Colors.black,
            )
          ],
        ) 
      );
      i++;
    }
    return listings;
  }

  Widget generateEvents(){
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("Events", style: TextStyle(fontSize: 22)),
        ),
        Container(height: 6, color: Colors.lightBlue),
        Column(children: generateListTiles(MyApp.favoritedEvents))
      ],
    );
  }

  Widget generateScaffold(){
    return Column(
      children:[
        MyApp.favoritedEvents.isNotEmpty ? generateEvents(): Container(height: 0),

      ]
       
      
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("Favorited"),
        backgroundColor: Colors.lightGreen,
      ),
      body: MyApp.favoritedEvents.isEmpty ? const Center(child: Text("Favorited events and teams will show up here")): generateScaffold()
    );
  }
}
