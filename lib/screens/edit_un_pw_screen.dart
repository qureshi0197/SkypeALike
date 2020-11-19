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

class EditUsernamePassword extends StatefulWidget {
  
  @override
  _EditUsernamePasswordState createState() => _EditUsernamePasswordState();
}

class _EditUsernamePasswordState extends State<EditUsernamePassword> {
  Contact contact = Contact();

  var text_Field_height = 50.0;

  var text_field_icon_color = UniversalVariables.gradientColorEnd;

  var text_field_color = UniversalVariables.greyColor;

  var username = TextEditingController.fromValue(TextEditingValue(text: ""));

  var password = TextEditingController.fromValue(TextEditingValue(text: ""));

  var confirmPassword =
      TextEditingController.fromValue(TextEditingValue(text: ""));

  var number = TextEditingController.fromValue(TextEditingValue(text: ""));

  bool loading = false;

  // Future<List<Contact>> contacts;

  // DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState

    // dbHelper = DatabaseHelper();
    // isUpdating = false;

    // contact = widget.contact;

    // if (contact.number[0] == '+') {
    //   contact.number = contact.number.substring(1);
    //   // contact.number = string[1];
    // }

    username.text = user.name;
    password.text = user.password;
    number.text = user.number;
    // email.text = contact.email;
    // address.text = contact.address;
    // company.text = contact.company;

    refreshList();
  }

  refreshList() {
    setState(() {
      // contacts = dbHelper.getContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Edit Profile Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: UniversalVariables.gradientColorEnd,
        actions: <Widget>[
          loading
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

                    if (username != confirmPassword) {
                      Fluttertoast.showToast(msg: "Passwords Do Not Match");
                    } else {
                      // var response = await httpService.updateContact(contact);
                      // dbHelper.updateContact(contact);

                      // if (response == 401) {
                      //   Fluttertoast.showToast(msg: "Session Expired");
                      //   Navigator.pushNamedAndRemoveUntil(
                      //       context, '/login_screen', (route) => false);
                      //   await sharedPreference.logout();
                      // } else if (response == 200) {
                      //   Fluttertoast.showToast(msg: "Contact Saved");
                      //   Navigator.pop(context);
                      // }
                    }
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
                _username(),
                _number(),
                _password(),
                _confirmPassword(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _number() {
    return customTextRow(
      enabled: false,
      icon: Icons.phone,
      title: "Phone Number",
      onChnaged: (val) {
        // number.text = contact.number;
      },
      controller: number,
      // inputFormator: [WhitelistingTextInputFormatter(RegExp(r"[0-9]"))]
    );
  }

  Widget _username() {
    return customTextRow(
        icon: Icons.person,
        title: "User Name",
        onChnaged: (val) {
          username = val;
        },
        controller: username);
  }

  Widget _password() {
    return customTextRow(
        icon: Icons.lock_outline,
        title: "Password",
        onChnaged: (val) {
          password = val;
        },
        controller: password);
  }

  Widget _confirmPassword() {
    return customTextRow(
      // enabled: false,
      icon: Icons.lock_outline,
      title: "Confirm Password",
      onChnaged: (val) {
        confirmPassword = val;
      },
      controller: confirmPassword,
      hintText: "Rewrite password"
      // inputFormator: [WhitelistingTextInputFormatter(RegExp(r"[0-9]"))]
    );
  }
}
