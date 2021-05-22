import 'dart:convert';
import 'dart:io';
import 'package:Aaraam/utilities/Users.dart';
import 'package:http/http.dart' as http;
import 'package:Aaraam/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import 'dashboard.dart';

class CustomDialog extends StatefulWidget {
  String booking_id = '';

  CustomDialog(this.booking_id);

  @override
  _CustomDialogState createState() => _CustomDialogState(this.booking_id);
}

class _CustomDialogState extends State<CustomDialog> {
  String booking_id = '', user_id = '';
  bool _isLoading = false;
  List<Reasons> listModel = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    getData();
  }

  getData() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        fetchCancellationReason();
      }
    } on SocketException catch (_) {
      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.lightGreen,
        margin: EdgeInsets.all(10.0),
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
        content: Text('No Internet Connection!',
            style: TextStyle(
                color: Colors.white,
                letterSpacing: 0.5,
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                fontFamily: 'OpenSans')),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('not connected');
    }
  }

  _CustomDialogState(this.booking_id) {
    getStringValuesSF("USER_ID").then((val) => setState(() {
          user_id = val;
        }));
  }

  bool canUpload = false;
  String selectedvalue = '';

  fetchCancellationReason() async {
    String apiURL =
        'https://www.drugvillatechnologies.com/aaram/api/getreason.php?reason_type=BOOKING';
    var jsonResponse = await http.get(Uri.parse(apiURL));

    if (jsonResponse.statusCode == 200) {
      var response = json.decode(jsonResponse.body);
      print(response);
      print(jsonResponse.statusCode);
      Map<String, dynamic> map = response;
      List<dynamic> data = map["data"];
      List<Map<String, dynamic>> jsonItems = data.cast<Map<String, dynamic>>();

      setState(() {
        _isLoading = false;
        listModel = (response["data"] as List)
            .map<Reasons>((json) => new Reasons.fromJson(json))
            .toList();

        print(listModel.length);
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load data from internet');
    }
  }

  Future<void> cancelBooking() async {
    String baseUrl =
        "https://www.drugvillatechnologies.com/aaram/api/cancel.php?";
    String finalUrl = baseUrl +
        "user_id=" +
        user_id +
        "&booking_id=" +
        booking_id +
        "&reason_id=" +
        selectedvalue;
    var jsonResponse = null;
    var response = await http.post(Uri.parse(finalUrl));
    print(response.statusCode);
    print(finalUrl);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        Map<String, dynamic> map = jsonResponse;
        String? status = map["status"];
        if (status == '1') {
          final snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.lightGreen,
            margin: EdgeInsets.all(10.0),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
            content: Text('Booking cancelled successfully!',
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans')),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Dashboard()),
              (Route<dynamic> route) => false);
        }
      }
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          "Cancel Booking",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              letterSpacing: 0.5,
              fontSize: 16.0,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightGreen,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: _isLoading
            ? Shimmer.fromColors(
                child: ListView.builder(
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.image, size: 50.0),
                      title: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                            ),
                            Container(
                              decoration: shimmerBoxDecorationStyle,
                              width: double.infinity,
                              height: 12.0,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                            ),
                            Container(
                              width: 100.0,
                              height: 12.0,
                              decoration: shimmerBoxDecorationStyle,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                            ),
                            Container(
                              width: 40.0,
                              height: 12.0,
                              decoration: shimmerBoxDecorationStyle,
                            ),
                          ],
                        ),
                        /* height: 20.0,*/
                      ),
                    );
                  },
                ),
                baseColor: Color(0xFFE0E0E0),
                highlightColor: Colors
                    .black12) /*Center(child: CircularProgressIndicator())*/
            : GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      height: double.infinity,
                      child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            vertical: 25.0,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 10),
                                Text(
                                  'Select reason to cancel Order',
                                  style: TextStyle(
                                    letterSpacing: 0.5,
                                    fontFamily: 'OpenSans',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black38,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "# " + booking_id,
                                  style: TextStyle(
                                    letterSpacing: 0.5,
                                    fontFamily: 'OpenSans',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                    height: 500.0,
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 10.0),
                                    child: ListView.builder(
                                      itemCount: listModel.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return RadioListTile(
                                          value: listModel[index].id,
                                          groupValue: selectedvalue,
                                          activeColor: Colors.green,
                                          title: Text(listModel[index].reason,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                letterSpacing: 0.5,
                                                fontFamily: 'OpenSans',
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black87,
                                              )),
                                          onChanged: (String? value) {
                                            selectedvalue = value!;
                                            canUpload = true;
                                            setState(() {});
                                          },
                                        );
                                      },
                                    )),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 5.0),
                                  child: Column(children: <Widget>[
                                    RaisedButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 30.0),
                                      elevation: 1.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      color: Colors.lightGreen,
                                      onPressed: canUpload
                                          ? () async {
                                              try {
                                                print("Validated");
                                                final result =
                                                    await InternetAddress
                                                        .lookup('aaraam.com');
                                                if (result.isNotEmpty &&
                                                    result[0]
                                                        .rawAddress
                                                        .isNotEmpty) {
                                                  print('connected');
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  cancelBooking();
                                                }
                                              } on SocketException catch (_) {
                                                final snackBar = SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Colors.lightGreen,
                                                  margin: EdgeInsets.all(10.0),
                                                  elevation: 2.0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7.0),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 3.0,
                                                      horizontal: 15.0),
                                                  content: Text(
                                                      'No Internet Connection!',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          letterSpacing: 0.5,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily:
                                                              'OpenSans')),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                print('not connected');
                                              }
                                            }
                                          : null,
                                      child: Text('Cancel Order',
                                          style: TextStyle(
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'OpenSans')),
                                    )
                                  ]),
                                ),
                              ])),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
