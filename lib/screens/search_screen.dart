import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:skypealike/db/database_helper.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/screens/chat_screen.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/widgets/custom_tile.dart';

class SearchScreen extends StatefulWidget {
  List chatList;
  SearchScreen({List chatList}) {
    if (chatList == null) {
      this.chatList = [];
      return;
    }
    this.chatList = chatList;
  }
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  String query = "";
  TextEditingController searchController = TextEditingController();

  var loading = true;
  List<Contact> allContects = [];
  getAllContacts() async {
    var response = await databaseHelper.getContacts();
    allContects = response;
    if (widget.chatList.isNotEmpty) {
      for (var contact in widget.chatList) {
        if (!allContects.contains(contact)) {
          allContects.add(contact);
        }
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllContacts();
  }

  searchAppBar(BuildContext context) {
    return NewGradientAppBar(
      gradient: LinearGradient(colors: [
        UniversalVariables.gradientColorStart,
        UniversalVariables.gradientColorEnd
      ]),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: Colors.white,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());

                  setState(() {
                    query = '';
                  });
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    if (loading) return Center(child: CircularProgressIndicator());

    final List<Contact> suggestionList = query.isEmpty
        ? []
        : allContects.where((Contact contact) {
            String _getUsername = contact.first_name.toLowerCase() +
                " " +
                contact.last_name.toLowerCase();
            String _query = query.toLowerCase();
            String _getNumber = contact.number.toLowerCase();
            bool matchesUsername = _getUsername.contains(_query);
            bool matchesNumber = _getNumber.contains(_query);

            return (matchesUsername || matchesNumber);
          }).toList();

    if (suggestionList.isEmpty) {
      return Center(
        child: Text('No Contacts Found'),
      );
    } else
      return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: ((context, index) {
          Contact contactUser = Contact(
              first_name: suggestionList[index].first_name,
              last_name: suggestionList[index].last_name,
              number: suggestionList[index].number);
          return CustomTile(
            mini: false,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            receiver: contactUser,
                          )));
            },
            leading: contactUser.initials() == ''
                ? CircleAvatar(
                    child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ))
                : CircleAvatar(
                    child: Text(contactUser.initials()),
                  ),
            title: Text(
              contactUser.first_name + ' ' + contactUser.last_name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              contactUser.number,
              style: TextStyle(color: UniversalVariables.greyColor),
            ),
          );
        }),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestions(query),
      ),
    );
  }
}
