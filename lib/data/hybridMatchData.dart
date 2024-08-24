class HybridMatchData{
  final List<int> blueTeam;
  final List<int> redTeam;
  final int? scoreRedFinal;
  final int? scoreBlueFinal;
  final int matchNumber;
  final int seriesNumber;
  final int tournamentLevel;
  final bool isRedWin;

  static final Map<String, int> tournamentLevelMap = {
    "QUALIFICATION": 1,
    "SEMIFINAL" : 2,
    "FINAL" : 3,
  };

  const HybridMatchData({required this.blueTeam, required this.redTeam, required this.scoreBlueFinal, required this.scoreRedFinal, required this.matchNumber, required this.seriesNumber, required this.tournamentLevel, required this.isRedWin});

  static List<HybridMatchData> fromJson(Map<String, dynamic> json){
    List schedule = json['schedule'];
    List<HybridMatchData> scheduleList = [];

    for(var i = 0; i < schedule.length; i++){
      List<int> blueTeam = [];
      List<int> redTeam = [];

      List teams = schedule[i]['teams'];
      for(var j = 0; j < teams.length; j++){
        if(teams[j]['station']!.startsWith("Red")){
          redTeam.add(teams[j]['teamNumber'] ?? 0);
        }else{
          blueTeam.add(teams[j]!['teamNumber'] ?? 0);
        }
      }

      scheduleList.add(
        HybridMatchData(
          blueTeam: blueTeam, 
          redTeam: redTeam, 
          scoreBlueFinal: schedule[i]['scoreBlueFinal'] ?? 0, 
          scoreRedFinal: schedule[i]['scoreRedFinal'] ?? 0,
          matchNumber: schedule[i]['matchNumber'],
          seriesNumber: schedule[i]['series'],
          tournamentLevel: tournamentLevelMap[schedule[i]['tournamentLevel']]!,
          isRedWin: schedule[i]['redWins']
        )
      );
    }
    print("FROM JSON SUCCESS");
    return scheduleList;
  }
}



// class TeamMatchData{
//   final int teamNumber;
//   final String teamName;

// }