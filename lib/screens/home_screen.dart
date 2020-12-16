import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skypealike/page_views/widgets/user_circle.dart';
import 'package:skypealike/page_views/widgets/user_details_container.dart';
import 'package:skypealike/screens/chat_list_screen.dart';
import 'package:skypealike/provider/user_provider.dart';
import 'package:skypealike/screens/search_screen.dart';
import 'package:skypealike/screens/settings_screen.dart';
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
  // UserProvider userProvider;
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
    // print(val);
    val = (val.toLocal());
    return val.millisecondsSinceEpoch;
  }

  // getAllMessages() async {
  //   inbox = await httpService.getAllMessages(null);
  //   if (inbox == null) {
  //     Fluttertoast.showToast(msg: 'Problem while fetching data from server');
  //     return;
  //   } else if (inbox == 401) {
  //     Fluttertoast.showToast(msg: 'Session Expired. PLease Login again');
  //     Navigator.pushNamedAndRemoveUntil(
  //         context, '/login_screen', (route) => false);
  //     await sharedPreference.logout();
  //     return;
  //   } else {
  //     // _arrangeAllMessagesForInbox();
  //   }

  // }

  @override
  void initState() {
    // TODO: implement initState
    // super.initState();
    // if (loading) {
    //   inbox = 'loading';
    // }
    // getAllMessages();
  }

  @override
  void dispose() {
    super.dispose();
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
    double _labelFontSize = 10;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(),
        title: Text(user.name, style: TextStyle(color: UniversalVariables.gradientColorEnd),),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: UniversalVariables.gradientColorEnd,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen(chatList: UniversalVariables.chatList,)));
              // Navigator.push(context, PageRouteBuilder(
              //   transitionDuration: Duration(seconds: 0),
              //   pageBuilder: (context,animation1,animation2)=>SearchScreen()));
              // Navigator.pushNamed(context, "/search_screen");
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: UniversalVariables.gradientColorEnd,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>UserDetailsContainer(true)));
              // Navigator.push(context, PageRouteBuilder(
              //   transitionDuration: Duration(seconds: 0),
              //   pageBuilder: (context,animation1,animation2)=>SearchScreen()));
              // Navigator.pushNamed(context, "/search_screen");
            },
          ),
          // PopUpMenu(),
        ],
      ),
      backgroundColor: Colors.white,
      body: PageView(
        children: [
          ChatListScreen(),
          Container(child: ContactListScreen()),
          SettingsScreen(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        // physics: UniversalVariables.onLongPress
        //     ? NeverScrollableScrollPhysics()
        //     : null,
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
                      color: (_page == 1)
                          ? UniversalVariables.lightBlueColor
                          : Colors.grey),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings,
                    color: (_page == 2)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor),
                title: Text(
                  "Settings",
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
