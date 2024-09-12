import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class CompanyLocationPage extends StatefulWidget {
  @override
  _CompanyLocationPageState createState() => _CompanyLocationPageState();
}

class _CompanyLocationPageState extends State<CompanyLocationPage> {
  LatLng _currentLocation = LatLng(0, 0);
  late LatLng _selectedLocation;
  bool _isLoading = true;
   String? _selectedCompany;

  List<String> _companies = ['Company A', 'Company B', 'Company C'];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _selectedLocation = _currentLocation; // الموقع الافتراضي
        _isLoading = false;
      });
    } catch (e) {
      print("Error obtaining location: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // عند اختيار موقع جديد على الخريطة
  void _onMapTap(LatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // قائمة منسدلة لاختيار اسم الشركة
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: _selectedCompany,
                hint: Text("Select your company"),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCompany = newValue!;
                  });
                },
                items: _companies.map((company) {
                  return DropdownMenuItem<String>(
                    value: company,
                    child: Text(company),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Company",
                ),
              ),
            ),
      
            // عرض الخريطة
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _selectedLocation,
                  initialZoom: 13.0,
                    onTap: (tapPosition, latLng) {
                      _onMapTap(latLng); // قم باستدعاء الدالة وتمرير LatLng
                    },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _selectedLocation,
                        child:  Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      
            // زر تأكيد الموقع
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // هنا يمكنك استخدام _selectedLocation و _selectedCompany حسب الحاجة
                  print('Selected Company: $_selectedCompany');
                  print('Selected Location: $_selectedLocation');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue, padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16), // حجم التباعد الداخلي
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // شكل الزر الدائري
                  ), // لون النص
                  shadowColor: Colors.blueAccent, // لون الظل
                  elevation: 8, // ارتفاع الظل
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Confirm this location",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // لتحديد سماكة النص
                      ),
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
