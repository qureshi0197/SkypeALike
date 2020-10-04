import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:skypealike/page_views/chat_list_screen.dart';
import 'package:skypealike/provider/user_provider.dart';
// import 'package:skypealike/resources/auth_methods.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../services/http_service.dart';
import '../services/http_service.dart';
import '../utils/shared_preferences.dart';
import '../utils/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  PageController pageController = PageController(initialPage: 0);
  SharedPreference sharedPreference = SharedPreference();
  // final AuthMethods _authMethods = AuthMethods();
  UserProvider userProvider;
  var inbox;
  HttpService httpService = HttpService();
  var loading = true;

  _convertTimeToTimeStamp(time) {
    // int timestamp;
    // time = "Thu, 24 Sep 2020 05:51:09 GMT";
    final formatter = DateFormat(r'''EEE, dd MMM yyyy hh:mm:ss''');
    // print(DateTime.);
    var val = (formatter.parse(time, true));
    print(val);
    val = (val.toLocal());
    return val.millisecondsSinceEpoch;
  }

  _arrangeAllMessagesForInbox() {
    var otherUserData = {};
    var otherUserKeys = [];
    if (inbox.containsKey('data')) {
      for (var map in inbox['data']) {
        if (map['direction'] == "outbound") {
          if (!otherUserKeys.contains(map["receiver"])) {
            otherUserKeys.add(map["receiver"]);
          }
          if (otherUserData.containsKey(map["receiver"])) {
            otherUserData[map["receiver"]].add(map);
          } else {
            otherUserData[map["receiver"]] = [];
          }
        } else {
          if (!otherUserKeys.contains(map["receiver"])) {
            otherUserKeys.add(map["receiver"]);
          }
          if (otherUserData.containsKey(map["sender"])) {
            otherUserData[map["sender"]].add(map);
          } else {
            otherUserData[map["sender"]] = [];
          }
        }
      }
      otherUserData.forEach((key, value) {
        print(otherUserData[key]);
        otherUserData = otherUserData[key].sort((a, b) =>
            _convertTimeToTimeStamp(a['timestamp'])
                .compareTo(_convertTimeToTimeStamp(b['timestamp'])));
        print(otherUserData[key]);
      });
      // print(object)
    } else {
      inbox = [];
    }
    return inbox;
  }

  getAllMessages() async {
    inbox = await httpService.getAllMessages(null);
    if (inbox == null) {
      Fluttertoast.showToast(msg: 'Problem while fetching data from server');
      return;
    } else if (inbox == 401) {
      Fluttertoast.showToast(msg: 'Session Expired. PLease Login again');
      Navigator.pushNamedAndRemoveUntil(
          context, '/login_screen', (route) => false);
      await sharedPreference.logout();
      return;
    } else {
      inbox = _arrangeAllMessagesForInbox();
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (loading) {
      inbox = 'loading';
    }
    // _convertTimeToTimeStamp(null);
    getAllMessages();
  }

  @override
  void dispose() {
    super.dispose();
    // WidgetsBinding.instance.removeObserver(this);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   String currentUserId =
  //       (userProvider != null && userProvider.getUser != null)
  //           ? userProvider.getUser.uid
  //           : "";

  //   super.didChangeAppLifecycleState(state);

  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       currentUserId != null
  //           ? _authMethods.setUserState(
  //               userId: currentUserId, userState: UserState.Online)
  //           : print("resume state");
  //       break;
  //     case AppLifecycleState.inactive:
  //       currentUserId != null
  //           ? _authMethods.setUserState(
  //               userId: currentUserId, userState: UserState.Offline)
  //           : print("inactive state");
  //       break;
  //     case AppLifecycleState.paused:
  //       currentUserId != null
  //           ? _authMethods.setUserState(
  //               userId: currentUserId, userState: UserState.Waiting)
  //           : print("paused state");
  //       break;
  //     case AppLifecycleState.detached:
  //       currentUserId != null
  //           ? _authMethods.setUserState(
  //               userId: currentUserId, userState: UserState.Offline)
  //           : print("detached state");
  //       break;
  //   }
  // }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    // _convertTimeToTimeStamp(null);
    double _labelFontSize = 10;

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        children: [
          Container(
              child:
                  //  inbox == null
                  //     ? Center(child: Text('Retry'))
                  // :
                  ChatListScreen(inbox)),
          // Center(child: Text("Call Logs", style: TextStyle(color: UniversalVariables.greyColor),)),
          Center(
              child: Text(
            "Contact Screen",
            style: TextStyle(color: UniversalVariables.greyColor),
          )),
          // Call Contact List Screen Here.
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        // physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CupertinoTabBar(
            backgroundColor: Colors.white,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.chat,
                    color: (_page == 0)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor),
                title: Text(
                  "Chats",
                  style: TextStyle(
                      fontSize: _labelFontSize,
                      color: (_page == 0)
                          ? UniversalVariables.lightBlueColor
                          : Colors.grey),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contacts,
                    color: (_page == 1)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor),
                title: Text(
                  "Contacts",
                  style: TextStyle(
                      fontSize: _labelFontSize,
                      color: (_page == 2)
                          ? UniversalVariables.lightBlueColor
                          : Colors.grey),
                ),
              ),
            ],
            onTap: navigationTapped,
            currentIndex: _page,
          ),
        ),
      ),
    );
  }
}
