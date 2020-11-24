import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skypealike/constants/styles.dart';
import 'package:skypealike/utils/universal_variables.dart';

Widget customTextRow({
  @required IconData icon,
  @required String title,
  @required Function onChnaged,
  @required controller,
  List<TextInputFormatter> inputFormator,
  int maxLength,
  String hintText,
  bool obscureText,
  IconButton suffixIcon,
  bool enabled,
  bool generalMessage,
  int maxLines
}) {
  // if(maxLength)
  if(obscureText == null){
    obscureText = false;
  }
  if (enabled == null) {
    enabled = true;
  }
  if (generalMessage == null){
    generalMessage = false;
    maxLines = 1;
  }
  var text_field_icon_color = UniversalVariables.gradientColorEnd;
  var text_field_padding = const EdgeInsets.only(bottom: 15.0);
  var text_Field_height = 50.0;
  var message_field_height = maxLines * 20.0;
  return Padding(
    padding: text_field_padding,
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              title,
              style: eLabelStyle,
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: eBoxDecorationStyle,
          height: generalMessage ? message_field_height : text_Field_height,
          // height: text_Field_height,
          child: TextField(
            obscureText: obscureText,
            maxLines: maxLines,
            enabled: enabled,
            inputFormatters: inputFormator,
            controller: controller,
            onChanged: onChnaged,
            style: enabled ? eTextStyle : dTextStyle,
            maxLength: maxLength,
            decoration: InputDecoration(
              // errorText: response == 102 ? userNotFonund:null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                icon,
                color: text_field_icon_color,
              ),
              suffixIcon: suffixIcon,
              // Icon(
              //   suffixIcon,
              //   color: text_field_icon_color,
              //   ),
              hintText: hintText,
              hintStyle: eHintTextStyle,
            ),
          ),
        ),
      ],
    ),
  );
}
