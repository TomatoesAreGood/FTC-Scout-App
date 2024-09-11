import 'package:flutter/material.dart';
import 'package:myapp/data/teamListing.dart';
import 'package:myapp/pages/events.dart';
import 'package:myapp/pages/favorited.dart';
import 'package:myapp/pages/loginPage.dart';
import 'package:myapp/pages/teams.dart';
import 'package:myapp/userPreferences.dart';
import 'data/eventListing.dart';
import 'data/sizeConfig.dart';

class YearlyTeamListing{
  int page;
  final List<TeamListing> teams;

  YearlyTeamListing ({required this.page, required this.teams});
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
 static final Map<String, String> yearlyStartDates = {
    "2019":"2019-09-07",
    "2020":"2020-09-12",
    "2021":"2021-09-18",
    "2022":"2022-09-10",
    "2023":"2023-09-09",
    "2024":"2024-09-07"
  };

  static Map<String, List<EventListing>> yearlyEventListings = {};
  static Map<String, YearlyTeamListing> yearlyTeamListings = {};

  static List<ExtendedEventListing> favoritedEvents = [];
  static List<ExtendedTeamListing> favoritedTeams = [];

  static String? eventsYear;
  static bool? isEventsFiltersExpanded;
  static String? countryFilter;
  static int? typeFilter;

  static String? teamsYear;
  static bool? isTeamsFiltersExpanded;

  const MyApp({super.key});

  static int findObject(List? list, Object obj){
    if(list == null){
      return -1;
    }

    for(var i = 0; i < list.length; i++){
      if(list[i] == obj){
        return i;
      }
    }

    return -1;
  }

  static void updateFavoritedEvents(){
    UserPreferences.setSavedEvents(MyApp.favoritedEvents);
  }

  static void updateFavoritedTeams(){
    UserPreferences.setSavedTeams(MyApp.favoritedTeams);
  }

  static reload(BuildContext context){
    return Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (BuildContext context) => const MyApp())
    );
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;
  final PageStorageBucket bucket = PageStorageBucket();

  void onItemTapped(int index){
    if(selectedIndex != index){
       setState((){
        selectedIndex = index;
      });
    }
  }
  
  @override
  void initState(){
    MyApp.favoritedEvents = UserPreferences.getSavedEvents();
    MyApp.favoritedTeams = UserPreferences.getSavedTeams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig.init(constraints, orientation);

            if(!UserPreferences.hasSavedCredentials()){ 
              return MaterialApp(
                home: LoginPage(),
              );
            }

            late Widget bottomNavigationBar;

            BottomNavigationBar defaultNavBar = BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.calendar_month),label: "Events"),
                BottomNavigationBarItem(icon: Icon(Icons.group), label: "Teams"),
                BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favorited"),
              ],
              currentIndex: selectedIndex,
              onTap: onItemTapped,
            );
            
           SizedBox phoneSizedNavBar =  SizedBox(
              height: SizeConfig.heightMultiplier * 12,
              child: BottomNavigationBar(
                iconSize: SizeConfig.heightMultiplier * 5.5,
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

            SizedBox sizedNavBar =  SizedBox(
              height: SizeConfig.heightMultiplier * 8.5,
              child: BottomNavigationBar(
                iconSize: SizeConfig.heightMultiplier * 3.5,
                unselectedFontSize: SizeConfig.heightMultiplier * 2,
                selectedFontSize: SizeConfig.heightMultiplier * 2,
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
              bottomNavigationBar = defaultNavBar; 
            }else if(SizeConfig.isMobileLandscape){
              bottomNavigationBar = phoneSizedNavBar;
            }else{
              bottomNavigationBar = sizedNavBar;
            }
            
            return MaterialApp(
              home: SafeArea(
                child: Scaffold(
                    bottomNavigationBar: bottomNavigationBar,
                    body: PageStorage(bucket: bucket, child: [const Events(key: PageStorageKey<String>("pageOne")), const Teams(key: PageStorageKey<String>("pageTwo")), const Favorited()][selectedIndex])
                ),
              )
            );
          }
        );
      }
    );
  }
}