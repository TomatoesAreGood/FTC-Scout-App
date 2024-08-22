class TeamListing{
  final int teamNumber;
  final int rookieYear;
  final String teamName;
  final String city;
  final String stateProv;
  final String country;

  const TeamListing({required this.city, required this.country, required this.rookieYear, required this.stateProv, required this.teamName, required this.teamNumber});

  String getDisplayLocation(){
    return "$city, $stateProv, $country";
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
          country: teamList[i]['country']
        )
      );
    }   
    
    // print("FROM JSON SUCCESS");
    return allTeams;
  }
}