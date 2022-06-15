class EnStrings {
  static Map<String , String> data = {
    'company_name' : 'UNBOXING CLUB' ,
    'contact_us' : 'Contact Us' ,
    'get_in_touch' : 'Get in touch' ,
    'FQS' : 'FQS' ,
    'about_us' : 'ABOUT US' ,
    'payment' : 'PAYMENT' ,
    'send' : 'Send' ,
    'message' : 'Note' ,
    'privacy' : 'Company Trems & Conditions' ,
    'shipping' : 'SHIPPING & BILLING INFORMATION' , 
    'payment_info' : 'PAYMENT INFORMATION' ,
    'name' : 'Name' ,
    'phone' : 'Phone',
    'email' : 'Email' ,
    'address' : 'Address' ,
    'city' : 'City' ,
    'state' : 'State' ,
    'zip' : 'ZIP' ,
    'country' : 'Country' ,
    'card' : 'Card number' ,
  };

  static String getString(String key) => data[key];
}