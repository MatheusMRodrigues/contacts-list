class Phone {
  int? id;
  String? phone;
  int? contact;

  Phone({this.id, this.phone, this.contact});

  Phone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    contact = json['FK_contact_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phone'] = phone;
    data['FK_contact_id'] = contact;
    return data;
  }
}
