class MissionEffUser {
  DateTime today;
  Result result;

  MissionEffUser({required this.today, required this.result});

  factory MissionEffUser.fromJson(Map<String, dynamic> json) {
    return MissionEffUser(
      today: DateTime.parse(json['today']['date']),
      result: Result.fromJson(json['result']),
    );
  }
}

class Result {
  bool success;
  List<Mission> data;
  String totalHeure;

  Result({required this.success, required this.data, required this.totalHeure});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      success: json['success'],
      data: List<Mission>.from(json['data'].map((x) => Mission.fromJson(x))),
      totalHeure: json['total_heure'],
    );
  }
}
class MissionEffUserResult {
  List<Mission>? missions;
  String? totalHours;

  MissionEffUserResult({this.missions, this.totalHours});
}
class Mission {
  DateTime date;
  String reference;
  String etabli;
  String duree;

  Mission({required this.date, required this.reference, required this.etabli, required this.duree});

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      date: DateTime.parse(json['date']),
      reference: json['reference'],
      etabli: json['etabli'],
      duree: json['duree'],
    );
  }
}
