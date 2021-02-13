class Contact {
  String uid;
  String number, first_name, last_name, address, company, email, message;
  var avatar;
  int id;
  String status;

  Contact(
      {this.id,
      this.first_name,
      this.last_name,
      this.email,
      this.number,
      this.address,
      this.company,
      this.status});

  initials() {
    if (this.first_name.isNotEmpty || this.last_name.isNotEmpty)
      return ((this.first_name?.isNotEmpty == true ? this.first_name[0] : "") +
              (this.last_name?.isNotEmpty == true ? this.last_name[0] : ""))
          .toUpperCase();
    return '';
  }

  Map toMap(Contact contact) {
    var data = Map<String, dynamic>();

    data['id'] = contact.id;
    data['first_name'] = contact.first_name;
    data['last_name'] = contact.last_name;
    data['number'] = contact.number;
    data['address'] = contact.address;
    data['company'] = contact.company;
    data['email'] = contact.email;
    data['status'] = contact.status;
    return data;
  }

  Contact.fromMap(Map<String, dynamic> mapData) {
    this.id = mapData['id'];
    this.message = mapData['message'];
    this.first_name = mapData['first_name'];
    this.last_name = mapData['last_name'];
    this.number = mapData['number'];
    this.address = mapData['address'];
    this.company = mapData['company'];
    this.email = mapData['email'];
    if (mapData.containsKey('status')) {
      this.status = mapData['status'];
    } else {
      this.status = 'active';
    }
    this.avatar = null;
  }
}
