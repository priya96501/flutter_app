import 'package:Aaraam/screens/login.dart';
import 'package:Aaraam/screens/order.dart';
import 'package:Aaraam/screens/pricing.dart';
import 'package:Aaraam/screens/redirect.dart';
import 'package:Aaraam/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:Aaraam/screens/contact.dart';

final List<String> imgList = [
  'https://www.drugvillatechnologies.com/aaram/oldfile/images/s1.jpg',
  'https://www.drugvillatechnologies.com/aaram/oldfile/images/s1.jpg'
];

class Dashboard extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
  int _current = 0;
  String email = '';
  String name = '';
  String mobile = '';

  _DashboardScreenState() {
    getStringValuesSF("USER_EMAIL").then((val) => setState(() {
          email = val;
        }));
    getStringValuesSF("USER_NAME").then((val) => setState(() {
          name = val;
        }));
    getStringValuesSF("USER_EMAIL").then((val) => setState(() {
          email = val;
        }));
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
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
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
              fontSize: 14.0,
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
     // width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 200.0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                SizedBox(height: 10.0),
                Text(
                  'Best Online courier in India At Affordable price',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    letterSpacing: 0.5,
                    fontFamily: 'OpenSans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 15.0),
                Text(
                  'Courier delivery rates for Delhi/NCR',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    letterSpacing: 0.5,
                    fontFamily: 'OpenSans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black38,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  padding: EdgeInsets.symmetric(vertical: 7.0),
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
              ])),
          Image.asset('assets/images/icon3.png'),
        ],
      ),
    );
  }

  Widget _buildBookOrder() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      decoration: whiteBackground,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset('assets/images/delivery.png'),
          SizedBox(width: 15.0),
          Container(
            width: 220.0,
            child: Column(
              children: <Widget>[
                Text(
                  'Fastest Peer to Peer Delivery Service in Delhi/NCR',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Low-priced same day delivery service!',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 14.0,
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
              fontSize: 16.0,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildContactInfo("Call us at", "+91 9898989898"),
                  _buildContactInfo(" Email us on", "info@aaraam.in"),
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

  Widget _buildContactInfo(String heading, String data) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 7.0),
        child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          color: Colors.white,
          elevation: 1.0,
          onPressed: () {
            /* DialPad(
                enableDtmf: true,
                outputMask: data,
                backspaceButtonIconColor: Colors.red,
                makeCall: (number) {
                  print(number);
                });*/
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

  Widget _buildTopSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildData(
            '2-3 hours\ndelivery',
            'We can deliver ASAP or at a specified time documents, products, flowers, any product.',
            'assets/images/icon1.png',
          ),
          _buildData(
            'Fastest courier serivce',
            'We can deliver ASAP or at a specified time documents, products, flowers, any product.',
            'assets/images/icon2.png',
          ),
        ],
      ),
    );
  }

  Widget _buildData(String heading, String description, String logo) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      decoration: kBoxDecorationStyle,
      width: 180.0,
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
              fontSize: 16.0,
              letterSpacing: 0.5,
              fontWeight: FontWeight.bold,
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
              fontSize: 14.0,
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
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          title,
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
                        _buildBookOrder(),
                        _buildTopSection(),
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
                fontSize: 16.0,
              ),
            ),
            accountEmail: Text(
              email,
              style: TextStyle(
                fontSize: 14.0,
              ),
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
            title: Text("Home"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.border_color,
              color: Colors.black26,
            ),
            title: Text("Book Courier"),
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
            title: Text("Pricing"),
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
              Icons.account_box,
              color: Colors.black26,
            ),
            title: Text("About Us"),
            onTap: () {
              Navigator.pop(context);
              _handleURLButtonPress(
                  context,
                  "https://www.drugvillatechnologies.com/oncology/mobile-about.php",
                  "About Us");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.policy,
              color: Colors.black26,
            ),
            title: Text("Privacy Policy"),
            onTap: () {
              Navigator.pop(context);
              _handleURLButtonPress(
                  context,
                  "https://www.drugvillatechnologies.com/oncology/mobile-privacy.php",
                  "Privacy Policy");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.black26,
            ),
            title: Text("Terms & Condition"),
            onTap: () {
              Navigator.pop(context);
              _handleURLButtonPress(
                  context,
                  "https://www.drugvillatechnologies.com/oncology/mobile-term.php",
                  "Terms & Condition");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.contacts,
              color: Colors.black26,
            ),
            title: Text("Contact Us"),
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
                Icons.logout,
                color: Colors.black26,
              ),
              title: Text("Logout"),
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
                            /* Positioned(
                              right: -40.0,
                              top: -40.0,
                              child: InkResponse(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: CircleAvatar(
                                  child: Icon(Icons.close),
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ),*/
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
