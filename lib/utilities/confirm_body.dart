import 'package:flutter/material.dart';
import 'package:Aaraam/screens/welcome/components/background.dart';

class ConfirmBody extends StatelessWidget {
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
              "Booking Received Successfully",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                letterSpacing: 1,
                color: Colors.black,
                fontSize: 22.0,
                fontFamily: 'OpenSans',
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Image.asset("assets/images/book.jpg"),
            /*  height: size.height * 0.45,*/

            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
    );
  }
}
