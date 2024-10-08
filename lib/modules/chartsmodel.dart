class ChartsModel {
  int? user_id;
  String? name;
  dynamic total_attendance_time;
  dynamic attendance_pecentage;
  ChartsModel({
    this.user_id,
    this.name,
    this.total_attendance_time,
    this.attendance_pecentage

  });
  ChartsModel.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    name = json['name'];
    total_attendance_time = json['total_attendance_time']?.toDouble();
    attendance_pecentage=json['attendance_pecentage'];


  }
}

class ChartsList {
  List<ChartsModel>? chartList;
  ChartsList({this.chartList});
  factory ChartsList.fromJson(List<dynamic> parsedJson) {
    List<ChartsModel> charts;
    charts = parsedJson.map((i) => ChartsModel.fromJson(i)).toList();
    return ChartsList(chartList: charts);
  }
}
