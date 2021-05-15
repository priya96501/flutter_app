import 'dart:convert';
import 'package:Aaraam/screens/detail.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:Aaraam/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';

class Bookings extends StatefulWidget {
  @override
  _BookingsWidget createState() => _BookingsWidget();
}

class _BookingsWidget extends State<Bookings> {
  String _groupValue = '';
  String user_id = '', booking_id = '';
  bool _isLoading = false, viewVisible = false;
  List<String> reasons_ = [];
  List<String> reasons_id = [];
  List<String> booking_ids = [];
  List<String> charges = [];
  List<String> status_ = [];
  List<String> weights = [];
  List<String> date = [];
  List<String> is_cancelled_ = [];
  List<bool> is_cancel_visible = [];

  late List<bool> _isChecked;

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

  @override
  void initState() {
    super.initState();
    getStringValuesSF("USER_ID").then((val) => setState(() {
          user_id = val;
          print("user_id : " + user_id);
          fetchJSONData(user_id);
        }));
    _groupValue = '';
    _isChecked = List<bool>.filled(reasons_.length, false);
    setState(() {
      _isLoading = true;
    });
    fetchCancellationReason();
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
        List<dynamic> data = map["data"];
        List<Map<String, dynamic>> jsonItems =
            data.cast<Map<String, dynamic>>();
        print(jsonItems.length);
        for (var i = 0; i < jsonItems.length; i++) {
          booking_ids.add(jsonItems[i]["booking_id"]);
          date.add(jsonItems[i]["date"]);
          charges.add(jsonItems[i]["charges"]);
          weights.add(jsonItems[i]["weight_description"]);
          is_cancelled_.add(jsonItems[i]["is_cancelled"]);
          status_.add(jsonItems[i]["booking_status"]);
        }

        print(is_cancelled_.toString());
        // TODO : show/hide cancel button on basis of is_cancelled=1/0

        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load data from internet');
    }
  }

  fetchCancellationReason() async {
    String apiURL =
        'https://www.drugvillatechnologies.com/aaram/api/getreason.php?reason_type=BOOKING';
    var jsonResponse = await http.get(Uri.parse(apiURL));

    if (jsonResponse.statusCode == 200) {
      var response = json.decode(jsonResponse.body);
      Map<String, dynamic> map = response;
      List<dynamic> data = map["data"];
      List<Map<String, dynamic>> jsonItems = data.cast<Map<String, dynamic>>();
      for (var i = 0; i < jsonItems.length; i++) {
        reasons_.add(jsonItems[i]["reason"]);
        reasons_id.add(jsonItems[i]["id"]);
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

  Widget setupAlertDialoadContainer(BuildContext context, String bookingId) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: reasons_.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              title: Text(reasons_[index]),
              value: _isChecked[index],
              onChanged: (val) {
                setState(
                  () {
                    _isChecked[index] = val!;
                  },
                );
              },
            );
            /*return RadioListTile(
              value: reasons_id[index],
              groupValue: _groupValue,
              onChanged: (String? val) {
                print("Radio $val");
                setState(() {
                  _groupValue = val!;
                });
                print("Group $_groupValue");
                //setSelectedRadio(val);
              },
              activeColor: Colors.green,
              title: Text(reasons_[index].toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    letterSpacing: 0.5,
                    fontFamily: 'OpenSans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  )),
            );*/
          },
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 25.0),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.lightGreen,
          onPressed: () {
            print("group value" + _groupValue);
            if (_groupValue != '') {
              Navigator.pop(context);
              cancelBooking(bookingId);
            } else {
              final snackBar = SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.redAccent,
                margin: EdgeInsets.all(10.0),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
                content: Text('Select cancellation reason!',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'OpenSans')),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: Text(
            "Cancel",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              fontSize: 16.0,
              letterSpacing: 0.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ]);
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
                          "Order #" + booking_ids[index].toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        Text(
                          formatDate(date[index].toString()),
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
                    status_[index].toString().toUpperCase(),
                    style: TextStyle(
                        fontSize: 15,
                        color: setStatusColor(status_[index].toString()),
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "charges : ₹ " + charges[index].toString(),
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
                    "Weight : " + weights[index].toString(),
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
                                      builder: (context) => BookingDetail(
                                          booking_ids[index].toString())));
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
                          visible: viewVisible,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: RaisedButton(
                              elevation: 2.0,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Container(
                                            child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'Cancel Order #' +
                                                booking_ids[index].toString(),
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        )),
                                        content: setupAlertDialoadContainer(
                                            context,
                                            booking_ids[index].toString()),
                                      );
                                    });
                              },
                              padding: EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
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
              fontSize: 18.0,
            ),
          ),
          backgroundColor: Colors.lightGreen,
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 15.0),
                        child: ListView.builder(
                          itemCount: booking_ids.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _tile(context, index);
                          },
                        )))));
  }
}
