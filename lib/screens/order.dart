import 'dart:convert';
import 'dart:ffi';

import 'package:Aaraam/screens/Confirm.dart';
import 'package:Aaraam/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;

class Order extends StatefulWidget {
  @override
  _OrderScreenWidget createState() => _OrderScreenWidget();
}

class _OrderScreenWidget extends State<Order> {
  String user_id = '';

  _OrderScreenWidget() {
    getStringValuesSF("USER_ID").then((val) => setState(() {
          user_id = val;
        }));
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool viewVisible = false;
  String price_data_ = '';
  String weight_data_ = '';

  final TextEditingController from_mobile = new TextEditingController();
  final TextEditingController to_mobile = new TextEditingController();
  final TextEditingController from_address = new TextEditingController();
  final TextEditingController to_address = new TextEditingController();
  final TextEditingController order_value = new TextEditingController();
  final TextEditingController order_description = new TextEditingController();

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

  Future<void> submit(String from_address, to_address, from_mobile, to_mobile,
      order_value, order_description, weight) async {
    String baseUrl =
        "https://www.drugvillatechnologies.com/aaram/api/book.php?";
    String finalUrl = baseUrl +
        "user_id=" +
        user_id +
        "&mobile_from=" +
        from_mobile +
        "&mobile_to=" +
        to_mobile +
        "&address_from=" +
        from_address +
        "&address_to=" +
        to_address +
        "&weight=" +
        weight +
        "&order_description=" +
        order_description +
        "&order_value =" +
        order_value +
        "&type=app";
    var jsonResponse = null;
    var response = await http.post(Uri.parse(finalUrl));
    print(response.statusCode);
    print(finalUrl);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Confirm();
            },
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  Widget _buildSubmitBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 2.0,
        onPressed: () {
          if (formkey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });
            submit(
                from_address.text,
                to_address.text,
                from_mobile.text,
                to_mobile.text,
                order_value.text,
                order_description.text,
                weight_data_);
            print("Validated");
          } else {
            print("Not Validated");
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.lightGreen,
        child: Text(
          'SUBMIT ORDER',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildMobileToTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '10-digit mobile',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          child: TextFormField(
              keyboardType: TextInputType.number,
              maxLines: 1,
              controller: to_mobile,
              maxLength: 10,
              cursorColor: Colors.lightGreen,
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  color: Colors.black26,
                ),
                hintText: 'Enter mobile number',
                hintStyle: kHintTextStyle,
              ),
              validator: MultiValidator([
                RequiredValidator(
                    errorText: "* Please enter your mobile number"),
                PatternValidator(r'(^[6-9][0-9]{9}$)',
                    errorText: 'Please enter valid mobile number')
              ])),
        ),
      ],
    );
  }

  Widget _buildWeightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Weight',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildData('1 kg', '1'),
              _buildData('5 kg', '5'),
              _buildData('10 kg', '10'),
              _buildData('15 kg', '15'),
              _buildData('20 kg', '20'),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Visibility(
            maintainAnimation: true,
            maintainState: true,
            visible: viewVisible,
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Text(
                    'Price',
                    textAlign: TextAlign.left,
                    style: kLabelStyle,
                  ),
                  SizedBox(height: 10.0),
                  Container(
                      decoration: kBoxDecorationStyle,
                      // margin: EdgeInsets.all(15.0),
                      padding: EdgeInsets.all(15.0),
                      child: Column(children: <Widget>[
                        Text("₹ "+price_data_,
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16.0,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.normal,
                              color: Colors.black87,
                            )),
                      ])),
                ]))),
      ],
    );
  }

  Widget _buildData(String heading, String data) {
    return Container(
        width: 60,
        // decoration: kBoxDecorationStyle,
        child: RaisedButton(
          elevation: 2.0,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: Colors.white,
          onPressed: () {
            getPriceApi(data);
          },
          child: Column(
            children: <Widget>[
              Text(
                'Up to',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 14.0,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 14.0,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildMobileFromTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '10-digit mobile',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          child: TextFormField(
              maxLines: 1,
              maxLength: 10,
              controller: from_mobile,
              cursorColor: Colors.lightGreen,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  color: Colors.black26,
                ),
                hintText: 'Enter mobile number',
                hintStyle: kHintTextStyle,
              ),
              validator: MultiValidator([
                RequiredValidator(
                    errorText: "* Please enter your mobile number"),
                PatternValidator(r'(^[6-9][0-9]{9}$)',
                    errorText: 'Please enter valid mobile number')
              ])),
        ),
      ],
    );
  }

  Widget _buildAddressToTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Delivery address',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.topLeft,
          child: TextFormField(
              keyboardType: TextInputType.streetAddress,
              controller: from_address,
              cursorColor: Colors.lightGreen,
              /*  maxLines: 3,*/
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: Colors.black26,
                ),
                hintText: 'Enter delivery address',
                hintStyle: kHintTextStyle,
              ),
              validator: MultiValidator([
                RequiredValidator(errorText: "* Address can't be empty"),
                MinLengthValidator(5, errorText: "Enter valid address"),
              ])),
        ),
      ],
    );
  }

  Widget _buildOrderValueToTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Parcel Value',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.topLeft,
          child: TextFormField(
              keyboardType: TextInputType.number,
              controller: order_value,
              cursorColor: Colors.lightGreen,
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                prefixIcon: Icon(
                  Icons.money,
                  color: Colors.black26,
                ),
                hintText: 'Enter your parcel value',
                hintStyle: kHintTextStyle,
              ),
              validator: MultiValidator([
                RequiredValidator(errorText: "* Please enter Parcel value"),
              ])),
        ),
      ],
    );
  }

  Widget _buildOrderDescriptionToTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Parcel Detail',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.topLeft,
          child: TextFormField(
              keyboardType: TextInputType.text,
              controller: order_description,
              cursorColor: Colors.lightGreen,
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                prefixIcon: Icon(
                  Icons.details,
                  color: Colors.black26,
                ),
                hintText: 'What are you sending?',
                hintStyle: kHintTextStyle,
              ),
              validator: MultiValidator([
                RequiredValidator(
                    errorText: "* Please tell us what is being delivered"),
              ])),
        ),
      ],
    );
  }

  Widget _buildAddressFromTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Pick up Address',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.topLeft,
          child: TextFormField(
              keyboardType: TextInputType.streetAddress,
              /*   maxLines: 1,*/
              controller: to_address,
              cursorColor: Colors.lightGreen,
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: Colors.black26,
                ),
                hintText: 'Enter pickup address',
                hintStyle: kHintTextStyle,
              ),
              validator: MultiValidator([
                RequiredValidator(errorText: "* Address can't be empty"),
                MinLengthValidator(5, errorText: "Enter valid address"),
              ])),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          "Book Order",
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
                          horizontal: 30.0,
                          vertical: 25.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 10.0),
                            Image.asset('assets/images/book.jpg'),
                            SizedBox(height: 25.0),
                            Text(
                              'Book a Courier',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                                fontSize: 22.0,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'To book your courier\nPlease fill the form below',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black54,
                                fontFamily: 'OpenSans',
                                fontSize: 16.0,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 50.0),
                            Container(
                                child: Form(
                                    autovalidate: true,
                                    //check for validation while typing
                                    key: formkey,
                                    child: Column(children: <Widget>[
                                      _buildAddressFromTF(),
                                      SizedBox(height: 20.0),
                                      _buildMobileFromTF(),
                                      SizedBox(height: 20.0),
                                      _buildAddressToTF(),
                                      SizedBox(height: 20.0),
                                      _buildMobileToTF(),
                                      SizedBox(height: 30.0),
                                      _buildWeightSection(),
                                      SizedBox(height: 20.0),
                                      _buildOrderValueToTF(),
                                      SizedBox(height: 20.0),
                                      _buildOrderDescriptionToTF(),
                                      SizedBox(height: 10.0),
                                      _buildSubmitBtn(),
                                    ]))),
                            SizedBox(height: 10.0),
                            Text(
                              "By Clicking 'Submit order' you are forwarding your request to couriers and agree to Our Terms and Conditions along with the clauses of the agreements",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black38,
                                fontFamily: 'OpenSans',
                                fontSize: 13.0,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 20.0),
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

  Future<void> getPriceApi(String heading) async {
    String baseUrl =
        "https://www.drugvillatechnologies.com/aaram/api/getprice.php?weight=" +
            heading;
    var jsonResponse = null;
    var response = await http.post(Uri.parse(baseUrl), headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    final String res = response.body;
    final int statusCode = response.statusCode;
    print(statusCode);
    print(baseUrl);

    if (statusCode == 200) {
      jsonResponse = json.decode(res);
      print(jsonResponse.toString());

      Map<String, dynamic> map = jsonResponse;
      /* List<dynamic> data = map["dataKey"];
      print(data[0]["name"]);*/
      String data = map["charges"];
      String weight = map["weight"];
      print(data);
      print(weight);
      showWidget();
      price_data_ = data;
      weight_data_ = weight;
    } else {
      print(res);
    }
  }
}
