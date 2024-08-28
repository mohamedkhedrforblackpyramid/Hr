import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../network/remote/dio_helper.dart';
import 'package:hr/modules/chartsmodel.dart';

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

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.cyan,
    Colors.pink,
    Colors.brown,
    Colors.teal,
  ];

  void _initializeDates() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    setState(() {
      dateFrom = firstDayOfMonth;
      dateTo = lastDayOfMonth;
    });
  }

  void getCharts() {
    setState(() {
      chartLoading = true;
    });
    DioHelper.getData(
      url: "api/employee-stats?organization_id=${widget.organizationId}&from=${dateFrom.toLocal().toIso8601String()}&to=${dateTo.toLocal().toIso8601String()}",
    ).then((response) {
      setState(() {
        chartData = (response.data['data'] as List)
            .map((item) => ChartsModel.fromJson(item))
            .where((data) => data.total_attendance_time != null && data.total_attendance_time > 0)
            .toList();

        chartData!.sort((a, b) => b.total_attendance_time.compareTo(a.total_attendance_time));

        chartLoading = false;
        print(response.data);
        print('Number of layers: ${chartData!.length}');
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
        getCharts();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeDates();
    getCharts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          
          body: Padding(
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
                          dateFrom = selectedDate;
                          getCharts();
                        }),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: TextEditingController(text: "${dateFrom.toLocal()}".split(' ')[0]),
                            decoration: InputDecoration(
                              labelText: 'Date From',
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
                          dateTo = selectedDate;
                          getCharts();
                        }),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: TextEditingController(text: "${dateTo.toLocal()}".split(' ')[0]),
                            decoration: InputDecoration(
                              labelText: 'Date To',
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
                      ? Center(child: CircularProgressIndicator())
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
                        text: 'Attendance Time in Hour',
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
          ),
        ),
      ),
    );
  }
}
