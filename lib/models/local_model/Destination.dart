import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/values/en_strings.dart';

class Destination {
  const Destination(this.title , this.icon);
  final String title;
  final IconData icon;
  // final MaterialColor color;

  static List<Destination> allDestination = <Destination>[
    Destination('${EnStrings.getString('contact_us')}', Icons.contact_mail),
    Destination('${EnStrings.getString('FQS')}', Icons.question_answer),
  ];
}