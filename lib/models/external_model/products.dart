class Products {
	String id;
	String description;
	List<String> images;
	String name;
  bool livemode;

	Products({this.id, this.description, this.images, this.name});

	Products.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		description = json['description'];
		images = json['images'].cast<String>();
		name = json['name'];
    livemode = json['livemode'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['description'] = this.description;
    data['images'] = this.images;
		data['name'] = this.name;
    data['livemode'] = this.livemode;
		return data;
	}
}
