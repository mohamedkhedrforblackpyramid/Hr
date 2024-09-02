import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Salary extends StatelessWidget {
  final int? userId;
  final int? organizationId;
  final String? personType;
  final int? vacancesCount;
  final int? permitsPermission;
  final dynamic oranizaionsList;
  final String? organizationsName;
  final String? organizationsArabicName;
  Salary({
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // خلفية الشاشة
      body: Center(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: 350,
          padding: EdgeInsets.all(50.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
                radius: 40,
                backgroundColor: Colors.white,
              ),
              SizedBox(height: 16),
              Text(
                'Mohamed Khedr',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),

              SizedBox(height: 24),
              buildSalaryDetailRow('${AppLocalizations.of(context)!.salary}', '1,000 EGP', Colors.grey[100]!),
              SizedBox(height: 12),
              buildSalaryDetailRow('${AppLocalizations.of(context)!.totalOverTime}', '+500 EGP', Colors.green[100]!),
              SizedBox(height: 12),
              buildSalaryDetailRow('${AppLocalizations.of(context)!.deduction}', '-200 EGP', Colors.red[100]!),
              SizedBox(height: 16),
              Divider(color: Colors.white54),
              SizedBox(height: 16),
              buildTotalRow('${AppLocalizations.of(context)!.total}', '1300 EGP',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSalaryDetailRow(String title, String value, Color backgroundColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTotalRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }
}


