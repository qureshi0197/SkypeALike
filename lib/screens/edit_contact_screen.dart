import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skypealike/constants/strings.dart';
import 'package:skypealike/constants/styles.dart';
import 'package:skypealike/db/database_helper.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/widgets/custom_text_row.dart';

import '../main.dart';

class EditContact extends StatefulWidget {
  Contact contact;
  bool update;
  EditContact(this.contact, {bool update}) {
    if (update == null) {
      update = true;
    } else {
      this.update = update;
    }
  }

  @override
  _EditContactState createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  Contact contact = Contact();

  var text_Field_height = 50.0;

  var text_field_icon_color = UniversalVariables.gradientColorEnd;

  var text_field_color = UniversalVariables.greyColor;

  var firstName = TextEditingController.fromValue(TextEditingValue(text: ""));

  var lastName = TextEditingController.fromValue(TextEditingValue(text: ""));

  var number = TextEditingController.fromValue(TextEditingValue(text: ""));

  var email = TextEditingController.fromValue(TextEditingValue(text: ""));

  var address = TextEditingController.fromValue(TextEditingValue(text: ""));

  var company = TextEditingController.fromValue(TextEditingValue(text: ""));

  bool loading = false;

  Future<List<Contact>> contacts;

  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState

    // dbHelper = DatabaseHelper();
    // isUpdating = false;

    contact = widget.contact;

    if (contact.number[0] == '+') {
      contact.number = contact.number.substring(1);
      // contact.number = string[1];
    }

    firstName.text = contact.first_name;
    lastName.text = contact.last_name;
    number.text = contact.number;
    email.text = contact.email;
    address.text = contact.address;
    company.text = contact.company;

    refreshList();
  }

  refreshList() {
    setState(() {
      contacts = dbHelper.getContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Edit Contact",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: UniversalVariables.gradientColorEnd,
        actions: <Widget>[
          number.text.length == 11
              ? loading
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : IconButton(
                      // onPressed: ,
                      icon: Icon(Icons.check, color: Colors.white),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });

                        var response;
                        if (widget.update) {
                          response = await httpService.updateContact(contact);
                          if (response == 200) {
                            if (contact.number[0] != '+') {
                              contact.number = '+' + contact.number;
                            }
                            dbHelper.updateContact(contact);
                          }
                        } else {
                          response = await httpService.createContact(contact);
                          // if (response == 200) {
                          if (contact.number[0] != '+') {
                            contact.number = '+' + contact.number;
                          }
                          dbHelper.createContact(contact);
                          // }
                        }
                        if (response == 401) {
                          Fluttertoast.showToast(msg: "Session Expired");
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login_screen', (route) => false);
                          await sharedPreference.logout();
                        } else if (response == 200) {
                          Fluttertoast.showToast(msg: "Contact Saved");
                          Navigator.pop(context);
                        }
                        loading = false;
                        setState(() {});
                      })
              : IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Fluttertoast.showToast(msg: 'Invalid Phone Number');
                  })
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(45, 15, 45, 15),
          child: Container(
            child: Column(
              children: <Widget>[
                _firstName(),
                _lastName(),
                _number(),
                _email(),
                _address(),
                _company(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _firstName() {
    return customTextRow(
        icon: Icons.person,
        title: "First Name",
        onChnaged: (val) {
          contact.first_name = val;
        },
        controller: firstName);
  }

  Widget _lastName() {
    return customTextRow(
        icon: Icons.person,
        title: "Last Name",
        onChnaged: (val) {
          contact.last_name = val;
        },
        controller: lastName);
  }

  Widget _number() {
    return customTextRow(
        enabled: false,
        icon: Icons.phone,
        title: "Phone Number",
        onChnaged: (val) {
          number.text = contact.number;
        },
        controller: number,
        inputFormator: [WhitelistingTextInputFormatter(RegExp(r"[0-9]"))]);
  }

  Widget _email() {
    return customTextRow(
        icon: Icons.email,
        title: "Email",
        onChnaged: (val) {
          contact.email = val;
        },
        controller: email,
        inputFormator: [
          // WhitelistingTextInputFormatter(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
        ]);
  }

  Widget _address() {
    return customTextRow(
        icon: Icons.location_on,
        title: "Address",
        onChnaged: (val) {
          contact.address = val;
        },
        controller: address);
  }

  Widget _company() {
    return customTextRow(
        icon: Icons.business,
        title: "Company",
        onChnaged: (val) {
          contact.company = val;
        },
        controller: company);
  }
}
