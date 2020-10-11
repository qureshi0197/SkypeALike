
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/widgets/custom_text_row.dart';

class AddContect extends StatefulWidget {
  // Contact contact;
  // AddContect(this.contact);

  @override
  _AddContectState createState() => _AddContectState();
}

class _AddContectState extends State<AddContect> {

  // Contact contact;

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

  @override
  void initState() {
    // // TODO: implement initState
    // contact = widget.contact;
    // if(contact.number[0] == '+'){
    //   contact.number = contact.number.substring(1);
    //   // contact.number = string[1];
    // }
    // firstName.text = contact.first_name;
    // lastName.text = contact.last_name;
    // number.text = contact.number;
    // email.text = contact.email;
    // address.text = contact.address;
    // company.text = contact.company;
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
          number.text.length == 11 ? 
          IconButton(icon: Icon(Icons.check, color: Colors.white,), onPressed: null)
          :
          IconButton(icon: Icon(Icons.check, color: Colors.grey,), onPressed: (){
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
    return customTextRow(hintText: firstNameHintText, icon: Icons.person, title: "First Name", onChnaged: (val){setState(() {});}, controller: firstName);
  }

  Widget _lastName() {
    return customTextRow(hintText: lastNameHintText, icon: Icons.person, title: "Last Name", onChnaged: (val){setState(() {});}, controller: lastName);
  }

  Widget _number() {
    return customTextRow(hintText: numberHintText, icon: Icons.phone, title: "Phone Number", onChnaged: (val){setState(() {});}, controller: number,inputFormator: [
      WhitelistingTextInputFormatter(RegExp(r"[0-9]"))
      
    ]);
  }

  Widget _email() {
    return customTextRow(hintText: emailHintText, icon: Icons.email, title: "Email", onChnaged: (val){setState(() {});}, controller: email,inputFormator: [
      // WhitelistingTextInputFormatter(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
    ]);
  }

  Widget _address() {
    return customTextRow(hintText: addressHintText, icon: Icons.location_on, title: "Address", onChnaged: (val){setState(() {});}, controller: address);
  }

  Widget _company() {
    return customTextRow(hintText: companyHintText, icon: Icons.business, title: "Company", onChnaged: (val){setState(() {});}, controller: company);
  }
}
