import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Aaraam/screens/dashboard.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:Aaraam/utilities/constants.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<FormState> formkey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formkey3 = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _enable_mobile = true;
  bool viewVisible = false;
  bool viewVisibleCheckUSer = true;
  bool viewVisibleChangeNumber = false;
  bool viewVisiblePassword = false;
  bool _isLogin = false;
  String? user_id;
  final TextEditingController mobileController = new TextEditingController();
  final TextEditingController otpController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  void showWidget() {
    setState(() {
      viewVisible = true;
    });
  }

  void hideChangeNumberWidget() {
    setState(() {
      viewVisibleChangeNumber = false;
    });
  }

  void showWidgetPassword() {
    setState(() {
      viewVisiblePassword = true;
    });
  }

  void hidePasswordWidget() {
    setState(() {
      viewVisiblePassword = false;
    });
  }

  void showChangeNumberWidget() {
    setState(() {
      viewVisibleChangeNumber = true;
    });
  }

  void hideWidget() {
    setState(() {
      viewVisible = false;
    });
  }

  void showWidgetCheck() {
    setState(() {
      viewVisibleCheckUSer = true;
    });
  }

  void hideWidgetCheck() {
    setState(() {
      viewVisibleCheckUSer = false;
    });
  }

  Future<void> _checkUser(String mobile, String type) async {
    String baseUrl =
        "https://www.drugvillatechnologies.com/aaram/api/checkuser.php?";
    String finalUrl = baseUrl + "mobile=" + mobile + "&type=" + type;
    var jsonResponse = null;
    var response = await http.post(Uri.parse(finalUrl), headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    final String res = response.body;
    final int statusCode = response.statusCode;
    print(statusCode);
    print(finalUrl);
    if (statusCode == 200) {
      jsonResponse = json.decode(res);
      print(jsonResponse.toString());
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });

        Map<String, dynamic> map = jsonResponse;
        String? data = map["is_user"];
        user_id = map["user_id"];
        print(data);
        print(user_id);
        if (data == '1') {
          _isLogin = true;
          print(_isLogin);
        }

        showChangeNumberWidget(); // show change number button
        hideWidgetCheck(); // hide check user button
        _enable_mobile = false; // disable mobile textfield

        if (type == "otp") {
          final snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.lightGreen,
            margin: EdgeInsets.all(10.0),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
            content: Text('OTP send successfully!',
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans')),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          showWidget(); // show verify otp view
        } else {
          showWidgetPassword();
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  Future<void> _resendOTP(String mobile) async {
    String baseUrl =
        "https://www.drugvillatechnologies.com/aaram/api/sendotp.php?";
    String finalUrl;
    if (_isLogin) {
      finalUrl = baseUrl + "mobile=" + mobile + "&user_id=" + user_id!;
    } else {
      finalUrl = baseUrl + "mobile=" + mobile;
    }
    var jsonResponse = null;
    var response = await http.post(Uri.parse(finalUrl), headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    final String res = response.body;
    final int statusCode = response.statusCode;
    print(statusCode);
    print(finalUrl);
    if (statusCode == 200) {
      jsonResponse = json.decode(res);
      print(jsonResponse.toString());
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });

        Map<String, dynamic> map = jsonResponse;
        String? status = map["status"];
        String message = map["message"];
        print(status);
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
            content: Text(message,
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans')),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  Future<void> loginApi(String text, String mobile, String type) async {
    String baseUrl =
        "https://www.drugvillatechnologies.com/aaram/api/login.php?";
    String finalUrl = baseUrl +
        "mobile=" +
        mobile +
        "&" +
        type +
        "=" +
        text +
        "&user_id=" +
        user_id! +
        "&type=" +
        type;
    var jsonResponse = null;
    var response = await http.post(Uri.parse(finalUrl), headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    final String res = response.body;
    final int statusCode = response.statusCode;
    print(statusCode);
    print(finalUrl);
    if (statusCode == 200) {
      jsonResponse = json.decode(res);
      print(jsonResponse.toString());

      Map<String, dynamic> map = jsonResponse;
      String? status = map["status"];
      String? message = map["message"];

      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        if (status == '1') {
          String? user_id = map["user_id"];
          String? email = map["email"];
          String? mobile = map["mobile"];
          String? name = map["name"];
          // save user data in shared prefrence;
          saveStringInLocalMemory("USER_EMAIL", email!);
          saveStringInLocalMemory("USER_ID", user_id!);
          saveStringInLocalMemory("USER_NAME", name!);
          saveStringInLocalMemory("USER_MOBILE", mobile!);
          addBoolToSF("IS_LOGIN", true);

          gotoDashboard();
        } else {
          final snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            margin: EdgeInsets.all(10.0),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
            content: Text(message!,
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans')),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  Future<void> signupApi(String text, String mobile) async {
    String baseUrl =
        "https://www.drugvillatechnologies.com/aaram/api/checkotp.php?";
    String finalUrl = baseUrl + "mobile=" + mobile + "&otp=" + text;
    var jsonResponse = null;
    var response = await http.post(Uri.parse(finalUrl), headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    final String res = response.body;
    final int statusCode = response.statusCode;
    print(statusCode);
    print(finalUrl);
    if (statusCode == 200) {
      jsonResponse = json.decode(res);
      print(jsonResponse.toString());
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        Map<String, dynamic> map = jsonResponse;
        String? status = map["status"];
        String? message = map["message"];

        if (status == '1') {
          String? user_id = map["user_id"];
          String? email = map["email"];
          String? mobile = map["mobile"];
          String? name = map["name"];
          gotoDashboard();
          // save user data in shared prefrence;
          saveStringInLocalMemory("USER_EMAIL", email!);
          saveStringInLocalMemory("USER_ID", user_id!);
          saveStringInLocalMemory("USER_NAME", name!);
          saveStringInLocalMemory("USER_MOBILE", mobile!);
          addBoolToSF("IS_LOGIN", true);
          // save user data in shared prefrence;
        } else {
          final snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            margin: EdgeInsets.all(10.0),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
            content: Text(message!,
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans')),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  Widget _buildMobileWidget() {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Mobile Number',
                style: kLabelStyle,
              ),
              Visibility(
                  maintainAnimation: true,
                  maintainState: true,
                  visible: viewVisibleChangeNumber,
                  child: Container(
                      child: Column(children: <Widget>[
                    _buildChangeNumber(),
                  ])))
            ],
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          child: TextFormField(
              enabled: _enable_mobile,
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

  Widget _buildPasswordWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          textAlign: TextAlign.left,
          style: kLabelStyle,
        ),
        SizedBox(height: 5.0),
        Container(
          child: TextFormField(
              controller: passwordController,
              obscureText: true,
              cursorColor: Colors.lightGreen,
              maxLines: 1,
              maxLength: 16,
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                prefixIcon: Icon(
                  Icons.password,
                  color: Colors.black26,
                ),
                hintText: 'Enter your password',
                hintStyle: kHintTextStyle,
              ),
              validator: MultiValidator([
                RequiredValidator(errorText: "* Please enter your password"),
                MinLengthValidator(6,
                    errorText: 'Password should be 6 characters long.')
              ])),
        ),
      ],
    );
  }

  Widget _buildOTPWidget() {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '4-digit OTP',
                textAlign: TextAlign.left,
                style: kLabelStyle,
              ),
              _buildResendOtp()
            ],
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          child: TextFormField(
              controller: otpController,
              maxLength: 4,
              maxLines: 1,
              keyboardType: TextInputType.number,
              cursorColor: Colors.lightGreen,
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                prefixIcon: Icon(
                  Icons.input,
                  color: Colors.black26,
                ),
                hintText: 'Enter OTP sent on your mobile number',
                hintStyle: kHintTextStyle,
              ),
              validator: MultiValidator([
                RequiredValidator(errorText: "* Please enter 4-digit OTP"),
                MinLengthValidator(4, errorText: 'Please enter valid OTP')
              ])),
        ),
      ],
    );
  }

  Widget _buildChangeNumber() {
    return Container(
      child: FlatButton(
        onPressed: () {
          _isLogin = false;
          hideWidget();
          showWidgetCheck();
          mobileController.clear();
          _enable_mobile = true;
          hideChangeNumberWidget();
        },
        child: Text('Change Number',
            //textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.lightGreen,
              letterSpacing: 0.5,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            )),
      ),
    );
  }

  Widget _buildResendOtp() {
    return Container(
      child: FlatButton(
        onPressed: () => _resendOTP(mobileController.text),
        child: Text('Resend OTP',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.lightGreen,
              letterSpacing: 0.5,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            )),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.lightGreen),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.lightGreen,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 2.0,
        onPressed: () {
          if (formkey2.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });
            if (_isLogin) {
              loginApi(otpController.text, mobileController.text, "otp");
            } else {
              signupApi(otpController.text, mobileController.text);
            }
            print("Validated");
          } else {
            print("Not Validated");
          }
          // addStringToSF('IS_LOGIN', 'AARAAM');
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.lightGreen,
        child: Text(
          'VERIFY',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordLoginButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 2.0,
        onPressed: () {
          if (formkey3.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });
            loginApi(
                passwordController.text, mobileController.text, "password");
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
          'LOGIN',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildCheckUserButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 2.0,
        onPressed: () {
          if (formkey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });
            _checkUser(mobileController.text, "otp");
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
          'Login Using OTP',
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

  Widget _buildPasswordButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 2.0,
        onPressed: () {
          if (formkey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });
            _checkUser(mobileController.text, "password");
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
          'Login Through Password',
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

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        //SizedBox(height: 20.0),
        /* Text(
          'Sign in with',
          style: kLabelStyle,
        ),*/
      ],
    );
  }

  Widget _buildSocialBtn(String data, AssetImage logo) {
    return GestureDetector(
      onTap: () => print(data),
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 4.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            'Login with Facebook',
            AssetImage(
              'assets/images/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            'Login with Google',
            AssetImage(
              'assets/images/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          "Sign In / Sign up",
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
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
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
                          horizontal: 40.0,
                          vertical: 40.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            /* Text(
                              'Sign In / Sign Up',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),*/
                            Image.asset('assets/images/delivery.png'),
                            SizedBox(height: 40.0),
                            Container(
                                child: Form(
                                    autovalidate: true,
                                    //check for validation while typing
                                    key: formkey,
                                    child: Column(children: <Widget>[
                                      _buildMobileWidget(),
                                      SizedBox(height: 10.0),
                                      Visibility(
                                          maintainAnimation: true,
                                          maintainState: true,
                                          visible: viewVisibleCheckUSer,
                                          child: Container(
                                              child: Column(children: <Widget>[
                                            _buildCheckUserButton(),
                                            _buildSignInWithText(),
                                            _buildPasswordButton(),
                                          ])))
                                    ]))),
                            Visibility(
                                maintainAnimation: true,
                                maintainState: true,
                                visible: viewVisible,
                                child: Container(
                                    child: Form(
                                        autovalidate: true,
                                        //check for validation while typing
                                        key: formkey2,
                                        child: Column(
                                            /* crossAxisAlignment:
                                                CrossAxisAlignment.start,*/
                                            children: <Widget>[
                                              _buildOTPWidget(),
                                              SizedBox(height: 10.0),
                                              _buildVerifyButton(),
                                            ])))),
                            Visibility(
                                maintainAnimation: true,
                                maintainState: true,
                                visible: viewVisiblePassword,
                                child: Container(
                                    child: Form(
                                        autovalidate: true,
                                        //check for validation while typing
                                        key: formkey3,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              _buildPasswordWidget(),
                                              SizedBox(height: 10.0),
                                              _buildPasswordLoginButton(),
                                            ])))),
                            /*_buildSignInWithText(),*/
                            /*  _buildSocialBtnRow(),*/
                            /*_buildSignupBtn(),*/
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

  void gotoDashboard() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
        ModalRoute.withName("/dashboard"));
  }
}
