import 'dart:convert';
import 'dart:io';
import 'package:Aaraam/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:Aaraam/screens/bookings.dart';
import 'package:Aaraam/screens/login.dart';
import 'package:Aaraam/screens/order.dart';
import 'package:Aaraam/screens/pricing.dart';
import 'package:Aaraam/screens/redirect.dart';
import 'package:Aaraam/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:Aaraam/screens/contact.dart';
import 'package:shimmer/shimmer.dart';

final List<String> imgList = [
  'https://www.drugvillatechnologies.com/aaram/images/banner2.jpg',
  'https://www.drugvillatechnologies.com/aaram/oldfile/images/s1.jpg',
];

class Dashboard extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            margin: EdgeInsets.all(2.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(
                      item,
                      fit: BoxFit.cover,
                      width: 1000.0,
                      height: 200.0,
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        /*padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          'No. ${imgList.indexOf(item)} image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),*/
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();

class _DashboardScreenState extends State<Dashboard> {
  //final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

  int _current = 0;
  String name = '', user_id = '';
  String mobile = '',
      privacy_policy_url = '',
      terms_url = '',
      about_url = '',
      company_email = '',
      company_mobile = '',
      company_address = '';
  bool _isLoading = false;

  _DashboardScreenState() {
    getStringValuesSF("USER_NAME").then((val) => setState(() {
          name = val;
        }));
    getStringValuesSF("USER_MOBILE").then((val) => setState(() {
          mobile = val;
        }));

    // setupLocator();
  }

  @override
  void initState() {
    super.initState();
    getStringValuesSF("USER_ID").then((val) => setState(() async {
          user_id = val;
          print("user_id : " + user_id);
          setState(() {
            _isLoading = true;
          });
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
        'https://www.drugvillatechnologies.com/aaram/api/getuser.php?user_id=' +
            userid;
    var jsonResponse = await http.get(Uri.parse(apiURL));

    if (jsonResponse.statusCode == 200) {
      var response = json.decode(jsonResponse.body);
      print(jsonResponse.statusCode);
      print(response);

      Map<String, dynamic> map = response;
      String status = map["status"];

      if (status == "1") {
        setState(() {
          _isLoading = false;
        });
        privacy_policy_url = map["privacy_policy_url"];
        terms_url = map["term_condition_url"];
        about_url = map["about_us_url"];
        company_address = map["company_address"];
        company_email = map["company_email"];
        company_mobile = map["company_mobile"];

        saveStringInLocalMemory("COMPANY_ADDRESS", company_address);
        saveStringInLocalMemory("COMPANY_EMAIL", company_email);
        saveStringInLocalMemory("COMPANY_MOBILE", company_mobile);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load data from internet');
    }
  }

  Widget _buildSecondSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      decoration: kBoxDecorationStyle,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/icon3.png'),
          SizedBox(height: 10.0),
          Text(
            'Online Booking',
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 0.5,
              fontFamily: 'OpenSans',
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'We can deliver ASAP or at a specified time documents, products, flowers, any product.',
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 0.5,
              fontFamily: 'OpenSans',
              fontSize: 13.0,
              fontWeight: FontWeight.normal,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0),
      decoration: kBoxDecorationStyle,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10.0),
            Text(
              'Best Online courier in India At Affordable price',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 0.5,
                fontFamily: 'OpenSans',
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Courier delivery rates for Delhi/NCR',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 0.5,
                fontFamily: 'OpenSans',
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: Colors.black38,
              ),
            ),
            _buildLogo(AssetImage('assets/images/pricing.png')),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              // padding: EdgeInsets.symmetric(vertical: 7.0),
              width: double.infinity,
              child: RaisedButton(
                elevation: 2.0,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Pricing();
                      },
                    ),
                  );
                },
                padding: EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.lightGreen,
                child: Text(
                  'View Pricing',
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
            SizedBox(height: 10.0),
          ]),
    );
  }

  Widget _buildBookOrder(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      decoration: whiteBackground,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: Container(
              width: size.width * 0.3,
              height: 120.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/delivery.png'),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            width: size.width * 0.6,
            // width: 200.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Fastest Peer to Peer Delivery Service in Delhi/NCR',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 3.0),
                Text(
                  'Low-priced same day delivery service!',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 13.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 5.0),
                _buildBookNowButton()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLogo(AssetImage logo) {
    return GestureDetector(
      child: Container(
        width: 200.0,
        height: 150.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomInformation() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/rocket.png'),
                  SizedBox(height: 15.0),
                  Text(
                    'You can book a courier delivery without creating accounts or signing contracts. The phone number for the sender and receiver is more than enough!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 0.5,
                      fontFamily: 'OpenSans',
                      fontSize: 14.0,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/chat.png'),
                  SizedBox(height: 15.0),
                  Text(
                    'We send couriers phone number to the contact person via SMS at each delivery point.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 0.5,
                      fontFamily: 'OpenSans',
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/booking.png'),
                  SizedBox(height: 15.0),
                  Text(
                    'Walking couriers and riders are always available. We assign the nearest courier with the highest rating within 7 minutes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 0.5,
                      fontFamily: 'OpenSans',
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildContactSection() {
    return Container(
      decoration: backGreenGradient,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildLogo(AssetImage('assets/images/contactus.png')),
          SizedBox(height: 10.0),
          Text(
            'Need Help ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
              fontSize: 22.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Talk to our customer service centre for updated information on how to ship your shipment with us.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontFamily: 'OpenSans',
              fontSize: 15.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 10.0),
          _buildContactButton(),
          SizedBox(height: 10.0),
          Text(
            '-------------  OR  --------------',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black26,
              fontFamily: 'OpenSans',
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            child: Row(
                //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildContactInfo("Call us at", company_mobile, "mobile"),
                  _buildContactInfo(" Email us on", company_email, "email"),
                ]),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _buildContactButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 3.0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Contact();
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
          'CONTACT US',
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

  Widget _buildContactInfo(String heading, String data, String type) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 7.0),
        child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
            side: BorderSide(color: Colors.lightGreen, width: 1),
          ),
          color: Colors.white,
          onPressed: () async {
            if (type == "email") {
              launchEmailSubmission(data);
            } else {
              launchCallSubmission(data);
            }
          },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  heading,
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 13.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                  ),
                ),
                SizedBox(height: 7.0),
                Text(
                  data,
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ]),
        ));
  }

  Widget _buildTopSection(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildData(
            size,
            '2-3 hours\ndelivery',
            'We can deliver ASAP or at a specified time documents, products, flowers, any product.',
            'assets/images/icon1.png',
          ),
          _buildData(
            size,
            'Fastest courier serivce',
            'We can deliver ASAP or at a specified time documents, products, flowers, any product.',
            'assets/images/icon2.png',
          ),
        ],
      ),
    );
  }

  Widget _buildData(
      Size size, String heading, String description, String logo) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      decoration: kBoxDecorationStyle,
      width: size.width * 0.43,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(logo),
          SizedBox(height: 15.0),
          Text(
            heading,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 15.0,
              letterSpacing: 0.5,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 0.5,
              fontFamily: 'OpenSans',
              fontSize: 13.0,
              fontWeight: FontWeight.normal,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var title = "Aaraam";
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        /* leading: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Material(
            shape: new CircleBorder(),
          ),
        ),*/

        title: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 14, bottom: 15, top: 15, left: 0),
              width: 55.0,
              height: 50.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/delivery_3.png'),
                ),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  letterSpacing: 0.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
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
                highlightColor: Colors.black12)
            /*highlightColor: Color(0xFFBDBDBD))*/
            /*Center(child: CircularProgressIndicator())*/
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
                          vertical: 20.0,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CarouselSlider(
                                items: imageSliders,
                                options: CarouselOptions(
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    aspectRatio: 2.0,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _current = index;
                                      });
                                    }),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: imgList.map((url) {
                                  int index = imgList.indexOf(url);
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _current == index
                                          ? Colors.lightGreen
                                          : Color.fromRGBO(0, 0, 0, 0.2),
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 10.0),
                              _buildBookOrder(size),
                              _buildTopSection(size),
                              _buildSecondSection(),
                              SizedBox(height: 20.0),
                              _buildContactSection(),
                              SizedBox(height: 30.0),
                              _buildPricingSection(),
                              SizedBox(height: 50.0),
                              Text(
                                'Why choose us?',
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
                                'Aaraam is revolutionising urgent deliveries',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'OpenSans',
                                  fontSize: 16.0,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 35.0),
                              _buildBottomInformation(),
                              SizedBox(height: 30.0),
                            ]),
                      ),
                    )
                  ],
                ),
              ),
      ),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: backGreen,
            accountName: Text(
              name,
              style: TextStyle(
                  fontSize: 16.0, fontFamily: 'OpenSans', letterSpacing: 0.5),
            ),
            accountEmail: Text(
              //email,
              mobile,
              style: TextStyle(
                  fontSize: 14.0, fontFamily: 'OpenSans', letterSpacing: 0.5),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                '${name[0]}',
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.lightGreen,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.black26,
            ),
            title: Text(
              "Home",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  letterSpacing: 0.5),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Home();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.book_rounded,
              color: Colors.black26,
            ),
            title: Text(
              "My Bookings",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  letterSpacing: 0.5),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Bookings();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.border_color,
              color: Colors.black26,
            ),
            title: Text(
              "Book Courier",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  letterSpacing: 0.5),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Order();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.price_check,
              color: Colors.black26,
            ),
            title: Text(
              "Pricing",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  letterSpacing: 0.5),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Pricing();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.contacts,
              color: Colors.black26,
            ),
            title: Text(
              "Contact Us",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  letterSpacing: 0.5),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Contact();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.account_box,
              color: Colors.black26,
            ),
            title: Text(
              "About Us",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  letterSpacing: 0.5),
            ),
            onTap: () {
              Navigator.pop(context);
              _handleURLButtonPress(
                  context,
                  about_url
                  /*"https://www.drugvillatechnologies.com/aaram/mobile-about.php"*/,
                  "About Us");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.policy,
              color: Colors.black26,
            ),
            title: Text(
              "Privacy Policy",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  letterSpacing: 0.5),
            ),
            onTap: () {
              Navigator.pop(context);
              _handleURLButtonPress(
                  context,
                  privacy_policy_url
                  /*"https://www.drugvillatechnologies.com/aaram/mobile-privacy.php"*/,
                  "Privacy Policy");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.black26,
            ),
            title: Text(
              "Terms & Condition",
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 0.5,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _handleURLButtonPress(
                  context,
                  terms_url,
                  /*"https://www.drugvillatechnologies.com/aaram/mobile-term.php",*/
                  "Terms & Condition");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.share,
              color: Colors.black26,
            ),
            title: Text(
              "Share App",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  letterSpacing: 0.5),
            ),
            onTap: () {
              ShareApp(context);
            },
          ),
          ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.black26,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                    letterSpacing: 0.5),
              ),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.only(
                            top: 30.0, bottom: 10.0, left: 25.0, right: 25.0),
                        content: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            SizedBox(height: 30.0),
                            Text(
                              'Are you sure you want to logout?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                                fontSize: 16.0,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Container(
                                padding:
                                    EdgeInsets.only(top: 30.0, bottom: 10.0),
                                // margin: EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: RaisedButton(
                                        elevation: 1.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        color: Colors.lightGreen,
                                        child: Text(
                                          "Yes",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 18.0,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          removeValues('IS_LOGIN');
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen()),
                                              ModalRoute.withName("/login"));
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: RaisedButton(
                                        elevation: 1.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        color: Color(0xFFEFEBE9),
                                        child: Text(
                                          "No",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontFamily: 'OpenSans',
                                            fontSize: 18.0,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      );
                    });
              }),
        ]),
      ),
    );
  }

  Widget _buildBookNowButton() {
    return Container(
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
        padding: EdgeInsets.all(12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.lightGreen,
        child: Text(
          'Book a Courier',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 0.5,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url, title)));
  }
}
