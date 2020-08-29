import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skypealike/models/message.dart';
import 'package:skypealike/utils/universal_variables.dart';

class LastMessageContainer extends StatelessWidget {
  
  final stream;

  LastMessageContainer({
    @required this.stream
  });


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasData){
          var docList = snapshot.data.documents;

          if(docList.isNotEmpty){
            Message message = Message.fromMap(docList.last.data);
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Text(
                message.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: UniversalVariables.greyColor,
                  fontSize: 14
                ),
              ),
            );
          }
          return Text(
            "No Messages",
            style: TextStyle(
              color: UniversalVariables.lightGreyColor,
              fontSize: 14
                
            ),
          );
        }
        return Text(
          "..",
          style: TextStyle(
            color: UniversalVariables.lightGreyColor,
            fontSize: 14
            ),
        );
      },
    );
  }
}