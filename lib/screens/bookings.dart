import 'dart:convert';
import 'dart:io';
import 'package:Aaraam/screens/cancelorder.dart';
import 'package:Aaraam/screens/detail.dart';
import 'package:Aaraam/utilities/Users.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:Aaraam/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'dashboard.dart';

class Bookings extends StatefulWidget {
  @override
  _BookingsWidget createState() => _BookingsWidget();
}

class _BookingsWidget extends State<Bookings> {
  String user_id = '', booking_id = '', _groupValue = '';
  bool _isLoading = false, viewVisible = false, noDataviewVisible = false;
  List<User> listModel = [];

  void showWidget() {
    setState(() {
      viewVisible = true;
    });
  }

  void hideWidget() {
    setState(() {
      viewVisible = false;
    });
  }

  void showNoDataWidget() {
    setState(() {
      noDataviewVisible = true;
    });
  }

  void hideNoDataWidget() {
    setState(() {
      noDataviewVisible = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _groupValue = '';
    setState(() {
      _isLoading = true;
    });
    getStringValuesSF("USER_ID").then((val) => setState(() async {
          user_id = val;
          print("user_id : " + user_id);
          try {
            final result = await InternetAddress.lookup('example.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              fetchJSONData(user_id);
              print('connected');
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
        }));
  }

  fetchJSONData(String userid) async {
    String apiURL =
        'https://www.drugvillatechnologies.com/aaram/api/getallbooking.php?user_id=' +
            userid;
    var jsonResponse = await http.get(Uri.parse(apiURL));

    if (jsonResponse.statusCode == 200) {
      var response = json.decode(jsonResponse.body);
      print(jsonResponse.statusCode);
      print(response);
      print(apiURL);

      Map<String, dynamic> map = response;
      String status = map["status"];

      if (status == "1") {
        setState(() {
          _isLoading = false;
          hideNoDataWidget();
          showWidget();
          listModel = (response["data"] as List)
              .map<User>((json) => new User.fromJson(json))
              .toList();

          print(listModel.length);
        });
      } else {
        setState(() {
          _isLoading = false;
          showNoDataWidget();
          hideWidget();
        });
      }
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<void> cancelBooking(String _booking_id_) async {
    String baseUrl =
        "https://www.drugvillatechnologies.com/aaram/api/cancel.php?";
    String finalUrl = baseUrl +
        "user_id=" +
        user_id +
        "&booking_id=" +
        _booking_id_ +
        "&reason_id=" +
        _groupValue;
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
          setState(() {
            _isLoading = false;
          });

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
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  ListTile _tile(BuildContext context, int index) => ListTile(
        title: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 2.0),
                ]),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Order #" + listModel[index].id,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        Text(
                          formatDate(listModel[index].date),
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                              color: Colors.black54,
                              fontFamily: 'OpenSans'),
                        ),
                      ]),
                  SizedBox(height: 10),
                  Text(
                    listModel[index].booking_status.toUpperCase(),
                    style: TextStyle(
                        fontSize: 15,
                        color: setStatusColor(listModel[index].booking_status),
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "charges : ₹ " + listModel[index].charges,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'OpenSans'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Weight : " + listModel[index].weight,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: RaisedButton(
                            elevation: 2.0,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BookingDetail(listModel[index].id)));
                            },
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.lightGreen,
                            child: Text(
                              'View Details',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0.7,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Visibility(
                          maintainAnimation: true,
                          maintainState: true,
                          visible: listModel[index].is_cancelled == "0"
                              ? true
                              : false,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomDialog(listModel[index].id)));
                              },
                              padding: EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.lightGreen, width: 1.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.white,
                              child: Text(
                                'CANCEL',
                                style: TextStyle(
                                  color: Colors.lightGreen,
                                  letterSpacing: 1,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])),
                ],
              ),
            )),
      );

  Color setStatusColor(var bookingStatus) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(
            "My Bookings",
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
                          ),
                        );
                      },
                    ),
                    baseColor: Color(0xFFE0E0E0),
                    highlightColor: Colors
                        .black12) /*Center(child: CircularProgressIndicator())*/
                : GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Stack(children: <Widget>[
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                      Visibility(
                        maintainAnimation: true,
                        maintainState: true,
                        visible: viewVisible,
                        child: ListView.builder(
                          itemCount: listModel.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _tile(context, index);
                          },
                        ),
                      ),
                      Visibility(
                          maintainAnimation: true,
                          maintainState: true,
                          visible: noDataviewVisible,
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // SizedBox(height: 150.0),
                                Image.asset('assets/images/noorder.png'),
                                SizedBox(height: 20.0),
                                Text(
                                  'No Bookings Found!',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'OpenSans',
                                    fontSize: 20.0,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ]))));
  }
}
