class TeamEventData{
  final int rank;
  final int teamNumber;
  final String? teamName;
  final int wins;
  final int ties;
  final int losses;
  final double rankingPoints;
  final double tieBreakerPoints;

  const TeamEventData({required this.rank, required this.teamNumber, required this.teamName, required this.wins, required this.ties, required this.losses, required this.rankingPoints, required this.tieBreakerPoints});
  
  static double round(double num){
    if("$num".length > 5){
      return double.parse(num.toStringAsFixed(2));
    }
    return num;
  }

  static List<TeamEventData> fromJson(Map<String, dynamic> json){
    List rankings = json['rankings'];
    List<TeamEventData> teamPlacements = [];

    for(var i = 0; i < rankings.length; i++){
      teamPlacements.add(
        TeamEventData(
          rank: rankings[i]['rank'],
          teamNumber: rankings[i]['teamNumber'],
          teamName: rankings[i]['teamName'], 
          wins: rankings[i]['wins'], 
          ties: rankings[i]['ties'], 
          losses: rankings[i]['losses'], 
          rankingPoints: round(rankings[i]['sortOrder1']), 
          tieBreakerPoints: round(rankings[i]['sortOrder2'])
        )
      );
    }
    return teamPlacements;
  }
}