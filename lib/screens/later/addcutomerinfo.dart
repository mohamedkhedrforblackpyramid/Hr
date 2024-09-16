import 'package:flutter/material.dart';
import 'package:hr/screens/later/maps.dart';

class AddClientInfo extends StatefulWidget {
  @override
  _AddClientInfoState createState() => _AddClientInfoState();
}

class _AddClientInfoState extends State<AddClientInfo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  List<String> phoneNumbers = [];
  String meetingOutcome = '';
  String agreementDetails = '';
  DateTime? selectedDate;

  // Date picker function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  // Add phone number to the list
  void _addPhoneNumber() {
    if (_phoneController.text.isNotEmpty) {
      setState(() {
        phoneNumbers.add(_phoneController.text);
        _phoneController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 0,
        backgroundColor: Colors.teal.shade300, // اختيار لون جذاب مثل درجة فاتحة من الأخضر
        title: Text(
          'Add Client Information',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 5.0,
                color: Colors.black26,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        centerTitle: true, // لجعل العنوان في المنتصف
        automaticallyImplyLeading: false,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Client Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the client\'s name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapPage(

                            )));                  },
                  child: TextFormField(
                    enabled: false,
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Client Location',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the location';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Meeting Outcome',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.assignment_turned_in),
                  ),
                  onChanged: (value) {
                    setState(() {
                      meetingOutcome = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Agreements Made',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note_alt),
                  ),
                  onChanged: (value) {
                    setState(() {
                      agreementDetails = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        selectedDate == null
                            ? 'Select Meeting Date'
                            : 'Meeting Date: ${selectedDate.toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 13,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text('Pick Date',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade100),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle saving data
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Data saved successfully')),
                      );
                    }
                  },
                  child: Text('Save Information',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      fontSize: 22
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade100,
                    padding: EdgeInsets.symmetric(vertical: 16),
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
