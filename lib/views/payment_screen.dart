import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:shopping_app/api/api_repository.dart';
import 'package:shopping_app/api/payment_services/stripr_services.dart';
import 'package:shopping_app/card_validate/card_month_input_formatter.dart';
import 'package:shopping_app/card_validate/payment_card.dart';
import 'package:shopping_app/dialogs/privacy_dialog.dart';
import 'package:shopping_app/models/external_model/customer.dart';
import 'package:shopping_app/models/external_model/order.dart';
import 'package:shopping_app/values/en_strings.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PaymentScreen extends StatefulWidget {

  String price;
  PaymentScreen({this.price});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var _paymentCard = PaymentCard();
  var _autoValidate = false;

  var _numberController = new TextEditingController();
  var _emailController = new TextEditingController();
  var _nameController = new TextEditingController();
  var _phoneController = new TextEditingController();
  var _addressController = new TextEditingController();
  var _cityController = new TextEditingController();
  var _stateController = new TextEditingController();
  var _zipController = new TextEditingController();
  var _dateController = new TextEditingController();
  var _cvcController = new TextEditingController();
  var _ageController = new TextEditingController(text: '0');
  var _textEditingControllerMessage = new TextEditingController();

  Color emailColor = Colors.black38;
  Color nameColor = Colors.black38;
  Color phoneColor = Colors.black38;
  Color addressColor = Colors.black38;
  Color cityColor = Colors.black38;
  Color stateColor = Colors.black38;
  Color zipColor = Colors.black38;
  Color dateColor = Colors.black38;
  Color cvcColor = Colors.black38;

  bool _isLoading = false;
  Color color = Colors.blueAccent;
  Shipping shipping;
  Country _selectedCountry;
  // int _currentSizeSelection = 0;
  int _currentGenderSelection = 0;

  @override
  void initState() {
    super.initState();
    _paymentCard.type = CardType.Others;
    _numberController.addListener(_getCardTypeFrmNumber);
    StripeService.init();

    _nameController.addListener(() {
      String value = _nameController.text;
      if (value != null && value.isNotEmpty) {
        setState(() {
          nameColor = Colors.green;
        });
      }else{
        setState(() {
          nameColor = Colors.black45;
        });
      }
    });

    _phoneController.addListener(() {
      String value = _phoneController.text;
      if (value != null && value.isNotEmpty) {
        setState(() {
          phoneColor = Colors.green;
        });
      }else{
        setState(() {
          phoneColor = Colors.black45;
        });
      }
    });

    _addressController.addListener(() {
      String value = _addressController.text;
      if (value != null && value.isNotEmpty) {
        setState(() {
          addressColor = Colors.green;
        });
      }else{
        setState(() {
          addressColor = Colors.black45;
        });
      }
    });
    _cityController.addListener(() {
      String value = _cityController.text;
      if (value != null && value.isNotEmpty) {
        setState(() {
          cityColor = Colors.green;
        });
      }else{
        setState(() {
          cityColor = Colors.black45;
        });
      }
    });
    _stateController.addListener(() {
      String value = _stateController.text;
      if (value != null && value.isNotEmpty) {
        setState(() {
          stateColor = Colors.green;
        });
      }else{
        setState(() {
          stateColor = Colors.black45;
        });
      }
    });
    _zipController.addListener(() {
      String value = _zipController.text;
      if (value != null && value.isNotEmpty) {
        setState(() {
          zipColor = Colors.green;
        });
      }else{
        setState(() {
          zipColor = Colors.black45;
        });
      }
    });
    _dateController.addListener(() {
      String value = _dateController.text;
      if (value != null && value.isNotEmpty) {
        setState(() {
          dateColor = Colors.green;
        });
      }else{
        setState(() {
          dateColor = Colors.black45;
        });
      }
    });
    _cvcController.addListener(() {
      String value = _cvcController.text;
      if (value != null && value.isNotEmpty) {
        setState(() {
          cvcColor = Colors.green;
        });
      }else{
        setState(() {
          cvcColor = Colors.black45;
        });
      }
    });
    _emailController.addListener(() {
      String text = _emailController.text;
      if (text != null && text.isNotEmpty && RegExp('[A-Za-z0-9._%-]+@[A-Za-z0-9._%-]+.[A-Za-z]{2,4}').hasMatch(text)) {
        setState(() {
          emailColor = Colors.green;
        });
      }else{
        setState(() {
          emailColor = Colors.black45;
        });
      }
    });
  }

  // segmantSize(){
  //   Map<int , Widget> _children = {
  //     0 : Text('XS') ,
  //     1 : Text('Small') ,
  //     2 : Text(' Medium ') ,
  //     3 : Text('Large') ,
  //     4 : Text('XL') ,
  //     5 : Text('XXL')
  //   };

  //   return MaterialSegmentedControl(
  //     children: _children, 
  //     onSegmentChosen: (index){
  //       setState(() {
  //         _currentSizeSelection = index;
  //       });
  //     }, 
  //     unselectedColor: Colors.white, 
  //     selectedColor: Colors.blueAccent ,
  //     selectionIndex: _currentSizeSelection,
  //     borderRadius: 32.0,
  //   );
  // }

  segmantGender(){
    Map<int , Widget> _children = {
      0 : Text('Male') ,
      1 : Text(' Female ') ,
      2 : Text('Child') 
    };

    return MaterialSegmentedControl(
      children: _children, 
      onSegmentChosen: (index){
        setState(() {
          _currentGenderSelection = index;
        });
      }, 
      unselectedColor: Colors.white, 
      selectedColor: Colors.blueAccent ,
      selectionIndex: _currentGenderSelection,
      borderRadius: 32.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey ,
      appBar: AppBar(
        centerTitle: true,
        title: Text(EnStrings.getString('payment')),
      ),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child:Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.only(left:20),
                    child: Text(
                      'VARIATIONS',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(20),
                    clipBehavior: Clip.hardEdge,
                    elevation: 15,
                    shadowColor: Colors.black26,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 90,
                        child: Column(
                          crossAxisAlignment : CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            // Padding(
                            //   padding: EdgeInsets.only(left: 20),
                            //   child: Text('Size'),
                            // ),
                            // SizedBox(height: 5),
                            // segmantSize(),
                            // SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment : CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text('Gender'),
                                    ),
                                    SizedBox(height: 5),
                                    segmantGender(),
                                  ]
                                ),
                                Column(
                                  crossAxisAlignment : CrossAxisAlignment.start,
                                  children: [
                                    Text('Age'),
                                    SizedBox(height: 10),
                                    Container(
                                    height: 30,
                                    width: 70,
                                    child: TextFormField(
                                        controller: _ageController,
                                        maxLength: 2,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                        counterText: '',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(width: 0.5),
                                        ),),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width:10),
                              ]
                            ),
                            SizedBox(height: 15),
                          ]
                        ),
                  )),
                  Container(
                    margin: EdgeInsets.only(left:20),
                    child: Text(
                      '${EnStrings.getString('shipping')}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(20),
                    clipBehavior: Clip.hardEdge,
                    elevation: 15,
                    shadowColor: Colors.black26,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 460,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 15,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _nameController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: nameColor)),
                                    border: UnderlineInputBorder(borderSide: BorderSide(color: nameColor)),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: nameColor == Colors.green?nameColor : Colors.blueAccent)),
                                    prefixIcon: Icon(Icons.account_box , color: nameColor),
                                    hintText: '${EnStrings.getString('name')}',
                                    hintStyle: TextStyle(
                                      color: const Color(0xffA2A2A2),
                                      fontSize: 14)),
                                ),),
                              SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: emailColor)),
                                    border: UnderlineInputBorder(borderSide: BorderSide(color: emailColor)),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: emailColor == Colors.green?emailColor : Colors.blueAccent)),
                                    prefixIcon: Icon(Icons.email , color: emailColor,),
                                    hintText: '${EnStrings.getString('email')}',
                                    hintStyle: TextStyle(
                                      color: const Color(0xffA2A2A2),
                                      fontSize: 14)),
                                ),),
                                SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _phoneController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: phoneColor)),
                                    border: UnderlineInputBorder(borderSide: BorderSide(color: phoneColor)),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: phoneColor == Colors.green?phoneColor : Colors.blueAccent)),
                                    prefixIcon: Icon(Icons.phone , color: phoneColor),
                                    hintText: '${EnStrings.getString('phone')}',
                                    hintStyle: TextStyle(
                                      color: const Color(0xffA2A2A2),
                                      fontSize: 14)),
                                ),),
                              SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  controller: _addressController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: addressColor)),
                                    border: UnderlineInputBorder(borderSide: BorderSide(color: addressColor)),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: addressColor == Colors.green?addressColor : Colors.blueAccent)),
                                    prefixIcon: Icon(Icons.home , color: addressColor),
                                    hintText: '${EnStrings.getString('address')}',
                                    hintStyle: TextStyle(
                                      color: const Color(0xffA2A2A2),
                                      fontSize: 14)),
                                ),),
                              SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _cityController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: cityColor)),
                                    border: UnderlineInputBorder(borderSide: BorderSide(color: cityColor)),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: cityColor == Colors.green?cityColor : Colors.blueAccent)),
                                    prefixIcon: Icon(Icons.location_city , color: cityColor),
                                    hintText: '${EnStrings.getString('city')}',
                                    hintStyle: TextStyle(
                                      color: const Color(0xffA2A2A2),
                                      fontSize: 14)),
                                ),),
                                SizedBox(height: 5,),
                                Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _stateController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: stateColor)),
                                    border: UnderlineInputBorder(borderSide: BorderSide(color: stateColor)),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: stateColor == Colors.green?stateColor : Colors.blueAccent)),
                                    prefixIcon: Icon(Icons.account_tree , color: stateColor),
                                    hintText: '${EnStrings.getString('state')}',
                                    hintStyle: TextStyle(
                                      color: const Color(0xffA2A2A2),
                                      fontSize: 14)),
                                ),),
                                SizedBox(height: 5,),
                                Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _zipController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: zipColor)),
                                    border: UnderlineInputBorder(borderSide: BorderSide(color: zipColor)),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: zipColor == Colors.green?zipColor : Colors.blueAccent)),
                                    prefixIcon: Icon(Icons.home_filled , color: zipColor,),
                                    hintText: '${EnStrings.getString('zip')}',
                                    hintStyle: TextStyle(
                                      color: const Color(0xffA2A2A2),
                                      fontSize: 14)),
                                ),),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: CountryPicker(
                                      selectedCountry: _selectedCountry,
                                      showDialingCode: true,
                                      nameTextStyle: TextStyle(color: Colors.black , fontSize: 14,fontWeight: FontWeight.w400),
                                      dialingCodeTextStyle: TextStyle(color: Colors.black , fontSize: 14,fontWeight: FontWeight.w400),
                                      showFlag: true,
                                      onChanged: (Country country){
                                        setState(() {
                                          _selectedCountry = country;
                                          _stateController.text = country.isoCode;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                            ],
                          ),
                        ),),
                  ),
                  Container(
                    margin: EdgeInsets.only(left:20),
                    child: Text(
                      '${EnStrings.getString('payment_info')}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(20),
                    clipBehavior: Clip.hardEdge,
                    elevation: 15,
                    shadowColor: Colors.black26,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 165,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  controller: _numberController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly,
                                    new LengthLimitingTextInputFormatter(19),
                                    new CardNumberInputFormatter()
                                  ],
                                  validator: CardUtils.validateCardNum,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                     icon: CardUtils.getCardIcon(_paymentCard.type),
                                    hintText: '${EnStrings.getString('card')}',
                                    hintStyle: TextStyle(
                                      color: const Color(0xffA2A2A2),
                                      fontSize: 14)),
                                  onSaved: (newValue){
                                    _paymentCard.number = CardUtils.getCleanedNumber(newValue);
                                  },
                                ),),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: TextFormField(
                                          controller: _dateController,
                                          inputFormatters: [
                                            WhitelistingTextInputFormatter.digitsOnly,
                                            new LengthLimitingTextInputFormatter(4),
                                            new CardMonthInputFormatter()
                                          ],
                                          validator: CardUtils.validateDate,
                                          keyboardType: TextInputType.number,
                                          onSaved: (value) {
                                            List<int> expiryDate = CardUtils.getExpiryDate(value);
                                            _paymentCard.month = expiryDate[0];
                                            _paymentCard.year = expiryDate[1];
                                          },
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: dateColor)),
                                          border: UnderlineInputBorder(borderSide: BorderSide(color: dateColor)),
                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: dateColor == Colors.green?dateColor : Colors.blueAccent)),
                                            prefixIcon: Icon(Icons.date_range , color: dateColor),
                                            hintText: 'YY/MM',
                                            hintStyle: TextStyle(
                                              color: const Color(0xffA2A2A2),
                                              fontSize: 14)),
                                        ),),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: TextFormField(
                                          controller: _cvcController,
                                          inputFormatters: [
                                            WhitelistingTextInputFormatter.digitsOnly,
                                            new LengthLimitingTextInputFormatter(4),
                                          ],
                                          validator: CardUtils.validateCVV,
                                            keyboardType: TextInputType.number,
                                            onSaved: (value) {
                                              _paymentCard.cvv = int.parse(value);
                                            },
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: cvcColor)),
                                            border: UnderlineInputBorder(borderSide: BorderSide(color: cvcColor)),
                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: cvcColor == Colors.green?cvcColor : Colors.blueAccent)),
                                            prefixIcon: Icon(Icons.confirmation_num_sharp , color:cvcColor),
                                            hintText: 'CVC',
                                            hintStyle: TextStyle(
                                              color: const Color(0xffA2A2A2),
                                              fontSize: 14)),
                                        ),),
                                    ),
                                  ],
                                ),
                            ]),
                        ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left:20),
                    child: Text(
                      'ADD AN OPTIONAL NOTE TO THE SELLER',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(20),
                    clipBehavior: Clip.hardEdge,
                    elevation: 15,
                    shadowColor: Colors.black26,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              controller: _textEditingControllerMessage,
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: 5,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0 , horizontal: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(width: 1),
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 13, 0, 50),
                                child: Icon(Icons.message),
                              ),
                              hintText: '${EnStrings.getString('message')}',
                              hintStyle: TextStyle(
                                color: const Color(0xffA2A2A2),
                                fontSize: 14)),
                            ),),
                        ),
                  )),
                  Container(
                    margin: EdgeInsets.only(right:20 , left:30, bottom:20),
                    child: Row(
                      children: [
                        Text(
                          'I hereby accept ',
                          style: TextStyle(color: Colors.black54),  
                        ),
                        InkWell(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return PrivacyDialog();
                              }
                            );
                          },
                          child: Text(
                            'Componay trems ',
                            style: TextStyle(color: Colors.blueAccent , decoration: TextDecoration.underline),  
                          ),
                        ),
                        Text(
                          'of purchase.',
                          style: TextStyle(color: Colors.black54),  
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60,),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: RaisedButton(
                  color: color,
                  disabledColor: Colors.blueAccent,
                  child: _isLoading?CircularProgressIndicator():Text('Buy Now ${widget.price}\$' , style: Theme.of(context).textTheme.button.copyWith(fontWeight: FontWeight.w400 , fontSize: 20),),
                  onPressed: checkColors()?_validateInputs:null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _numberController.removeListener(_getCardTypeFrmNumber);
    _emailController.dispose();
    _addressController.dispose();
    _nameController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(_numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: new Duration(seconds: 3),
    ));
  }

  _validateInputs() {
      final FormState form = _formKey.currentState;
      if (!form.validate()) {
        setState(() {
          _autoValidate = true; // Start validating on every change.
        });
        _showInSnackBar('Please fix the errors in red before submitting.');
      }else if(_selectedCountry == null){
          _showInSnackBar('Please choose your country');
      }else {
        setState((){
          color = Colors.black12;
          _isLoading = true;
        });
        form.save();
        createAllneededData();
      }
  }

  bool checkColors(){
    return emailColor == Colors.green &&
          nameColor == Colors.green &&
          addressColor == Colors.green &&
          cityColor == Colors.green &&
          stateColor == Colors.green &&
          zipColor == Colors.green &&
          dateColor == Colors.green &&
          cvcColor == Colors.green;
  }

  payViaNewCard(String customerId , String orderId) async {
    final CreditCard userCard = CreditCard(
      number: _numberController.text,
      expMonth: _paymentCard.month,
      expYear: _paymentCard.year,
    );
    var response = await StripeService.payWithNewCard(
      userCard: userCard,
      amount: '${int.parse(widget.price) * 100}',
      currency: 'USD' ,
      shipping: shipping ,
      customerId:customerId,
      orderId: orderId ,
      email: _emailController.text ,
    );
        
      setState((){
        color = Colors.blueAccent;
        _isLoading = false;
      });

    if(response.success){
      CoolAlert.show(
        context : context ,
        type : CoolAlertType.success ,
        text : response.message ,
        confirmBtnColor: Colors.blueAccent,
        onConfirmBtnTap: () =>Navigator.popUntil(context, (route) => route.isFirst)
      );
    }else {
      CoolAlert.show(
        context : context ,
        type : CoolAlertType.error ,
        text : response.message ,
      );
    }
  }

  createAllneededData() async {
    shipping = Shipping(
      phone: _phoneController.text,
      name: _nameController.text ,
      address: Address(
        city: _cityController.text ,
        country: _selectedCountry.name ,
        line1: _addressController.text ,
        postalCode: _zipController.text ,
        state: _stateController.text
      )
    );

    // String size;
    // switch (_currentSizeSelection) {
    //   case 0:
    //     size = 'XS';
    //     break;
    //   case 1:
    //     size = 'small';
    //     break;
    //   case 2:
    //     size = 'Medium';
    //     break;
    //   case 3:
    //     size = 'Large';
    //     break;
    //   case 4:
    //     size = 'XL';
    //     break;
    //   case 5:
    //     size = 'XXL';
    //     break;
    //   default:
    //     size = 'XS';
    // }

    String gender;
    switch (_currentGenderSelection) {
      case 0:
        gender = 'Male';
        break;
      case 1:
        gender = 'Female';
        break;
      case 2:
        gender = 'Child';
        break;
      default:
        gender = 'Male';
    }

    String skuId = await APIRepository.repository.getSkuIdFromApi;
    String customerId = await APIRepository.repository.createCustomerAndGetId(
      Customer(
        email: _emailController.text ,
        name: _nameController.text ,
        shipping: shipping
      )
    );

    Order order = Order(
        amount: int.parse(widget.price) ,
        currency: 'usd',
        customer: customerId ,
        email: _emailController.text ,
        metadata: Metadata(gender: gender , age: _ageController.text , note: _textEditingControllerMessage.text),
        shipping: shipping ,
        items: [Items(
          amount: int.parse(widget.price),
          currency: 'usd' ,
          type: 'sku' ,
          parent: skuId 
        )],
      );
    String orderId = await APIRepository.repository.createOrderAndGetId(order);

    // print(orderId);
    // SendGirdServices sendGirdServices = SendGirdServices(toEmail :_emailController.text , fromEmail: 'kungsoo.jungin@gmail.com');
    // sendGirdServices.sendConfirmationEmail(orderId , order);
    payViaNewCard(customerId , orderId);
  }
}