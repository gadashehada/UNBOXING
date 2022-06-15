import 'package:flutter/material.dart';
import 'package:shopping_app/values/en_strings.dart';
import 'package:shopping_app/views/splash_screen.dart';
import 'package:shopping_app/views/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '${EnStrings.getString('company_name')}',
      initialRoute: MySplashScreen.route ,
      routes: {
        Home.route : (context) => Home() ,
        MySplashScreen.route : (context) => MySplashScreen()
      },
      theme: ThemeData(
        fontFamily: 'lato',
        primaryColor: Colors.blueAccent,
        accentColor: Colors.blueAccent,
        appBarTheme: AppBarTheme(
          color: Colors.white ,
          textTheme: TextTheme(title: TextStyle(color: Colors.black ,fontSize: 20, fontWeight: FontWeight.w900)) ,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0 ,
        ),
        textTheme: TextTheme(
          headline1: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.w600),
          headline2: TextStyle(color: Colors.black,fontSize: 18, fontWeight: FontWeight.w600),
          bodyText1: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.w100),
          bodyText2: TextStyle(color: Colors.blueAccent,fontSize: 12, fontWeight: FontWeight.w600),
          button: TextStyle(color: Colors.white , fontSize: 16 , fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}