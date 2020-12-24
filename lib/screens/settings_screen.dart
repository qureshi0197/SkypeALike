import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:skypealike/constants/strings.dart';
import 'package:skypealike/main.dart';
import 'package:skypealike/screens/chat_screen.dart';
import 'package:skypealike/utils/shared_preferences.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/widgets/custom_text_row.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var text_Field_height = 50.0;
  
  FocusNode textFieldFocus = FocusNode();

  var welcomeMessage = '';
  
  var genericMessage =
      TextEditingController.fromValue(TextEditingValue(text: ""));
  
  bool loading = false;

  bool welcome = false;
  

  SharedPreference sharedPreference = SharedPreference();
  
  
  getMessage() async {
    genericMessage.text = await sharedPreference.getWelcomeMessage();
    print(genericMessage.text);
    // welcomeMessage = genericMessage.text;

    setState(() {
      welcome = false;
    });
  }
  
  @override
  void initState() {
    loading = false;
    welcome = true;
    
    // sharedPreference.getWelcomeMessage().then((onValue){
    //   genericMessage.text = onValue;
    //   welcomeMessage = onValue;
      if(welcomeMessage == ''){
        if(user.welcome_message.isNotEmpty || user.welcome_message != null){
          welcomeMessage = user.welcome_message;
          sharedPreference.saveWelcomeMessage(welcomeMessage);
        }
      }
      getMessage();
      // setState(() {
      // });
    // });
  }
  @override
  Widget build(BuildContext context) => KeyboardDismisser (
    child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(45, 15, 45, 15),
          child: Container(
            child: Column(
              children: <Widget>[
                _genericMessage(),

                Container(
                  // decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    alignment: Alignment.centerRight,
                    child: loading?CircularProgressIndicator(): FlatButton(
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: ()async{

                          FocusScope.of(context).unfocus();
                          
                          welcomeMessage = await sharedPreference.getWelcomeMessage();
                          if(genericMessage.text == welcomeMessage){
                            return Fluttertoast.showToast(msg: 'No changes to update');
                          }

                          if(genericMessage.text == ''){
                            return Fluttertoast.showToast(msg: 'Empty Field. Please Enter Some Message');
                          }
                          // focusNode.unfocus();
                          // print('unfocused');
                          setState(() {
                            loading = true;
                          });

                          
                          bool response = await httpService.welcomeMessage(genericMessage.text);
                          
                          if(response)
                          {
                            welcomeMessage = genericMessage.text;
                            // await sharedPreference.saveWelcomeMessage(genericMessage.text);
                            // genericMessage.clear();
                            Fluttertoast.showToast(msg: 'Message Updated Successfully');
                          }

                          setState(() {
                            // DefaultFocusTraversal.of(context).previous()
                            
                            loading = false;
                          });
                        },
                        color: UniversalVariables.gradientColorEnd,
                        child: Text(
                          "UPDATE",
                          style: TextStyle(color: Colors.white),
                        ))),
              ],
            ),
          ),
          
        ),
      ),
    ),
  );

  Widget _genericMessage() {
    return customTextRow(
      // enabled: false,
      icon: Icons.textsms,
      maxLines: 5,
      generalMessage: true,
      title: "Welcome Message",
      onChnaged: (val) {
        // UniversalVariables.generalMessage = val;
      },
      controller: genericMessage,
      // hintText: 'Enter Welcome Message'
      // inputFormator: [WhitelistingTextInputFormatter(RegExp(r"[0-9]"))]
    );
  }
}
