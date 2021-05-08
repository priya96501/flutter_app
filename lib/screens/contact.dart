import 'dart:convert';

import 'package:Aaraam/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';

class Contact extends StatefulWidget {
  @override
  _ContactScreenWidget createState() => _ContactScreenWidget();
}

class _ContactScreenWidget extends State<Contact> {

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController mobileController = new TextEditingController();
  final TextEditingController messageController = new TextEditingController();

  Future<void> submitContactForm(String email, name, mobile, message) async {
    String baseUrl =
        "https://www.drugvillatechnologies.com/aaram/api/contact.php?";
    String finalUrl = baseUrl +
        "name=" +
        name +
        "&email=" +
        email +
        "&mobile=" +
        mobile +
        "&message=" +
        message;
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

        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.lightGreen,
          margin: EdgeInsets.all(10.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
          content: Text('Query Submitted Successfully!',
              style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0.5,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'OpenSans')),
          /*action: SnackBarAction(
              onPressed: () {},
              label: 'Undo',
            )*/
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Dashboard()),
            (Route<dynamic> route) => false);
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
            submitContactForm(emailController.text, nameController.text,
                mobileController.text, messageController.text);
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
          'SUBMIT',
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

  Widget _buildMobileTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Mobile Number',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          child: TextFormField(
              keyboardType: TextInputType.number,
              controller: mobileController,
              cursorColor: Colors.lightGreen,
              maxLines: 1,
              maxLength: 10,
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
                hintText: 'Enter your mobile number',
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

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          child: TextFormField(
              maxLines: 1,
              cursorColor: Colors.lightGreen,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                //contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.black26,
                ),
                hintText: 'Enter your email',
                hintStyle: kHintTextStyle,
              ),
              validator: MultiValidator([
                RequiredValidator(errorText: "* Please enter your email"),
                EmailValidator(errorText: "* Please enter valid email"),
              ])),
        ),
      ],
    );
  }

  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          child: TextFormField(
              maxLines: 1,
              cursorColor: Colors.lightGreen,
              controller: nameController,
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                prefixIcon: Icon(
                  Icons.account_box_outlined,
                  color: Colors.black26,
                ),
                hintText: 'Enter your name',
                hintStyle: kHintTextStyle,
              ),
              validator: MultiValidator([
                RequiredValidator(errorText: "* Please enter your name"),
                MinLengthValidator(2,
                    errorText: "Name must be more than 2 charater"),
              ])),
        ),
      ],
    );
  }

  Widget _buildMessageTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Message',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          child: TextFormField(
              cursorColor: Colors.lightGreen,
              controller: messageController,
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                focusColor: Colors.lightGreen,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                prefixIcon: Icon(
                  Icons.message_outlined,
                  color: Colors.black26,
                ),
                hintText: 'Enter your message',
                hintStyle: kHintTextStyle,
              ),
              validator: MultiValidator([
                RequiredValidator(errorText: "* Please enter your message"),
                MinLengthValidator(5,
                    errorText: "Message must be more than 5 charater"),
              ])),
        ),
      ],
    );
  }

  Widget _buildBottomInformation() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
        decoration: whiteBackground,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset('assets/images/telephone.png'),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Mobile Number',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 16.0,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          '+91 9898989898',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 14.0,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.normal,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Image.asset('assets/images/email.png'),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Email',
                          style: TextStyle(
                            letterSpacing: 0.5,
                            fontFamily: 'OpenSans',
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'info@aaraam.com',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            letterSpacing: 0.5,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset('assets/images/location.png'),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    width: 250.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Address',
                          style: TextStyle(
                            letterSpacing: 0.5,
                            fontFamily: 'OpenSans',
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          '7/27 Kriti Nagar Industrial Area New Delhi-110015',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            letterSpacing: 0.5,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          "Contact us",
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
                          vertical: 15.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset('assets/images/contactus.png'),
                            SizedBox(height: 12.0),
                            Text(
                              'Get in Touch',
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
                              'For any queries, please fill the form below',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black54,
                                fontFamily: 'OpenSans',
                                fontSize: 16.0,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Container(
                                child: Form(
                                    autovalidate: true,
                                    //check for validation while typing
                                    key: formkey,
                                    child: Column(children: <Widget>[
                                      _buildNameTF(),
                                      SizedBox(height: 20.0),
                                      _buildEmailTF(),
                                      SizedBox(height: 20.0),
                                      _buildMobileTF(),
                                      SizedBox(height: 20.0),
                                      _buildMessageTF(),
                                      SizedBox(height: 20.0),
                                      _buildSubmitBtn(),
                                    ]))),
                            SizedBox(height: 50.0),
                            Text(
                              'Reach Us At',
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
                              'Please feel free to contact us if you have any further questions or concerns',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black54,
                                fontFamily: 'OpenSans',
                                fontSize: 16.0,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            _buildBottomInformation(),
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
}
