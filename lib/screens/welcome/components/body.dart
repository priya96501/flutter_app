import 'package:flutter/material.dart';
import 'package:Aaraam/screens/welcome/components/background.dart';

import 'package:Aaraam/screens/login.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "WELCOME TO AARAAM",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.05),
            Image.asset("assets/images/onboarding_1.png"),
            /*  height: size.height * 0.45,*/

            SizedBox(height: size.height * 0.05),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: size.width * 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                color: Colors.lightGreen,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen()
                      ),
                      ModalRoute.withName("/login")
                  );
                 /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );*/
                },
                child: Text(
                  "CONTINUE",
                  style: TextStyle(color: Colors.white, letterSpacing: 1, fontSize: 16.0),
                ),
              ),
            ),
          ),
            //RoundedButton(text: "CONTINUE"),
          ],
        ),
      ),
    );
  }
}
