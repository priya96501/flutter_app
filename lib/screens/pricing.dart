import 'dart:io';

import 'package:Aaraam/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import 'order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Pricing extends StatefulWidget {
  @override
  _PricingStateWidget createState() => _PricingStateWidget();
}

class _PricingStateWidget extends State<Pricing> {
  bool _isLoading = false;
  List<String> charges = [];
  List<String> description = [];
  List<String> weight = [];
  final String apiURL =
      'https://www.drugvillatechnologies.com/aaram/api/pricing.php';
  String description__ = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    fetchJSONData();
  }

  fetchJSONData() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var jsonResponse = await http.get(Uri.parse(apiURL));

        if (jsonResponse.statusCode == 200) {
          var response = json.decode(jsonResponse.body);
          print(jsonResponse.statusCode);
          print(response);

          /*Map<String, dynamic> map = response;
      List<dynamic> data = map["data"];
      List<Map<String, dynamic>> jsonItems = data.cast<Map<String, dynamic>>();
      print(jsonItems.length);*/

          List<Map<String, dynamic>> jsonItems =
              json.decode(jsonResponse.body).cast<Map<String, dynamic>>();
          print(jsonItems.length);

          for (var i = 0; i < jsonItems.length; i++) {
            charges.add(jsonItems[i]["charges"]);
            weight.add(jsonItems[i]["weight"]);
            description.add(jsonItems[i]["description"]);
          }
          setState(() {
            _isLoading = false;
          });

          /* List<GetUsers> usersList = jsonItems.map<GetUsers>((json) {
        return GetUsers.fromJson(json);
      }).toList();*/

        } else {
          setState(() {
            _isLoading = false;
          });
          throw Exception('Failed to load data from internet');
        }
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
  }

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
              fontSize: 16.0,
              fontWeight: FontWeight.bold
          ),
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
            highlightColor: Colors.black12)/*Center(child: CircularProgressIndicator())*/
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
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15.0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 15.0),
                              decoration: kBoxDecorationStyle,
                              width: double.infinity,
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Minimal price (max distance 6.2 km)',
                                    style: TextStyle(
                                      letterSpacing: 0.5,
                                      fontFamily: 'OpenSans',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black38,
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                      child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: charges.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return _tile(context, index);
                                    },
                                  ))
                                ],
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Container(
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

  ListTile _tile(BuildContext context, int index) => ListTile(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(description[index].toString(),
                  style: TextStyle(
                    letterSpacing: 0.5,
                    fontFamily: 'OpenSans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black38,
                  )),
              Text("₹ " + charges[index].toString(),
                  style: TextStyle(
                    letterSpacing: 0.5,
                    fontFamily: 'OpenSans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  )),
            ]),
      );

  Widget _buildData() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  for (var i in description)
                    Text(i.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          letterSpacing: 0.5,
                          fontFamily: 'OpenSans',
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black38,
                        )),
                ]),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            child: Column(children: <Widget>[
              for (var j in charges)
                Text("₹ " + j.toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      letterSpacing: 0.5,
                      fontFamily: 'OpenSans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    )),
            ]),
          )
        ],
      ),
    );
  }
}
