import 'dart:async';
import 'package:shopping_app/values/en_strings.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:shopping_app/views/home.dart';

class MySplashScreen extends StatefulWidget {

static final route = '/splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<MySplashScreen> {

@override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () => Navigator.pushReplacementNamed(context, Home.route));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // color: const Color(0x8842a5f5),
          color: Colors.black,
          image: DecorationImage(
            fit: BoxFit.fill ,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
            image: AssetImage('assets/images/playstore.png'),
          ),
        ) ,
        child: Center(
          child: Image.asset('assets/images/playstore.png' , width:180 , fit: BoxFit.fill),
          // child: Row(
          //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: <Widget>[
          //     // SizedBox(width:)
          //     Image.asset('assets/images/playstore.png' , width:100 , fit: BoxFit.fill),
          //     Text(EnStrings.getString('company_name') , style: Theme.of(context).textTheme.button.copyWith(fontWeight: FontWeight.w700 , fontSize: 22 , fontFamily: 'castoro'),),
          //   ]
          // ),
        ),
      ),
    );
  }
}
