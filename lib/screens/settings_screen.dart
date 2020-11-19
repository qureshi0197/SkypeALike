import 'package:flutter/material.dart';
import 'package:skypealike/screens/chat_screen.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/widgets/custom_text_row.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var text_Field_height = 50.0;

  var genericMessage =
      TextEditingController.fromValue(TextEditingValue(text: ""));

  @override
  void initState() {
    // TODO: implement initState

    genericMessage.text = UniversalVariables.generalMessage;

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
                    child: FlatButton(
                        onPressed: () => ChatScreen(),
                        color: UniversalVariables.gradientColorEnd,
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        )))
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
        genericMessage.text = val;
      },
      controller: genericMessage,
      hintText: "Enter a general message"
      // inputFormator: [WhitelistingTextInputFormatter(RegExp(r"[0-9]"))]
    );
  }
}
