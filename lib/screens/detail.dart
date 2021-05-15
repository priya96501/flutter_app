import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Aaraam/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cancelorder.dart';

class BookingDetail extends StatefulWidget {
  final booking_id_;

  BookingDetail(this.booking_id_);

  @override
  _BookingDetailWidget createState() => _BookingDetailWidget(this.booking_id_);
}

class _BookingDetailWidget extends State<BookingDetail> {
  String booking_id_ = '';

  _BookingDetailWidget(this.booking_id_);

  String user_id = '', is_cancelled = '';
  String selected_reason_id = '';
  bool _isLoading = false, viewVisible = false, viewCancelVisible = true;
  List<String> reasons_ = [];
  List<String> reasons_id = [];
  List<bool> _isChecked = [];
  String booking_status_ = '',
      formattedDate = '',
      weight = '',
      charges = '',
      parcel_value = '',
      payment_type = '',
      pickup_address = '',
      delivery_address = '',
      pickup_mobile = '',
      delivery_mobile = '',
      booking_id = '',
      reason = '',
      parcel_content = '';

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

  void showCancelWidget() {
    setState(() {
      viewCancelVisible = true;
    });
  }

  void hideCancelWidget() {
    setState(() {
      viewCancelVisible = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    fetchJSONData();
    fetchCancellationReason();
  }

  fetchJSONData() async {
    String apiURL =
        'https://www.drugvillatechnologies.com/aaram/api/bookingdetail.php?';
    String finalUrl = apiURL + "booking_id=" + booking_id_;
    var jsonResponse = await http.get(Uri.parse(finalUrl));

    if (jsonResponse.statusCode == 200) {
      var response = json.decode(jsonResponse.body);
      print(jsonResponse.statusCode);
      print(response);

      Map<String, dynamic> map = response;
      /* Map<String, dynamic> data = map["data"];*/
      String status = map["status"];

      if (status == "1") {
        setState(() {
          _isLoading = false;
        });
        booking_id = map["booking_id"];
        charges = map["charges"];
        weight = map["weight_description"];
        booking_status_ = map["booking_status"];
        parcel_value = map["order_value"];
        parcel_content = map["order_content"];
        pickup_address = map["pickup_address"];
        delivery_address = map["delivery_address"];
        pickup_mobile = map["pickup_mobile"];
        delivery_mobile = map["delivery_mobile"];
        formattedDate = formatDate(map["created_date"]);
        reason = map["status_reason"];
        payment_type = map["payment_type"];
        is_cancelled = map["is_cancelled"];
        if (booking_status_ == "Cancelled" || booking_status_ == "Rejected") {
          showWidget();
        }
        if (is_cancelled == "1" && booking_status_ != "Completed") {
          hideCancelWidget();
        } else if (booking_status_ == "Completed" ||
            booking_status_ == "Rejected") {
          hideCancelWidget();
        } else {
          showCancelWidget();
        }
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
      print(jsonResponse.statusCode);
      // print(response);

      Map<String, dynamic> map = response;
      List<dynamic> data = map["data"];
      List<Map<String, dynamic>> jsonItems = data.cast<Map<String, dynamic>>();
      print(jsonItems.length);
      for (var i = 0; i < jsonItems.length; i++) {
        reasons_.add(jsonItems[i]["reason"]);
        reasons_id.add(jsonItems[i]["id"]);
      }
      _isChecked = List<bool>.filled(reasons_.length, false);
      print(reasons_.toString());
      print(reasons_id.toString());
      print(_isChecked.toString());
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          "Booking Detail",
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15.0),
                      Text(
                        'Order #' + booking_id,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          letterSpacing: 0.5,
                          fontFamily: 'OpenSans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'charges- ₹' + charges,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          letterSpacing: 0.5,
                          fontFamily: 'OpenSans',
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                      _buildOrderStatus(size),
                      _buildOrderDetailSection(),
                      _buildAddressSection(size),
                      Visibility(
                        maintainAnimation: true,
                        maintainState: true,
                        visible: viewCancelVisible,
                        child: _buildCancelBtn(),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderStatus(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      decoration: whiteBackground,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: Container(
              alignment: Alignment.centerLeft,
              width: size.width * 0.2,
              height: 70.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/delivery.png'),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            width: size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Booking Status',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 7.0),
                Text(
                  booking_status_.toUpperCase(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18.0,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold,
                    color: setStatusColor(booking_status_),
                  ),
                ),
                SizedBox(height: 5.0),
                Visibility(
                  maintainAnimation: true,
                  maintainState: true,
                  visible: viewVisible,
                  child: Text(
                    "(" + reason + ")",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 14.0,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.normal,
                      color: Colors.black45,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  formattedDate,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 15.0,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCancelBtn() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 2.0,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CustomDialog(booking_id)));
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.lightGreen,
        child: Text(
          'CANCEL BOOKING',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 0.7,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetailSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
      decoration: kBoxDecorationStyle,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Order details',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 0.5,
              fontFamily: 'OpenSans',
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            'Parcel value',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 0.5,
              fontFamily: 'OpenSans',
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              color: Colors.black38,
            ),
          ),
          SizedBox(height: 7.0),
          Text(
            "₹ " + parcel_value,
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 0.5,
              fontFamily: 'OpenSans',
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 13.0),
          Text(
            'Parcel Content',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 0.5,
              fontFamily: 'OpenSans',
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              color: Colors.black38,
            ),
          ),
          SizedBox(height: 7.0),
          Text(
            parcel_content,
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 0.5,
              fontFamily: 'OpenSans',
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 13.0),
          Text(
            'Weight',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 0.5,
              fontFamily: 'OpenSans',
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              color: Colors.black38,
            ),
          ),
          SizedBox(height: 7.0),
          Text(
            weight,
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 0.5,
              fontFamily: 'OpenSans',
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 13.0),
          Text(
            'Payment Type',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 0.5,
              fontFamily: 'OpenSans',
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              color: Colors.black38,
            ),
          ),
          SizedBox(height: 7.0),
          Text(
            'With cash',
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 0.5,
              fontFamily: 'OpenSans',
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      decoration: kBoxDecorationStyle,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset('assets/images/one.png'),
              SizedBox(width: 20.0),
              Container(
                width: size.width * 0.65,
                //padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Pickup Address',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 7.0, horizontal: 10.0),
                        decoration: grayBoxDecorationStyle,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                pickup_address,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ])),
                    SizedBox(height: 10.0),
                    Text(
                      pickup_mobile,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset('assets/images/one.png'),
              SizedBox(width: 20.0),
              Container(
                width: size.width * 0.65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Delivery Address',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 7.0, horizontal: 10.0),
                        decoration: grayBoxDecorationStyle,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                delivery_address,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ])),
                    SizedBox(height: 10.0),
                    Text(
                      delivery_mobile,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 5.0),
        ],
      ),
    );
  }
}

