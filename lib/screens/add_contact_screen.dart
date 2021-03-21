import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skypealike/constants/strings.dart';
import 'package:skypealike/db/database_helper.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/widgets/custom_text_row.dart';

import '../main.dart';

class AddContect extends StatefulWidget {
  @override
  _AddContectState createState() => _AddContectState();
}

class _AddContectState extends State<AddContect> {
  bool loading = false;

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

  var companyHintText = "Company Name";

  var addressHintText = "Address";

  var emailHintText = "Email Address";

  var numberHintText = "Phone Number";

  var lastNameHintText = "Last Name";

  var firstNameHintText = "First Name";

  DatabaseHelper dbHelper = DatabaseHelper();

  bool isUpdating;

  Future<List<Contact>> contacts;

  @override
  void initState() {
    super.initState();
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
          "Add New Contact",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: UniversalVariables.gradientColorEnd,
        actions: <Widget>[
          loading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.check, color: Colors.white),
                  onPressed: () async {
                    if (contact.number == null) {
                      return Fluttertoast.showToast(
                          msg: "Number Field is Empty");
                    }

                    if (contact.number.length < 11) {
                      return Fluttertoast.showToast(
                          msg: "Invalid Number Format");
                    }

                    if (contact.first_name == null &&
                        contact.last_name == null) {
                      return Fluttertoast.showToast(msg: "Name Required");
                    }

                    Contact tempContect = Contact();

                    setState(() {
                      loading = true;
                    });

                    tempContect = contact;
                    if (contact.number[0] != '+') {
                      tempContect.number = '+' + contact.number;
                    }

                    await dbHelper.createContact(tempContect);

                    var response = await httpService.createContact(contact);

                    if (response == 401) {
                      Fluttertoast.showToast(msg: "Session Expired");
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login_screen', (route) => false);
                      await sharedPreference.logout();
                    }

                    Fluttertoast.showToast(msg: "Contact Saved");
                    Navigator.pop(context);

                    loading = false;
                    setState(() {});
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
        hintText: firstNameHintText,
        icon: Icons.person,
        title: "First Name",
        onChnaged: (val) {
          contact.first_name = val;
        },
        controller: firstName);
  }

  Widget _lastName() {
    return customTextRow(
        hintText: lastNameHintText,
        icon: Icons.person,
        title: "Last Name",
        onChnaged: (val) {
          contact.last_name = val;
        },
        controller: lastName);
  }

  Widget _number() {
    return customTextRow(
        prefixText: "+",
        keyboardType: TextInputType.number,
        hintText: numberHintText,
        icon: Icons.phone,
        title: "Phone Number",
        onChnaged: (val) {
          contact.number = val;
          setState(() {});
        },
        controller: number,
        inputFormator: [WhitelistingTextInputFormatter(RegExp(r"^\d{0,14}"))]);
  }

  Widget _email() {
    return customTextRow(
        keyboardType: TextInputType.emailAddress,
        hintText: emailHintText,
        icon: Icons.email,
        title: "Email",
        onChnaged: (val) {
          contact.email = val;
        },
        controller: email,
        inputFormator: []);
  }

  Widget _address() {
    return customTextRow(
        hintText: addressHintText,
        icon: Icons.location_on,
        title: "Address",
        onChnaged: (val) {
          contact.address = val;
        },
        controller: address);
  }

  Widget _company() {
    return customTextRow(
        hintText: companyHintText,
        icon: Icons.business,
        title: "Company",
        onChnaged: (val) {
          contact.company = val;
        },
        controller: company);
  }
}
