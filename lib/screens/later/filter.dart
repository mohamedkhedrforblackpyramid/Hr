import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterSelectionPage extends StatefulWidget {
  @override
  _FilterSelectionPageState createState() => _FilterSelectionPageState();
}

class _FilterSelectionPageState extends State<FilterSelectionPage> {
  String? selectedFilter;
  String? selectedEmployee;
  String? selectedCompany;
  DateTime? selectedDate;
  RangeValues salaryRange = RangeValues(3000, 15000);

  List<String> employees = ['Mohamed Khedr', 'shady', 'Tarek'];
  List<String> companies = ['program 4 ', 'alex4prog', 'alexapps'];

  TextEditingController dateController = TextEditingController();
  List<Map<String, String>> filteredResults = [];
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isSubmitted) ...[
              // أزرار اختيار الفلتر
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedFilter = 'employee';
                          });
                        },
                        child: Text('Employee Name'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedFilter = 'company';
                          });
                        },
                        child: Text('Company Name'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedFilter = 'date';
                          });
                        },
                        child: Text('Date'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedFilter = 'salary';
                          });
                        },
                        child: Text('Salary'),
                      ),
                    ],
                  ),
                ),
              ),

              // واجهة الفلترة بناءً على الاختيار
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: selectedFilter != null
                      ? getFilterWidget(selectedFilter)
                      : Center(child: Text('Select a filter')),
                ),
              ),

              // زر تطبيق الفلاتر
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    onPressed: () {
                      filterData();
                    },
                    child: Text('Submit'),
                  ),
                ),
              ),
            ] else ...[
              // عرض النتائج
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: buildResults(),
                ),
              ),

              // زر إعادة الفلترة
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    onPressed: () {
                      setState(() {
                        isSubmitted = false;
                        selectedFilter = null;
                        selectedEmployee = null;
                        selectedCompany = null;
                        selectedDate = null;
                        salaryRange = RangeValues(3000, 15000);
                        dateController.clear();
                      });
                    },
                    child: Text('Filter Again'),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget getFilterWidget(String? filter) {
    switch (filter) {
      case 'employee':
        return ListView(
          children: employees
              .map((employee) => CheckboxListTile(
            title: Text(employee),
            value: selectedEmployee == employee,
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  selectedEmployee = employee;
                } else {
                  selectedEmployee = null;
                }
              });
            },
          ))
              .toList(),
        );
      case 'company':
        return ListView(
          children: companies
              .map((company) => CheckboxListTile(
            title: Text(company),
            value: selectedCompany == company,
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  selectedCompany = company;
                } else {
                  selectedCompany = null;
                }
              });
            },
          ))
              .toList(),
        );
      case 'date':
        return Column(
          children: [
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Choose Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                    dateController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  });
                }
              },
            ),
          ],
        );
      case 'salary':
        return Column(
          children: [
            RangeSlider(
              values: salaryRange,
              min: 0,
              max: 20000,
              divisions: 100,
              labels: RangeLabels(
                salaryRange.start.round().toString(),
                salaryRange.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  salaryRange = values;
                });
              },
            ),
            Text('نطاق الراتب: ${salaryRange.start.round()} - ${salaryRange.end.round()}'),
          ],
        );
      default:
        return Center(child: Text(''));
    }
  }

  void filterData() {
    // تنفيذ عملية الفلترة بناءً على القيم المختارة مثل selectedEmployee وselectedCompany وselectedDate وsalaryRange
    filteredResults = [
      {
        'employee': selectedEmployee ?? 'N/A',
        'company': selectedCompany ?? 'N/A',
        'date': selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : 'N/A',
        'salary': '${salaryRange.start.round()} - ${salaryRange.end.round()}'
      },
    ];

    // Trigger a rebuild to show the results
    setState(() {
      isSubmitted = true;
    });
  }

  Widget buildResults() {
    return ListView.builder(
      itemCount: filteredResults.length,
      itemBuilder: (context, index) {
        final result = filteredResults[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          elevation: 4.0,
          child: ListTile(
            title: Text('Employee: ${result['employee']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Company: ${result['company']}'),
                Text('Date: ${result['date']}'),
                Text('Salary: ${result['salary']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}


