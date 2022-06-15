import 'package:flutter/material.dart';
import 'package:shopping_app/api/api_repository.dart';
import 'package:shopping_app/dialogs/contact_us_dialog.dart';
import 'package:shopping_app/dialogs/fqs_dialog.dart';
import 'package:shopping_app/models/external_model/products.dart';
import 'package:shopping_app/models/local_model/Destination.dart';
import 'package:shopping_app/values/en_strings.dart';
import 'package:shopping_app/views/payment_screen.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Home extends StatefulWidget {

    static Products p ;
    static final route = '/home_screen';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  int _currentIndex = 0;
  Future<Products> product;
  String price = '0';
  double height;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    try{
      product = APIRepository.repository.getDataProductsFromApi.then(
        (value) => value[0]
      );
    }catch(error){
      _showInSnackBar('Something Wants Error');
    }
  }

  getMessagingNotifaction(){
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        print(notification['title']);
        print(notification['body']);
      },
    );
  }

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: new Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(EnStrings.getString('company_name')),
        actions: <Widget>[
            FlatButton(
              onPressed: () { 
                Navigator.pushReplacement(context, MaterialPageRoute(
                                            builder: (context) => Home(),
                                          ),);
              },
              child: Icon(Icons.replay),
            ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: Size.infinite.width,
              height: height > 640.0?height/3.0 : height/2.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/background_product.jpg'),
                ),
              ),
              child: productFutureBuilder(),
            ),
            Container(
              color: Colors.blueAccent,
              width: Size.infinite.width,
              height: 5,
            ),
            SizedBox(height: 30,),
            Text(
              '${EnStrings.getString('about_us')}',
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(height: 20,),
            productDescriptionFutureBuilder(),
            SizedBox(height: 20,),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white54,
        currentIndex: _currentIndex,
        onTap: (index){
          setState(() {
            _currentIndex = index;
            showDialog(
              context: context,
              builder: (BuildContext context){
                return index ==0?ContactUsDialog() : FQSDialog();
              }
            );
          });
        },
        items : Destination.allDestination.map((destination){
          return BottomNavigationBarItem(
            icon: SizedBox( height: 40, child: Icon(destination.icon)) ,
            title: SizedBox(height: 30 , child: Text(destination.title)),
          );
        }).toList(),
      ),
    );
  }

   Widget productFutureBuilder(){
    return FutureBuilder(
      future: product ,
      builder: (BuildContext context , AsyncSnapshot<Products> snapshot){
        switch(snapshot.connectionState){
          
          case ConnectionState.none:
            return Center(heightFactor: 4 ,child: CircularProgressIndicator());
            break;
          case ConnectionState.waiting:
            return Center(heightFactor : 4 ,child: CircularProgressIndicator());
            break;
          case ConnectionState.active:
            return Center(heightFactor : 4 ,child: CircularProgressIndicator());
            break;
          case ConnectionState.done:
            if(snapshot.hasError){
              return Center(heightFactor : 4 ,child: Text('Something Error\nplease check you internet connection\nand try again later' , textAlign: TextAlign.center,));
            }else{
              Home.p = snapshot.data;
              return productView(snapshot.data);
            }
            break;
        }
        return Container();
      },
    );
  }

  Widget productDescriptionFutureBuilder(){
    return FutureBuilder(
      future: product ,
      builder: (BuildContext context , AsyncSnapshot<Products> snapshot){
        switch(snapshot.connectionState){
          
          case ConnectionState.none:
            return Center(heightFactor: 4 ,child: CircularProgressIndicator());
            break;
          case ConnectionState.waiting:
            return Center(heightFactor : 4 ,child: CircularProgressIndicator());
            break;
          case ConnectionState.active:
            return Center(heightFactor : 4 ,child: CircularProgressIndicator());
            break;
          case ConnectionState.done:
            if(snapshot.hasError){
              return Center(heightFactor : 4 ,child: Text('Something Error\nplease check you internet connection\nand try again later' , textAlign: TextAlign.center,));
            }else{
              return descriptionView(snapshot.data.description);
            }
            break;
        }
        return Container();
      },
    );
  }

  Widget productView(Products products){
    return Row(
                children: [
                  SizedBox(width: 10,),
                  Container(
                    width: MediaQuery.of(context).size.width/2.8,
                    height: height > 640.0? 183 : height/3.5,
                    child: Stack(
                      children: [
                        Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),),),
                        FadeInImage.memoryNetwork(
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width/2.8,
                          height: height > 640.0? 183 : height/3.5,
                          placeholder: kTransparentImage,
                          image: products.images != null?products.images[0]:'',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 40,),
                  Expanded(
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 40,),
                          Text('${products.name}' , style: Theme.of(context).textTheme.headline1,),
                          SizedBox(height: 20,),
                          Expanded(
                            child: Text(
                              '${products.description}',
                              style: Theme.of(context).textTheme.bodyText1,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right:10),
                            clipBehavior: Clip.hardEdge,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                                children: [
                                  Container(
                                    color: Colors.blueAccent,
                                    child: RaisedButton(
                                      color: Colors.blueAccent,
                                      elevation: 7,
                                      onPressed: (){
                                        Navigator.push(context, 
                                          MaterialPageRoute(
                                            builder: (context) => PaymentScreen(price: price),
                                          ),
                                        );
                                      } ,
                                      child: Text('Buy Now' , style: Theme.of(context).textTheme.button.copyWith(fontSize: 14)),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(5) , topRight: Radius.circular(5) ),
                              color: Colors.white,
                            ),
                                    width: 68,
                                    // color: Colors.white,
                                    child: RaisedButton(
                                      color: Colors.white70,
                                      elevation: 6,
                                      onPressed: (){
                                        Navigator.push(context, 
                                          MaterialPageRoute(
                                            builder: (context) => PaymentScreen(price: price),
                                          ),
                                        );
                                      } ,
                                      child: FutureBuilder(
                                        future: APIRepository.repository.getPriceFromApi,
                                        builder: (BuildContext context , AsyncSnapshot<String> snapshot){
                                          if(snapshot.hasData){
                                            int p = int.parse(snapshot.data) ~/ 100;
                                            price = '$p';
                                            return FittedBox(
                                              fit: BoxFit.cover,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('\$', style: Theme.of(context).textTheme.button.copyWith(fontSize: 20 , color: Colors.red , fontWeight: FontWeight.w600)),
                                                  Text('$price' , style: Theme.of(context).textTheme.button.copyWith(fontSize: 50 , color: Colors.red , fontWeight: FontWeight.w900))
                                                ],
                                              ),
                                            );
                                          }else{
                                            print(snapshot.error);
                                            return Container();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(height: 40,)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                ],
              );
  }

  Widget descriptionView(String desc){
    return Container(
              margin: EdgeInsets.only(left: 20 , right: 20),
              child: Text(
                '$desc',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54 , fontWeight: FontWeight.w400),
              ),
            );
  }
}