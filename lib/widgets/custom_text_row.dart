import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skypealike/constants/styles.dart';
import 'package:skypealike/utils/universal_variables.dart';

Widget customTextRow(
    {@required IconData icon,
    @required String title,
    @required Function onChnaged,
    @required controller,
    List<TextInputFormatter> inputFormator,
    int maxLength,
    String hintText,
    }) {
      // if(maxLength)
  var text_field_icon_color = UniversalVariables.gradientColorEnd;
  var text_field_padding = const EdgeInsets.only(bottom: 15.0);
  var text_Field_height = 50.0;
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
          height: text_Field_height,
          child: TextField(
            inputFormatters: inputFormator,
            controller: controller,
            onChanged: onChnaged,
            style: eTextStyle,
            maxLength: maxLength,
            decoration: InputDecoration(
              // errorText: response == 102 ? userNotFonund:null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                icon,
                color: text_field_icon_color,
              ),
              hintText: hintText,
              hintStyle: eHintTextStyle,
            ),
          ),
        ),
      ],
    ),
  );
}
