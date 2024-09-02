import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TeamListing{
  final int teamNumber;
  final int rookieYear;
  final String teamName;
  final String city;
  final String stateProv;
  final String country;
  final String fullTeamName;

  const TeamListing({required this.city, required this.country, required this.rookieYear, required this.stateProv, required this.teamName, required this.teamNumber, required this.fullTeamName});

  String getDisplayLocation(){
    return "$city, $stateProv, $country";
  }

  static Future<TeamListing?> getTeam(String year, int page, int teamNum) async {
    String? user = dotenv.env['USER'];
    String? token = dotenv.env['TOKEN'];
    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    var response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/$year/teams?page=$page'), headers: {"Authorization": "Basic $encodedToken"});

    if(response.statusCode == 200){
      print("API CALL SUCCESS");
      List teams = (json.decode(response.body) as Map<String, dynamic>)['teams'];

      for(var i = 0; i < teams.length; i++){
        if(teams[i]['teamNumber'] == teamNum){
          return singleFromJson(teams[i]);
        }
      }
      return null;
    }else{
      throw Exception("API error ${response.statusCode}");
    }
  }

  static TeamListing singleFromJson(Map<String, dynamic> json){
    return TeamListing(city: json['city'], country: json['country'], rookieYear: json['rookieYear'], stateProv: json['stateProv'], teamName: json['nameShort'], teamNumber: json['teamNumber'], fullTeamName: json['nameFull']);
  }

  static List<TeamListing> fromJson(Map<String, dynamic> json){
    List<TeamListing> allTeams = [];
    List teamList = json['teams'];
    
    for (var i = 0; i < teamList.length; i++){
      allTeams.add(
        TeamListing(
          teamNumber: teamList[i]['teamNumber'],
          rookieYear: teamList[i]['rookieYear'],
          teamName: teamList[i]['nameShort'],
          city: teamList[i]['city'],
          stateProv: teamList[i]['stateProv'],
          country: teamList[i]['country'],
          fullTeamName: teamList[i]['nameFull']
        )
      );
    }   
    
    print("FROM JSON SUCCESS");
    return allTeams;
  }
}

class ExtendedTeamListing extends TeamListing{
  final int year;
  
  ExtendedTeamListing({required this.year, required super.city, required super.country, required super.rookieYear, required super.stateProv, required super.teamName, required super.teamNumber, required super.fullTeamName});
  
  static List<ExtendedTeamListing> fromJson(Map<String, dynamic> json){
    List<ExtendedTeamListing> allTeams = [];
    List teamList = json['teams'];
    
    for (var i = 0; i < teamList.length; i++){
      allTeams.add(
        ExtendedTeamListing(
          teamNumber: teamList[i]['teamNumber'],
          rookieYear: teamList[i]['rookieYear'],
          teamName: teamList[i]['nameShort'],
          city: teamList[i]['city'],
          stateProv: teamList[i]['stateProv'],
          country: teamList[i]['country'],
          fullTeamName: teamList[i]['nameFull'],
          year: teamList[i]['year']
        )
      );
    }   
    
    print("FROM JSON SUCCESS");
    return allTeams;
  }

  Map<String, dynamic> toJson(){
    return {
      'teamNumber': teamNumber,
      'rookieYear': rookieYear,
      'nameShort': teamName,
      'city': city,
      'stateProv': stateProv,
      'country': country,
      'nameFull': fullTeamName,
      'year': year
    };
  }

  @override
  operator ==(o) => o is ExtendedTeamListing && o.teamNumber == teamNumber && o.rookieYear == rookieYear;

}