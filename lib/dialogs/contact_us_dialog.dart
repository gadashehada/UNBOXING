import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/values/en_strings.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ContactUsDialog extends StatefulWidget {
  @override
  _ContactUsDialogState createState() => _ContactUsDialogState();
}

class _ContactUsDialogState extends State<ContactUsDialog> {

  @override
  void initState() {
    super.initState();
  }

  Future<Map<String , dynamic>> getContactFromFireStore() async {
    await Firebase.initializeApp();
    final firestoreInstance = FirebaseFirestore.instance;
    DocumentSnapshot document = await firestoreInstance.collection("contact_us").doc('contact_document').get();
    return document.data();
  }

  Future<Map<String , dynamic>> getEmailFromFireStore() async {
    await Firebase.initializeApp();
    final firestoreInstance = FirebaseFirestore.instance;
    DocumentSnapshot document = await firestoreInstance.collection("contact_us").doc('email_document').get();
    return document.data();
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      insetPadding: EdgeInsets.all(10),
      elevation: 5,
      insetAnimationCurve: Curves.decelerate,
      insetAnimationDuration: Duration(milliseconds: 1000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          Container(
            width: 600,
            height: 250,
            child: SingleChildScrollView(
              physics:BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        '${EnStrings.getString('get_in_touch')}',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    SizedBox(height: 20,),
                    getContactUsContent(),
                    SizedBox(height: 17,),
                    getEmailContent(),
                  ]
                )
              )
            ) ,
            Positioned(
            top: 10, right: 10,
            child:IconButton(
              icon: Icon(Icons.close , color: Colors.black12),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ),
        ],
      )
    );
  }

  Widget getContactUsContent(){
    return FutureBuilder(
      future: getContactFromFireStore(),
      builder: (BuildContext context , AsyncSnapshot<Map<String , dynamic>> snapShot){
        switch(snapShot.connectionState){
          
          case ConnectionState.none:
            return Center(child: Container());
            break;
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
            break;
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator());
            break;
          case ConnectionState.done:
            if(snapShot.hasError){
              return Center(child: Text('something error\nplease check your internert connection'));
            }else if(snapShot.hasData){
              String content = snapShot.data['content'];
              
              return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        content.replaceAll('#', '\n'),
                        // 'If you have general questions or questions about your order you can email us. Please include your order number if necessary.' , 
                        style: TextStyle(color: Colors.black54 , fontSize: 14 , fontWeight: FontWeight.w400),
                      ),
                    );
        }
            break;
        }
        return Container();
      },
    );
  }

  Widget getEmailContent(){
    return FutureBuilder(
      future: getEmailFromFireStore(),
      builder: (BuildContext context , AsyncSnapshot<Map<String , dynamic>> snapShot){
        switch(snapShot.connectionState){
          
          case ConnectionState.none:
            return Center(child: Container());
            break;
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
            break;
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator());
            break;
          case ConnectionState.done:
            if(snapShot.hasError){
              return Center(child: Text('something error\nplease check your internert connection'));
            }else if(snapShot.hasData){
              String content = snapShot.data['content'];
              
              return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        onTap: () async {
                          Email email = Email(subject: 'Contact Us' , recipients:[content]);
                          await FlutterEmailSender.send(email);
                        },
                        child:Text(
                          content ,
                          style: TextStyle(color: Colors.blueAccent , decoration: TextDecoration.underline , fontSize: 15), 
                        ),),);
        }
            break;
        }
        return Container();
      },
    );
  }
}