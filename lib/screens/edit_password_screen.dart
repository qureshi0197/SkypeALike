import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/widgets/custom_text_row.dart';

import '../main.dart';

class EditPassword extends StatefulWidget {
  
  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  Contact contact = Contact();

  var text_Field_height = 50.0;

  var text_field_icon_color = UniversalVariables.gradientColorEnd;

  var text_field_color = UniversalVariables.greyColor;

  var oldPassword = TextEditingController.fromValue(TextEditingValue(text: ""));

  var newPassword = TextEditingController.fromValue(TextEditingValue(text: ""));

  var confirmPassword =
      TextEditingController.fromValue(TextEditingValue(text: ""));

  // var number = TextEditingController.fromValue(TextEditingValue(text: ""));

  bool loading = false;

  bool op_toggle = false;

  bool np_toggle = false;

  bool cp_toggle = false;

  int onPressed = 0;
  
  String old_Password = '';

  String new_Password = '';

  String confirm_Password = '';

  Color _color = UniversalVariables.greyColor;
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

    // username.text = user.name;
    // password.text = user.password;
    // number.text = user.number;
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

                    if (oldPassword.text != user.password) {
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
                _oldPassword(),
                _newPassword(),
                _confirmPassword(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconButton(int textrow){
    return IconButton(
        icon: Icon(Icons.remove_red_eye),
        // Fix icon color issue onPressed should be separate for all
        color: _color, 
        onPressed: () {
          if(textrow == 1)
          {
            onPressed = 1;
            if(op_toggle == true){
              op_toggle = false;
              _color = UniversalVariables.greyColor;
            }
            else{
              op_toggle = true;
              _color = UniversalVariables.gradientColorEnd;
            }
            print(textrow);
          }
          else if(textrow == 2)
          {
            onPressed = 2;
            if(np_toggle == true){
              np_toggle = false;
              _color = UniversalVariables.greyColor;
            }
            else{
              np_toggle = true;
              _color = UniversalVariables.gradientColorEnd;
            }
            print(textrow);
          }
          else if(textrow == 3)
          {
            onPressed = 3;
            if(cp_toggle == true){
              cp_toggle = false;
              _color = UniversalVariables.greyColor;
            }
            else{
              cp_toggle = true;
              _color = UniversalVariables.gradientColorEnd;
            }
            print(textrow);
          }
          setState(() {
          });
      }
    );
  }

  Widget _oldPassword() {
    return customTextRow(
        obscureText: op_toggle ? false : true,
        suffixIcon: _iconButton(1),
        icon: Icons.lock_outline,
        title: "Old Password",
        onChnaged: (val) {
          old_Password = val;
        },
        controller: oldPassword,
        hintText: "Current password"
        );
  }

  Widget _newPassword() {
    return customTextRow(
      obscureText: np_toggle ? false : true,
      suffixIcon: _iconButton(2),
        icon: Icons.lock_outline,
        title: "New Password",
        onChnaged: (val) {
          new_Password = val;
        },
        controller: newPassword,
        hintText: "New Password"
        );
  }

  Widget _confirmPassword() {
    return customTextRow(
      obscureText: cp_toggle ? false : true,
      suffixIcon: _iconButton(3),
      icon: Icons.lock_outline,
      title: "Confirm Password",
      onChnaged: (val) {
        confirm_Password = val;
      },
      controller: confirmPassword,
      hintText: "Rewrite password"
    );
  }
}
