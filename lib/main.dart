import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/data/teamListing.dart';
import 'package:myapp/pages/eventSubpage.dart';
import 'package:myapp/pages/events.dart';
import 'package:myapp/pages/favorited.dart';
import 'package:myapp/pages/teams.dart';
import 'data/eventListing.dart';
import 'data/sizeConfig.dart';

class YearlyTeamListing{
  int page;
  final List<TeamListing> teams;

  YearlyTeamListing ({required this.page, required this.teams});
}

void main() async{
  await dotenv.load(fileName: "lib/.env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static Map<String, List<EventListing>> yearlyEventListings = {};
  static Map<String, YearlyTeamListing> yearlyTeamListings = {};

  static final Map<String, String> yearlyStartDates = {
    "2019":"2019-09-07",
    "2020":"2020-09-12",
    "2021":"2021-09-18",
    "2022":"2022-09-10",
    "2023":"2023-09-09",
    "2024":"2024-09-07"
  };

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;

  void onItemTapped(int index){
    setState((){
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig.init(constraints, orientation);
            var selectedNavBar;

            BottomNavigationBar navBar = BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.calendar_month),label: "Events"),
                BottomNavigationBarItem(icon: Icon(Icons.group), label: "Teams"),
                BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favorited"),
              ],
              currentIndex: selectedIndex,
              onTap: onItemTapped,
            );
            SizedBox sizedNavBar =  SizedBox(
              height: 12 * SizeConfig.heightMultiplier,
              child: BottomNavigationBar(
                iconSize: SizeConfig.heightMultiplier * 5,
                unselectedFontSize: SizeConfig.heightMultiplier * 2.5,
                selectedFontSize: SizeConfig.heightMultiplier * 2.5,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.calendar_month),label: "Events"),
                  BottomNavigationBarItem(icon: Icon(Icons.group), label: "Teams"),
                  BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favorited"),
                ],
                currentIndex: selectedIndex,
                onTap: onItemTapped,
              ),
            );

            if(SizeConfig.isMobilePortrait){
              selectedNavBar = navBar;
            }else{
              selectedNavBar = sizedNavBar;
            }
            return MaterialApp(
              home: SafeArea(
                child: Scaffold(
                    bottomNavigationBar: selectedNavBar,
                    body: <Widget>[Events(), Teams(), Favorited()][selectedIndex]
                ),
              )
            );
          }
        );
      }
    );
  }
}