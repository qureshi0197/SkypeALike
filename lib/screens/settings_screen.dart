import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  var welcomeMessage = '';
  var genericMessage =
      TextEditingController.fromValue(TextEditingValue(text: ""));
  bool loading = false;
  SharedPreference sharedPreference = SharedPreference();
  @override
  void initState() {
    loading = false;
    // TODO: implement initState

    genericMessage.text = UniversalVariables.generalMessage;
    // if(genericMessage.text == ''){
    //   genericMessage.text = user.welcome_message;
    // }
    sharedPreference.getWelcomeMessage().then((onValue){
      welcomeMessage = onValue;
      if(welcomeMessage == ''){
        if(user.welcome_message.isNotEmpty || user.welcome_message != null){
          welcomeMessage = user.welcome_message;
          sharedPreference.saveWelcomeMessage(welcomeMessage);
        }
      }
      setState(() {
      });
    });
    _refreshSettings();
  }

  _refreshSettings() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(45, 15, 45, 15),
          child: Container(
            child: Column(
              children: <Widget>[
                _genericMessage(),

                Container(
                    alignment: Alignment.centerRight,
                    child: loading?CircularProgressIndicator(): FlatButton(
                        onPressed: ()async{
                          setState(() {
                            loading = true;
                          });

                          
                          bool response = await httpService.welcomeMessage(genericMessage.text);
                          
                          if(response)
                          {
                            welcomeMessage = await sharedPreference.getWelcomeMessage();
                            genericMessage.clear();
                            Fluttertoast.showToast(msg: 'Message Saved Successfuly');
                          }

                          setState(() {
                            loading = false;
                          });
                        },
                        color: UniversalVariables.gradientColorEnd,
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ))),
                        SizedBox(height: 30,),
                         welcomeMessage.isEmpty?Container(): Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black12,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                  children: <Widget>[
                  Expanded(child: 
                    Text(welcomeMessage))
                    // Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'))
                  ],
                ),
                          ),
                        ),
              ],
            ),
          ),
          
        ),
      ),
    );
  }

  Widget _genericMessage() {
    return customTextRow(
      // enabled: false,
      icon: Icons.textsms,
      maxLines: 5,
      generalMessage: true,
      title: "General Message",
      onChnaged: (val) {
        // UniversalVariables.generalMessage = val;
      },
      controller: genericMessage,
      hintText: "Enter a general message"
      // inputFormator: [WhitelistingTextInputFormatter(RegExp(r"[0-9]"))]
    );
  }
}
