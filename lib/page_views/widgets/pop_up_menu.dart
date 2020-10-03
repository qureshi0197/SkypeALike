import 'package:flutter/material.dart';
import 'package:skypealike/enum/pop_up_menu_list.dart';
import 'package:skypealike/utils/universal_variables.dart';

class PopUpMenu extends StatelessWidget {
  
  // PopUpMenuList _popUpMenuList;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PopupMenuButton<PopUpMenuList>(
        color: Colors.white,
        // onSelected: choice,
        icon: Icon(
          Icons.more_vert,
          color: Colors.grey,
          ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<PopUpMenuList>>[
          const PopupMenuItem<PopUpMenuList>(
            value: PopUpMenuList.Option1,
            child: Text('Option 1', style: TextStyle(color: Colors.black),),
          ),
          
          const PopupMenuItem<PopUpMenuList>(
            value: PopUpMenuList.Option1,
            child: Text('Option 2', style: TextStyle(color: Colors.black),),
          ),
          
          const PopupMenuItem<PopUpMenuList>(
            value: PopUpMenuList.Option1,
            child: Text('Option 3', style: TextStyle(color: Colors.black),),
          ),
        ]
      ),
    );
  }
}