import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng _currentLocation = LatLng(0, 0);
  LatLng? _selectedLocation;
  bool _isLoading = true;
  String? _selectedCompany;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = []; // لتخزين نتائج البحث
  String _currentCountryCode = ''; // لتخزين رمز البلد الحالي
  final MapController _mapController = MapController();
  double _currentZoom = 13.0; // لتخزين مستوى التكبير الحالي

  List<String> _companies = ['Company A', 'Company B', 'Company C'];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      print('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
        });
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      print('Location permissions are permanently denied.');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _selectedLocation = _currentLocation;
        _isLoading = false;
      });

      // الحصول على رمز البلد بناءً على الموقع الحالي
      await _getCurrentCountryCode();
    } catch (e) {
      print("Error obtaining location: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentCountryCode() async {
    final url = 'https://nominatim.openstreetmap.org/reverse?lat=${_currentLocation.latitude}&lon=${_currentLocation.longitude}&format=json';
    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);
      setState(() {
        _currentCountryCode = data['address']['country_code'] ?? '';
      });
    } catch (e) {
      print('Error getting country code: $e');
    }
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) {
      // إذا كان حقل البحث فارغًا، حدد موقعك الحالي
      setState(() {
        _selectedLocation = _currentLocation;
        _mapController.move(_currentLocation, _currentZoom); // تحريك الخريطة إلى موقعك الحالي
      });
      return;
    }

    final url =
        'https://nominatim.openstreetmap.org/search?q=$query&countrycodes=$_currentCountryCode&format=json&limit=5';
    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      setState(() {
        _searchResults = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      print('Error searching location: $e');
    }
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
      _mapController.move(latLng, _currentZoom);
    });
  }

  void _onMapMove( position) {
    setState(() {
      _currentZoom = position.zoom; // تحديث مستوى التكبير الحالي
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            children: [
              // حقل إدخال البحث عن المكان
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for a location...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        _searchLocation(query); // البحث أثناء الكتابة
                      },
                    ),
                    // عرض الاقتراحات بناءً على نتائج البحث
                    _searchResults.isNotEmpty
                        ? Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          var result = _searchResults[index];
                          return ListTile(
                            title: Text(result['display_name']),
                            onTap: () {
                              double lat = double.parse(result['lat']);
                              double lon = double.parse(result['lon']);
                              setState(() {
                                _selectedLocation = LatLng(lat, lon);
                                _searchController.text = result['display_name'];
                                _searchResults.clear(); // إخفاء النتائج بعد الاختيار
                                _mapController.move(LatLng(lat, lon), _currentZoom); // تحريك الخريطة إلى الموقع الجديد
                              });
                            },
                          );
                        },
                      ),
                    )
                        : SizedBox(),
                  ],
                ),
              ),
              // عرض الخريطة
              Container(
                height: MediaQuery.of(context).size.height * 0.7, // تعيين ارتفاع الخريطة
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLocation ?? _currentLocation,
                    initialZoom: _currentZoom, // تعيين مستوى التكبير الحالي
                    onTap: (tapPosition, latLng) {
                      _onMapTap(latLng);
                    },
                    onPositionChanged: (position, _) {
                      _onMapMove(position); // تحديث مستوى التكبير عند تحريك الخريطة
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: _selectedLocation ?? _currentLocation,
                          child: Icon(
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
                    print('Selected Company: $_selectedCompany');
                    print('Selected Location: $_selectedLocation');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    shadowColor: Colors.blueAccent,
                    elevation: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Confirm this location",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
