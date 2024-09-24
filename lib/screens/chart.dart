import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../network/remote/dio_helper.dart';
import 'package:hr/modules/chartsmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Charts extends StatefulWidget {
  final int? userId;
  final int? organizationId;
  final String? personType;
  final int? vacancesCount;
  final int? permitsPermission;
  final dynamic oranizaionsList;
  final String? organizationsName;
  final String? organizationsArabicName;

  Charts({
    required this.userId,
    required this.personType,
    required this.organizationId,
    required this.vacancesCount,
    required this.permitsPermission,
    required this.oranizaionsList,
    required this.organizationsName,
    required this.organizationsArabicName,
  });

  @override
  _ChartsState createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  bool chartLoading = false;
  List<ChartsModel>? chartData;
  DateTime dateFrom = DateTime.now();
  DateTime dateTo = DateTime.now();
  String? topPerformerName; // To hold the name of the top performer

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.cyan,
    Colors.pink,
    Colors.brown,
    Colors.teal,
  ];

  final PageController _pageController = PageController();

  void _initializeDates() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    setState(() {
      dateFrom = firstDayOfMonth;
      dateTo = lastDayOfMonth;
    });
  }

  void getChartsByAttendanceTime(DateTime from, DateTime to) {
    setState(() {
      chartLoading = true;
    });
    DioHelper.getData(
      url: "api/employee-stats?organization_id=${widget.organizationId}&from=${from.toLocal().toIso8601String()}&to=${to.toLocal().toIso8601String()}",
    ).then((response) {
      setState(() {
        chartData = (response.data['data'] as List)
            .map((item) => ChartsModel.fromJson(item))
            .where((data) => data.total_attendance_time != null && data.total_attendance_time > 0)
            .toList();

        chartData!.sort((a, b) => b.total_attendance_time.compareTo(a.total_attendance_time));
        topPerformerName = chartData!.isNotEmpty ? chartData!.first.name : null;

        chartLoading = false;
        print(response.data);
        print('Number of layers by attendance time: ${chartData!.length}');
      });
    }).catchError((error) {
      print(error.response.data);
      setState(() {
        chartLoading = false;
      });
    });
  }

  void getChartsByAttendancePercentage(DateTime from, DateTime to) {
    setState(() {
      chartLoading = true;
    });
    DioHelper.getData(
      url: "api/employee-stats?organization_id=${widget.organizationId}&from=${from.toLocal().toIso8601String()}&to=${to.toLocal().toIso8601String()}",
    ).then((response) {
      setState(() {
        chartData = (response.data['data'] as List)
            .map((item) => ChartsModel.fromJson(item))
            .where((data) => data.attendance_pecentage != null && data.attendance_pecentage > 0)
            .toList();

        chartData!.sort((a, b) => b.attendance_pecentage.compareTo(a.attendance_pecentage));
        topPerformerName = chartData!.isNotEmpty ? chartData!.first.name : null;

        chartLoading = false;
        print(response.data);
        print('Number of layers by attendance percentage: ${chartData!.length}');
      });
    }).catchError((error) {
      print(error.response.data);
      setState(() {
        chartLoading = false;
      });
    });
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate, Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      setState(() {
        onDateSelected(picked);
        if (_pageController.page == 0) {
          getChartsByAttendanceTime(dateFrom, dateTo);
        } else {
          getChartsByAttendancePercentage(dateFrom, dateTo);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeDates();
    getChartsByAttendanceTime(dateFrom, dateTo); // أو getChartsByAttendancePercentage بناءً على الصفحة
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            if (index == 0) {
              getChartsByAttendanceTime(dateFrom, dateTo);
            } else {
              getChartsByAttendancePercentage(dateFrom, dateTo);
            }
          },
          children: [
            _buildChartPage(),
            _buildChartPagePercentage(),
          ],
        ),
      ),
    );
  }
  Widget _buildTopPerformer() {
    if (topPerformerName == null) return Container();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.emoji_events, color: Colors.amber, size: 30), // Crown icon
        SizedBox(width: 8),
        Text(
          '$topPerformerName',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
  Widget _buildChartPage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, dateFrom, (selectedDate) {
                    setState(() {
                      dateFrom = selectedDate;
                    });
                    getChartsByAttendanceTime(dateFrom, dateTo);
                  }),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(text: "${dateFrom.toLocal()}".split(' ')[0]),
                      decoration: InputDecoration(
                        labelText: '${AppLocalizations.of(context)!.dateFrom}',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.teal, width: 1.5),
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, dateTo, (selectedDate) {
                    setState(() {
                      dateTo = selectedDate;
                    });
                    getChartsByAttendanceTime(dateFrom, dateTo);
                  }),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(text: "${dateTo.toLocal()}".split(' ')[0]),
                      decoration: InputDecoration(
                        labelText: '${AppLocalizations.of(context)!.dateTo}',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.teal, width: 1.5),
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: chartLoading
                ? Center(
              child: Container(
                width: 60,
                height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 6,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                    ),
                    Positioned(
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          strokeWidth: 6,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                : chartData == null || chartData!.isEmpty
                ? Center(child: Text('No Data Found', style: TextStyle(fontSize: 16, color: Colors.grey)))
                : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: SfPyramidChart(
                title: ChartTitle(
                  text: '${AppLocalizations.of(context)!.attendanceTimeInHours}',
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                legend: Legend(
                  isResponsive: false,
                  isVisible: true,
                  position: LegendPosition.right,
                  textStyle: TextStyle(fontSize: 10, color: Colors.black54),
                ),
                series: PyramidSeries<ChartsModel, String>(
                  height: '${chartData!.length * 10}%',
                  width: '50%',
                  explodeOffset: '5%',
                  explodeIndex: 2,
                  dataSource: chartData!,
                  xValueMapper: (ChartsModel data, _) => data.name,
                  yValueMapper: (ChartsModel data, _) => data.total_attendance_time,
                  pointColorMapper: (ChartsModel data, int index) {
                    return colors[index % colors.length];
                  },
                  gapRatio: 0.05,
                  pyramidMode: PyramidMode.linear,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.middle,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 9, // Adjusted font size for better fit
                    ),
                    labelIntersectAction: LabelIntersectAction.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartPagePercentage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, dateFrom, (selectedDate) {
                    setState(() {
                      dateFrom = selectedDate;
                    });
                    getChartsByAttendancePercentage(dateFrom, dateTo);
                  }),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(text: "${dateFrom.toLocal()}".split(' ')[0]),
                      decoration: InputDecoration(
                        labelText: '${AppLocalizations.of(context)!.dateFrom}',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.teal, width: 1.5),
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, dateTo, (selectedDate) {
                    setState(() {
                      dateTo = selectedDate;
                    });
                    getChartsByAttendancePercentage(dateFrom, dateTo);
                  }),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(text: "${dateTo.toLocal()}".split(' ')[0]),
                      decoration: InputDecoration(
                        labelText: '${AppLocalizations.of(context)!.dateTo}',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.teal, width: 1.5),
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          Expanded(
            child: chartLoading
                ? Center(
              child: Container(
                width: 60,
                height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 6,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                    ),

                    Positioned(
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          strokeWidth: 6,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            )
                : chartData == null || chartData!.isEmpty
                ? Center(child: Text('No Data Found', style: TextStyle(fontSize: 16, color: Colors.grey)))
                : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: SfPyramidChart(
                title: ChartTitle(
                  text: '${AppLocalizations.of(context)!.attendancePercentage}',
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                legend: Legend(
                  isResponsive: false,
                  isVisible: true,
                  position: LegendPosition.right,
                  textStyle: TextStyle(fontSize: 10, color: Colors.black54),
                ),
                series: PyramidSeries<ChartsModel, String>(
                  height: '${chartData!.length * 10}%',
                  width: '50%',
                  explodeOffset: '5%',
                  explodeIndex: 2,
                  dataSource: chartData!,
                  xValueMapper: (ChartsModel data, _) => data.name,
                  yValueMapper: (ChartsModel data, _) => data.attendance_pecentage,
                  pointColorMapper: (ChartsModel data, int index) {
                    return colors[index % colors.length];
                  },
                  gapRatio: 0.05,
                  pyramidMode: PyramidMode.linear,
                  dataLabelSettings: DataLabelSettings(

                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.middle,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                    labelIntersectAction: LabelIntersectAction.none,
                 /*   builder: (data, point, series, pointIndex, seriesIndex) {
                      return Text(
                        '${data.attendance_pecentage}%',
                        style: TextStyle(
                          fontSize: 10,
                          color: colors[pointIndex % colors.length], // Match label color to layer color
                        ),
                      );// Add "%" to the label
                    },*/
                  ),
                  ),
                ),

              ),

          ),
        ],
      ),
    );
  }
}
