import 'package:Aaraam/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'order.dart';

class Pricing extends StatefulWidget {
  @override
  _PricingStateWidget createState() => _PricingStateWidget();
}

class _PricingStateWidget extends State<Pricing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          "Pricing",
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
        child: GestureDetector(
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
                      SizedBox(height: 5.0),
                      Image.asset('assets/images/pricing.png'),
                      SizedBox(height: 15.0),
                      Text(
                        'Best Online courier in India At Affordable price',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 18.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        'Courier delivery rates for Delhi/NCR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'OpenSans',
                          fontSize: 16.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      _buildPricingSection(),
                      SizedBox(height: 30.0),
                      Container(
                        //margin: EdgeInsets.symmetric(horizontal: 15.0),
                        padding: EdgeInsets.symmetric(vertical: 7.0),
                        width: double.infinity,
                        child: RaisedButton(
                          elevation: 2.0,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Order();
                                },
                              ),
                            );
                          },
                          padding: EdgeInsets.all(15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Colors.lightGreen,
                          child: Text(
                            'BOOK A COURIER',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 0.5,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ),
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

  Widget _buildPricingSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      decoration: kBoxDecorationStyle,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10.0),
          Text(
            'Minimal price (max distance 6.2 km)',
            // textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 0.5,
              fontFamily: 'OpenSans',
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              color: Colors.black38,
            ),
          ),
          SizedBox(height: 15.0),
          _buildData('up to 1 kg', '₹ 44'),
          SizedBox(height: 7.0),
          _buildData('up to 5 kg', '₹ 44'),
          SizedBox(height: 7.0),
          _buildData('up to 10 kg', '₹ 149'),
          SizedBox(height: 7.0),
          _buildData('up to 15 kg', '₹ 194'),
          SizedBox(height: 7.0),
          _buildData('up to 20 kg', '₹ 244'),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }

  Widget _buildData(String heading, String description) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      //decoration: kBoxDecorationStyle,
      //width: 180.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            heading,
            // textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 0.5,
              fontFamily: 'OpenSans',
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              color: Colors.black38,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            description,
            //textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 0.5,
              fontFamily: 'OpenSans',
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
