import 'package:flutter/material.dart';
import 'package:skypealike/utils/universal_variables.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{

  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  const CustomAppBar({
    Key key,
    @required this.title,
    @required this.actions,
    @required this.leading,
    @required this.centerTitle,

  }): super(key : key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: UniversalVariables.lightGreyColor,
            width: 1.0,
            style: BorderStyle.solid,
          )) 
        ),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title,
      ),     
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight+10);
}