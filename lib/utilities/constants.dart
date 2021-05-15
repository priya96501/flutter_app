import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

final kHintTextStyle = TextStyle(
  color: Colors.black26,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.black54,
  letterSpacing: 0.5,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

const kPrimaryColor = Colors.lightGreen;

const kPrimaryLightColor = Color(0xFFF1E6FF);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(7.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 5.0,
      offset: Offset(0, 2),
    ),
  ],
);

final grayBoxDecorationStyle = BoxDecoration(
  color: Colors.white54,
  borderRadius: BorderRadius.circular(15.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 5.0,
      offset: Offset(0, 2),
    ),
  ],
);

final greenBaground = BoxDecoration(
  color: Colors.lightGreen,
  borderRadius: BorderRadius.circular(5.0),
  boxShadow: [
    BoxShadow(
      color: Colors.lightGreenAccent,
      blurRadius: 5.0,
      offset: Offset(0, 2),
    ),
  ],
);

final whiteBackground = BoxDecoration(
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 5.0,
      offset: Offset(0, 2),
    ),
  ],
);

final backGreen = BoxDecoration(
  color: Colors.lightGreen,
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 5.0,
      offset: Offset(0, 2),
    ),
  ],
);

final backGreenGradient = BoxDecoration(
  color: Colors.white60,
  /*gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF7CB342),
      Color(0xFF8BC34A),
      Color(0xFF9CCC65),
      Color(0xFFAED581),
    ],
    stops: [0.1, 0.4, 0.7, 0.9],
  ),*/
  borderRadius: BorderRadius.circular(5.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 2.0,
      offset: Offset(0, 2),
    ),
  ],
);

Future<void> saveStringInLocalMemory(String key, String value) async {
  var pref = await SharedPreferences.getInstance();
  pref.setString(key, value);
}

Future<void> addIntToSF(String key, int value) async {
  var pref = await SharedPreferences.getInstance();
  pref.setInt(key, value);
}

Future<void> addDoubleToSF(String key, double value) async {
  var pref = await SharedPreferences.getInstance();
  pref.setDouble(key, value);
}

Future<void> addBoolToSF(String key, bool value) async {
  var pref = await SharedPreferences.getInstance();
  pref.setBool(key, value);
}

Future<String> getStringValuesSF(String key) async {
  var pref = await SharedPreferences.getInstance();
  var number = pref.getString(key) ?? "";
  return number;
}

Future<bool> getBoolValuesSF(String key) async {
  var pref = await SharedPreferences.getInstance();
  var number = pref.getBool(key) ?? false;
  return number;
}

Future<int> getIntValuesSF(String key) async {
  var pref = await SharedPreferences.getInstance();
  var number = pref.getInt(key) ?? 0;
  return number;
}

Future<double> getDoubleValuesSF(String key) async {
  var pref = await SharedPreferences.getInstance();
  var number = pref.getDouble(key) ?? 0;
  return number;
}

Future<void> removeValues(String Key) async {
  var pref = await SharedPreferences.getInstance();
  pref.remove(Key);
}

String formatDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  return formattedDate;
}

Color setStatusColor(String bookingStatus) {
  Color color = Color(0);
  if (bookingStatus == "Cancelled" || bookingStatus == "Rejected") {
    color = Colors.red;
  } else if (bookingStatus == "Pending") {
    color = Colors.blue;
  } else if (bookingStatus == "Confirmed" || bookingStatus == "Completed") {
    color = Colors.green;
  } else {
    color = Colors.black54;
  }

  return color;
}
