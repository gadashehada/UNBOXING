import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/values/en_strings.dart';

class FQSDialog extends StatefulWidget {
  @override
  _FQSDialogState createState() => _FQSDialogState();
}

class _FQSDialogState extends State<FQSDialog> {

  Future<Map<String , dynamic>> getFQSFromFireStore() async {
    await Firebase.initializeApp();
    final firestoreInstance = FirebaseFirestore.instance;
    DocumentSnapshot document = await firestoreInstance.collection("FQS").doc('FQS_document').get();
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
            height: MediaQuery.of(context).size.height / 1.3,
            child: SingleChildScrollView(
              physics:BouncingScrollPhysics(),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        '${EnStrings.getString('FQS')}',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    getFQSContent(),
                  ],
                ),
              ),
            ),
          ),
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
      ),
    );
  }

    Widget getFQSContent(){
    return FutureBuilder(
      future: getFQSFromFireStore(),
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
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        content.replaceAll('#', '\n'),
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
}