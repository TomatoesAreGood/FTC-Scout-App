import 'dart:convert';
import 'package:myapp/data/eventListing.dart';
import 'package:myapp/data/teamListing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences preferences;
  static const teamsKey = "savedTeams";

  static Future init() async{
    preferences = await SharedPreferences.getInstance();
  }

  static Future setSavedEvents(List<ExtendedEventListing> list) async{
    await preferences.setStringList("savedEvents", eventListingToJson(list));
  }

  static List<String> eventListingToJson(List<ExtendedEventListing> events){
    List<String> list = [];
    for(var i = 0; i < events.length; i++){
      list.add(jsonEncode(events[i].toJson()));
    }
    return list;
  }

  static List<ExtendedEventListing> getSavedEvents(){
    preferences.reload();
    if(preferences.getStringList("savedEvents") != null){
      return jsonToEventListing(preferences.getStringList("savedEvents")!);
    }
    return [];
  }

  static List<ExtendedEventListing> jsonToEventListing(List<String> savedEvents){
    String response = '{ "events": [${savedEvents.join(',')}]}';
    return ExtendedEventListing.fromJson(json.decode(response) as Map<String, dynamic>);
  }

  static Future setSavedTeams(List<ExtendedTeamListing> teamList)  async{
    print(teamListingToJson(teamList));
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
    preferences.reload();
    if(preferences.getStringList(teamsKey) != null){
      print(preferences.getStringList(teamsKey));
      return jsonToTeamListing(preferences.getStringList(teamsKey)!);
    }
    return [];
  }

  static List<ExtendedTeamListing> jsonToTeamListing(List<String> savedTeams){
    String response = '{ "teams":  [${savedTeams.join(',')}]}';
    return ExtendedTeamListing.fromJson(json.decode(response) as Map<String, dynamic>); 
  }

}