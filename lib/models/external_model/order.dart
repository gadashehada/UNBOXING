import 'customer.dart';

class Order {
  String id;
  int amount;
  String currency;
  String customer;
  String email;
  List<Items> items;
  bool livemode;
  Metadata metadata;
  Shipping shipping;

  Order(
      {this.id,
      this.amount,
      this.currency,
      this.customer,
      this.email,
      this.items,
      this.livemode,
      this.metadata,
      this.shipping});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    currency = json['currency'];
    customer = json['customer'];
    email = json['email'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    livemode = json['livemode'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['customer'] = this.customer;
    data['email'] = this.email;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['livemode'] = this.livemode;
    if (this.metadata != null) {
      data['metadata'] = this.metadata.toJson();
    }
    if (this.shipping != null) {
      data['shipping'] = this.shipping.toJson();
    }
    return data;
  }
}

class Items {
  String object;
  int amount;
  String currency;
  String description;
  String parent;
  int quantity;
  String type;

  Items(
      {this.object,
      this.amount,
      this.currency,
      this.description,
      this.parent,
      this.quantity,
      this.type});

  Items.fromJson(Map<String, dynamic> json) {
    object = json['object'];
    amount = json['amount'];
    currency = json['currency'];
    description = json['description'];
    parent = json['parent'];
    quantity = json['quantity'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object'] = this.object;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['description'] = this.description;
    data['parent'] = this.parent;
    data['quantity'] = this.quantity;
    data['type'] = this.type;
    return data;
  }
}

class Metadata {
  // String size;
  String gender;
  String age;
  String note;

  Metadata({this.gender , this.age , this.note});

  Metadata.fromJson(Map<String, dynamic> json) {
    // size = json['size'];
    gender = json['gender'];
    age = json['age'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['size'] = this.size;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['note'] = this.note;
    return data;
  }
}
