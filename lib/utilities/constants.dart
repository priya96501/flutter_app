import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
);

final backGreenGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF7CB342),
      Color(0xFF8BC34A),
      Color(0xFF9CCC65),
      Color(0xFFAED581),
    ],
    stops: [0.1, 0.4, 0.7, 0.9],
  ),
  borderRadius: BorderRadius.circular(5.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 2.0,
      offset: Offset(0, 2),
    ),
  ],
);

addStringToSF(String key, String value) async {
  SharedPreferences.setMockInitialValues({});
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

addIntToSF(String key, int value) async {
  SharedPreferences.setMockInitialValues({});
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}

addDoubleToSF(String key, double value) async {
  SharedPreferences.setMockInitialValues({});
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble(key, value);
}

addBoolToSF(String key, bool val) async {
  SharedPreferences.setMockInitialValues({});
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, val);
}

getStringValuesSF(String key) async {
  SharedPreferences.setMockInitialValues({});
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? stringValue = prefs.getString(key);
  return stringValue;
}

getBoolValuesSF(String key) async {
  SharedPreferences.setMockInitialValues({});
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return bool
  bool? boolValue = prefs.getBool(key);
  return boolValue;
}

getIntValuesSF(String key) async {
  SharedPreferences.setMockInitialValues({});
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return int
  int? intValue = prefs.getInt(key);
  return intValue;
}

getDoubleValuesSF(String key) async {
  SharedPreferences.setMockInitialValues({});
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return double
  double? doubleValue = prefs.getDouble(key);
  return doubleValue;
}

removeValues(String Key) async {
  SharedPreferences.setMockInitialValues({});
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(Key);
}
