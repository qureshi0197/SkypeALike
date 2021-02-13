import 'package:flutter/material.dart';
import 'package:skypealike/utils/universal_variables.dart';

Widget CustomFloatingActionButton(
    {@required IconData icon, @required Function onPressed}) {
  return FloatingActionButton(
    onPressed: onPressed,
    child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            gradient: UniversalVariables.fabGradient, shape: BoxShape.circle),
        child: Icon(
          icon,
          color: Colors.white,
        )),
  );
}
