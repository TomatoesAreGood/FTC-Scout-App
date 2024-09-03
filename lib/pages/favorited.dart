import 'package:flutter/material.dart';
import 'package:myapp/data/eventListing.dart';
import 'package:myapp/data/teamListing.dart';
import 'package:myapp/main.dart';
import 'package:myapp/pages/eventSubpage.dart';
import 'package:myapp/pages/teamSubpage.dart';
import 'package:myapp/widgets/drawer.dart';

class Favorited extends StatefulWidget {
  const Favorited({super.key});

  @override
  State<Favorited> createState() => _FavoritedState();
}

class _FavoritedState extends State<Favorited> {

  List<Column> generateListTilesEvents(List<ExtendedEventListing> weekListings){
    List<Column> listings = [];
    int i = 0;
    while(i < weekListings.length){
      String code = weekListings[i].code;
      String name = weekListings[i].name;
      String country = weekListings[i].country;
      String city = weekListings[i].city;
      String dateStart = weekListings[i].dateStart;
      String? venue = weekListings[i].venue;
      String dateEnd = weekListings[i].dateEnd;
      String? website = weekListings[i].website;
      String? liveStream = weekListings[i].liveStream;
      int type = weekListings[i].type;
      int year = weekListings[i].year;

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
                  print(year);
                  print(code);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => 
                        EventSubpage(data:ExtendedEventListing(city: city, code: code, country: country, dateStart: dateStart, name: name, type: type, year: year, venue: venue, dateEnd: dateEnd, liveStream: liveStream, website: website))
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

  List<Column> generateListTilesTeams(List<ExtendedTeamListing> teamListings){
    List<Column> listings = [];
    int i = 0;
    while(i < teamListings.length){
      int teamNumber = teamListings[i].teamNumber;
      int rookieYear = teamListings[i].rookieYear;
      int year = teamListings[i].year;
      String teamName = teamListings[i].teamName;
      String city = teamListings[i].city;
      String stateProv = teamListings[i].stateProv;
      String country = teamListings[i].country;
      String fullTeamName = teamListings[i].fullTeamName;
      listings.add(
        Column (
          children: [
            Tooltip(
              message: teamName,
              child: ListTile(
                leading: SizedBox(width: 80, child: Text("$teamNumber", style: const TextStyle(fontSize: 21), textAlign: TextAlign.center,)),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(teamName, overflow: TextOverflow.ellipsis,),
                    Text(teamListings[i].getDisplayLocation(), style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),)
                  ],
                ),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => 
                        TeamSubpage(data:ExtendedTeamListing(teamNumber: teamNumber, rookieYear: rookieYear, teamName: teamName, city: city, stateProv: stateProv, country: country, fullTeamName: fullTeamName, year: year))
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
        Column(children: generateListTilesEvents(MyApp.favoritedEvents))
      ],
    );
  }

  Widget generateTeams(){
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("Teams", style: TextStyle(fontSize: 22)),
        ),
        Container(height: 6, color: Colors.lightBlue),
        Column(children: generateListTilesTeams(MyApp.favoritedTeams))
      ],
    );
  }

  Widget generateScaffold(){
    return ListView(
      children:[
        MyApp.favoritedEvents.isNotEmpty ? const Padding(padding: EdgeInsets.all(5)): Container(height: 0),
        MyApp.favoritedEvents.isNotEmpty ? generateEvents(): Container(height: 0),
        MyApp.favoritedTeams.isNotEmpty ? const Padding(padding: EdgeInsets.all(5)): Container(height: 0),
        MyApp.favoritedTeams.isNotEmpty ? generateTeams(): Container(height: 0,)
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text("Favorited"),
        backgroundColor: Colors.lightGreen,
      ),
      body: MyApp.favoritedEvents.isEmpty && MyApp.favoritedTeams.isEmpty ? const Center(child: Text("Favorited events and teams will show up here")): generateScaffold()
    );
  }
}
