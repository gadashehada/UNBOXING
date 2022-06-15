class Customer {
	String id;
	String email;
	bool livemode;
	String name;
	Shipping shipping;

	Customer({this.id, this.email, this.livemode, this.name,this.shipping});

	Customer.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		email = json['email'];
		livemode = json['livemode'];
		name = json['name'];
		shipping = json['shipping'] != null ? new Shipping.fromJson(json['shipping']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['email'] = this.email;
		data['name'] = this.name;
		return data;
	}
}

class Shipping {
	Address address;
	String name;
  String phone;

	Shipping({this.address, this.name , this.phone});

	Shipping.fromJson(Map<String, dynamic> json) {
		address = json['address'] != null ? new Address.fromJson(json['address']) : null;
		name = json['name'];
    phone = json['phone'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.address != null) {
      data['address'] = this.address.toJson();
    }
		data['name'] = this.name;
    data['phone'] = this.phone;
		return data;
	}
}

class Address {
	String city;
	String country;
	String line1;
	String postalCode;
	String state;

	Address({this.city, this.country, this.line1, this.postalCode, this.state});

	Address.fromJson(Map<String, dynamic> json) {
		city = json['city'];
		country = json['country'];
		line1 = json['line1'];
		postalCode = json['postal_code'];
		state = json['state'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['city'] = this.city;
		data['country'] = this.country;
		data['line1'] = this.line1;
		data['postal_code'] = this.postalCode;
		data['state'] = this.state;
		return data;
	}
}
