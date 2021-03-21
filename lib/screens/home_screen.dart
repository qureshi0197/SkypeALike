import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skypealike/page_views/widgets/user_details_container.dart';
import 'package:skypealike/screens/chat_list_screen.dart';
import 'package:skypealike/screens/search_screen.dart';
import 'package:skypealike/screens/settings_screen.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:intl/intl.dart';
import 'package:skypealike/screens/contact_list_screen.dart';
import '../services/http_service.dart';
import '../utils/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  PageController pageController = PageController(initialPage: 0);
  SharedPreference sharedPreference = SharedPreference();
  var inbox;
  HttpService httpService = HttpService();
  var loading = true;
  var usersInbox = [];

  _convertTimeToTimeStamp(time) {
    final formatter = DateFormat(r'''EEE, dd MMM yyyy hh:mm:ss''');
    var val = (formatter.parse(time, true));
    val = (val.toLocal());
    return val.millisecondsSinceEpoch;
  }

  @override
  void initState() {}

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
        title: Image.asset(
          'assets/images/icon.png',
          height: 50,
          width: 50,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: UniversalVariables.gradientColorEnd,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchScreen(
                            chatList: UniversalVariables.chatList,
                          )));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: UniversalVariables.gradientColorEnd,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserDetailsContainer(true)));
            },
          ),
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
                icon: Icon(Icons.spa,
                    color: (_page == 2)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor),
                title: Text(
                  "Welcome Message",
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
