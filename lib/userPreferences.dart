import 'dart:convert';
import 'package:myapp/data/eventListing.dart';
import 'package:myapp/data/teamListing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences preferences;
  static const teamsKey = "savedTeams";
  static const eventsKey = "savedEvents";

  static Future init() async{
    preferences = await SharedPreferences.getInstance();
    await preferences.reload();
  }

  static Future setSavedEvents(List<ExtendedEventListing> list) async{
    await preferences.setStringList(eventsKey, eventListingToJson(list));
  }

  static List<String> eventListingToJson(List<ExtendedEventListing> events){
    List<String> list = [];
    for(var i = 0; i < events.length; i++){
      list.add(jsonEncode(events[i].toJson()));
    }
    return list;
  }

  static List<ExtendedEventListing> getSavedEvents(){
    if(preferences.getStringList(eventsKey) != null){
      return jsonToEventListing(preferences.getStringList(eventsKey)!);
    }
    return [];
  }

  static List<ExtendedEventListing> jsonToEventListing(List<String> savedEvents){
    String response = '{ "events": [${savedEvents.join(',')}]}';
    return ExtendedEventListing.fromJson(json.decode(response) as Map<String, dynamic>);
  }

  static Future setSavedTeams(List<ExtendedTeamListing> teamList) async{
    await preferences.setStringList(teamsKey, teamListingToJson(teamList));
  }
  
  static List<String> teamListingToJson(List<ExtendedTeamListing> teamList){
    List<String> list = [];
    for (var i = 0; i < teamList.length; i++){
      list.add(jsonEncode(teamList[i].toJson()));
    }
    return list;
  }

  static List<ExtendedTeamListing> getSavedTeams(){
    if(preferences.getStringList(teamsKey) != null){
      return jsonToTeamListing(preferences.getStringList(teamsKey)!);
    }
    return [];
  }

  static List<ExtendedTeamListing> jsonToTeamListing(List<String> savedTeams){
    String response = '{ "teams":  [${savedTeams.join(',')}]}';
    return ExtendedTeamListing.fromJson(json.decode(response) as Map<String, dynamic>); 
  }

}