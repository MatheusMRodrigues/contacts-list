class Contact {
  int? id;
  String? avatar;
  String? name;
  String? zipCode;
  String? city;
  String? state;
  String? address;
  String? number;
  String? complement;

  Contact(
      {this.id,
      this.avatar,
      this.name,
      this.zipCode,
      this.city,
      this.state,
      this.address,
      this.number,
      this.complement});

  Contact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    name = json['name'];
    zipCode = json['zipCode'];
    city = json['city'];
    state = json['state'];
    address = json['address'];
    number = json['number'];
    complement = json['complement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['avatar'] = avatar;
    data['name'] = name;
    data['zipCode'] = zipCode;
    data['city'] = city;
    data['state'] = state;
    data['address'] = address;
    data['number'] = number;
    data['complement'] = complement;
    return data;
  }
}
