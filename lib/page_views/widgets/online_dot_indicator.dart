import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skypealike/enum/user_state.dart';
import 'package:skypealike/models/user.dart';
import 'package:skypealike/resources/auth_methods.dart';
import 'package:skypealike/utils/utilities.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods _authMethods = AuthMethods();

  OnlineDotIndicator({
    @required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return Align(
      alignment: Alignment.topRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: _authMethods.getUserStream(
          uid: uid,
        ),
        builder: (context, snapshot) {
          User user;

          if (snapshot.hasData && snapshot.data.data != null) {
            user = User.fromMap(snapshot.data.data);
          }else {
            user.state = UserState.Online.index;
          }

          return Align(
              alignment: Alignment.bottomRight,
              child: Container(
              height: 10,
              width: 10,
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getColor(user?.state),
              ),
            ),
          );
        },
      ),
    );
  }
}