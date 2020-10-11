import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:skypealike/screens/chat_list_screen.dart';
import 'package:skypealike/provider/user_provider.dart';
// import 'package:skypealike/resources/auth_methods.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:intl/intl.dart';
import 'package:skypealike/screens/contact_list_screen.dart';
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
  var usersInbox = [];

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
    usersInbox = [];
    if (inbox.containsKey('data')) {
      Map val = inbox['data'];
      // contact
      val.forEach((key,value)
      {
        if (val[key]['direction'] == "outbound") {
          if(!otherUserKeys.contains(val[key]["receiver"]))
            otherUserKeys.add(val[key]["receiver"]);
      //     if (!otherUserKeys.contains(val[key]["receiver"])) {
      //       otherUserKeys.add(val[key]["receiver"]);
          otherUserData[val[key]["receiver"]] = val[key];
          // usersInbox.append();
          }
          
      //     if(otherUserData.isEmpty){
      //       otherUserData[val[key]["receiver"]] = [];
      //     }
      //     if(otherUserData.containsKey(val[key]["receiver"])){
      //       otherUserData[val[key]["receiver"]].add(val[key]);
      //     }
      //     else if (otherUserData.containsKey(val[key]["receiver"])) {
      //       otherUserData[val[key]["receiver"]].add(val[key]);
      //     } 
      //     else {
      //       otherUserData[val[key]["receiver"]] = [];
      //     }
      //   } else {
          // if (!otherUserKeys.contains(val[key]["sender"])) 
          else{
            if(!otherUserKeys.contains(val[key]["sender"]))
              otherUserKeys.add(value);
              // otherUserData[val[key]["receiver"]] = val[key];
      //       otherUserKeys.add(val[key]["receiver"]);
            otherUserData[val[key]["sender"]] = val[key];
          }
          
      //     if(otherUserData.isEmpty){
      //       otherUserData[val[key]["receiver"]] = [];
      //     }
      //     if(otherUserData.containsKey(val[key]["receiver"])){
      //       // otherUserData[val[key]["receiver"]] = [];
      //       otherUserData[val[key]["receiver"]].add(val[key]);
      //     }
      //     else if (otherUserData.containsKey(val[key]["sender"])) {
      //       otherUserData[val[key]["sender"]].add(val[key]);
      //     } 
      //     else {
      //       otherUserData[val["sender"]] = [];
      //     }
      //   }
      });
      print(otherUserData);

      otherUserData.forEach((key, value) {
        usersInbox.add(
          {
            "number":key,
            "message":value
          }
        );
      // for()
      //   // print(otherUserData[key]);
      //   // print(
      //     otherUserData[key].sort((a, b){
      //       var aVal = (_convertTimeToTimeStamp(a['timestamp']));
      //       var bVal = (_convertTimeToTimeStamp(b['timestamp']));
            
      //      return aVal.compareTo(bVal);
      //       }
      //       );
      //       // );
      //   // print(otherUserData[key]);
      });
      print(usersInbox);
    } else {
      inbox = [];
    }
    return [];
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
      _arrangeAllMessagesForInbox();
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
  getAllMessages();
  }

  @override
  void dispose() {
    super.dispose();
    // WidgetsBinding.instance.removeObserver(this);
  }

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
    // _arrangeAllMessagesForInbox();
    // _convertTimeToTimeStamp(null);
    double _labelFontSize = 10;

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        children: [
          loading ? Center(child: CircularProgressIndicator(),):Container(
              child: 
              // Text('data')),
                   usersInbox.isEmpty
                      ? Center(child: Text('No Messages'))
                  :
                  ChatListScreen(usersInbox)),
          Container(
              child: ContactListScreen()),
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
