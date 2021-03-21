import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/services/http_service.dart';
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

  bool loading = false;

  bool op_toggle = false;

  bool np_toggle = false;

  bool cp_toggle = false;

  int onPressed = 0;

  String old_Password = '';

  String new_Password = '';

  String confirm_Password = '';

  HttpService httpService = HttpService();

  Color _color = UniversalVariables.greyColor;

  Color cp_color = UniversalVariables.greyColor;

  Color np_color = UniversalVariables.greyColor;

  Color op_color = UniversalVariables.greyColor;

  @override
  void initState() {
    // TODO: implement initState

    refreshList();
  }

  refreshList() {
    setState(() {});
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
                  icon: Icon(Icons.check,
                      color: newPassword.text == confirmPassword.text
                          ? Colors.white
                          : UniversalVariables.greyColor),
                  onPressed: () async {
                    if (oldPassword.text == '' &&
                        newPassword.text == '' &&
                        confirmPassword.text == '') {
                      return Fluttertoast.showToast(msg: 'Fields are Empty');
                    }

                    if (newPassword.text.length < 6) {
                      return Fluttertoast.showToast(
                          msg: 'Password Should be atleast 6 Characters Long');
                    }

                    if (newPassword.text != confirmPassword.text) {
                      return Fluttertoast.showToast(
                          msg: 'Incorect Confirm Password');
                    }

                    if (oldPassword.text != user.password) {
                      return Fluttertoast.showToast(
                          msg: "Invalid Old Password");
                    }

                    setState(() {
                      loading = true;
                    });
                    var response = await httpService.changePassword(
                        newPassword.text, oldPassword.text);
                    loading = false;
                    setState(() {});

                    if (response == 401) {
                      Fluttertoast.showToast(msg: "Session Expired");
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login_screen', (route) => false);
                      await sharedPreference.logout();
                    } else if (response == 200) {
                      Fluttertoast.showToast(
                          msg: "Password Changed Sucessfully");
                      Navigator.pop(context);
                    } else if (response == 400) {
                      return Fluttertoast.showToast(
                          msg: 'Old Password Incorrect');
                    } else {
                      return Fluttertoast.showToast(msg: 'Server Error');
                    }
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

  Widget _iconButton(int textrow, Color color) {
    return IconButton(
        icon: Icon(Icons.remove_red_eye),
        color: color,
        onPressed: () {
          if (textrow == 1) {
            onPressed = 1;
            if (op_toggle == true) {
              op_toggle = false;
              op_color = UniversalVariables.greyColor;
            } else {
              op_toggle = true;
              op_color = UniversalVariables.gradientColorEnd;
            }
            print(textrow);
          } else if (textrow == 2) {
            onPressed = 2;
            if (np_toggle == true) {
              np_toggle = false;
              np_color = UniversalVariables.greyColor;
            } else {
              np_toggle = true;
              np_color = UniversalVariables.gradientColorEnd;
            }
            print(textrow);
          } else if (textrow == 3) {
            onPressed = 3;
            if (cp_toggle == true) {
              cp_toggle = false;
              cp_color = UniversalVariables.greyColor;
            } else {
              cp_toggle = true;
              cp_color = UniversalVariables.gradientColorEnd;
            }
            print(textrow);
          }
          setState(() {});
        });
  }

  Widget _oldPassword() {
    return customTextRow(
        obscureText: op_toggle ? false : true,
        suffixIcon: _iconButton(1, op_color),
        icon: Icons.lock_outline,
        title: "Old Password",
        onChnaged: (val) {
          setState(() {});
        },
        controller: oldPassword,
        hintText: "Current password");
  }

  Widget _newPassword() {
    return customTextRow(
        obscureText: np_toggle ? false : true,
        suffixIcon: _iconButton(2, np_color),
        icon: Icons.lock_outline,
        title: "New Password",
        onChnaged: (val) {
          setState(() {});
        },
        controller: newPassword,
        hintText: "New Password");
  }

  Widget _confirmPassword() {
    return customTextRow(
        obscureText: cp_toggle ? false : true,
        suffixIcon: _iconButton(3, cp_color),
        icon: Icons.lock_outline,
        title: "Confirm Password",
        onChnaged: (val) {
          setState(() {});
        },
        controller: confirmPassword,
        hintText: "Rewrite password");
  }
}
