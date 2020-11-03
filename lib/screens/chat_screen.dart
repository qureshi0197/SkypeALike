import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skypealike/constants/strings.dart';
import 'package:skypealike/db/database_helper.dart';
import 'package:skypealike/main.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/models/message.dart';
import 'package:skypealike/models/user.dart';
import 'package:skypealike/screens/home_screen.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:skypealike/widgets/appbar.dart';

import 'edit_contact_screen.dart';

class ChatScreen extends StatefulWidget {
  final Contact receiver;

  ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  // FirebaseRepository _repository = FirebaseRepository();
  // AuthMethods _authMethods = AuthMethods();
  // StorageMethods _storageMethods = StorageMethods();
  // ChatMethods _chatMethods = ChatMethods();
  ScrollController _listScrollController = ScrollController();
  bool loading = true;
  bool contactFound = false;
  bool isWriting = false;
  bool showEmojiPicker = false;
  User sender;
  String _currentUserId;
  FocusNode textFieldFocus = FocusNode();
  // ImageUploadProvider _imageUploadProvider;
  Contact receiver;
  var userChat = [];
  bool sendMessageLoading = false;

  DatabaseHelper dbHelper = DatabaseHelper();

  Future message;

  _checkContact() async {
    List contact = await dbHelper.searchContact(receiver);

    if(contact.isNotEmpty){
      receiver = Contact.fromMap(contact[0]);
      contactFound = true;
    }

    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    receiver = widget.receiver;
    _checkContact();
    // getMessages();
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _imageUploadProvider = Provider.of<ImageUploadProvider>(context);

    return WillPopScope(
      onWillPop: () {
        // Navigator.pop(context, userChat.last);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppBar(context,
            leading: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false);
                })),
        body: Column(
          children: <Widget>[
            Flexible(
              child: messageList(),
            ),
            // _imageUploadProvider.getViewState == ViewState.LOADING
                // ? Container(
                //     alignment: Alignment.centerRight,
                //     margin: EdgeInsets.only(right: 15),
                //     child: CircularProgressIndicator(),
                //   )
                // : Container(),
            chatControls(),
            showEmojiPicker ? Container(child: emojiContainer()) : Container(),
          ],
        ),
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        // Append Emoji with text message
        textFieldController.text = textFieldController.text + emoji.emoji;
      },
    );
  }

  Widget messageList() {
    message = httpService.getAllMessages(null);
    // dbHelper.createMessage(message);
    return FutureBuilder(
      future: message,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        // if
        if (loading) {
          if (snapshot.connectionState.index == 1)
            return Center(child: CircularProgressIndicator());
          else {
            loading = false;
          }
        }
        // else{
        //   setState(() {
        //     loading=false;
        //   });
        // }
        // if (snapshot.h == 1) {
        //   return Center(child: CircularProgressIndicator());
        // }
        if (snapshot.data == 401) {
          Fluttertoast.showToast(msg: "Session Expired");
          Navigator.pushNamedAndRemoveUntil(
              context, '/login_screen', (Route route) => false);
          sharedPreference.logout();
        }
        if (snapshot.data == null) {
          return Center(
            child: Text("No Messages"),
          );
        }
        var userChat = [];
        snapshot.data['data'].forEach((key, val) {
          if (val['sender'] == receiver.number ||
              val['receiver'] == receiver.number) {
            userChat.add(val);
          }
        });
        userChat = userChat.reversed.toList();
        // setState(() {
        //   loading=false;
        // });

        // return userChat;
        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: userChat.length,
          reverse: true,
          itemBuilder: (context, index) {
            return chatMessageItem(userChat[index]);
          },
        );
      },
    );
    // return ListView.builder(
    //       padding: EdgeInsets.all(10),
    //       itemCount: userChat.length,
    //       reverse: true,
    //       itemBuilder: (context, index) {
    //         return chatMessageItem(userChat[index]);
    //       },
    //     );
  }

  Widget chatMessageItem(Map snapshot) {
    Message _message = Message.fromMap(snapshot);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Container(
          alignment: snapshot['direction'] == "outbound"
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: snapshot['direction'] == "outbound"
              ? senderLayout(_message)
              : receiverLayout(_message)),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      // margin: EdgeInsets.only(top: 0),
      constraints:
          // no matter how long a message is it wont take more than 65% of the screen
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.blueColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message) {
    return Text(message.text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ));
    // If image received is null then app should not crash
    // instead show the Text message
    // : message.photoUrl != null
    //     ? CachedImage(
    //       message.photoUrl,
    //       height: 250,
    //       width: 250,
    //       radius: 10,
    //     )
    //     : Text("URL was null");
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          // no matter how long a message is it wont take more than 65% of the screen
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.receiveMessageColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(children: <Widget>[
        SizedBox(width: 5),
        Expanded(
            child: Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              controller: textFieldController,
              focusNode: textFieldFocus,
              onTap: () => hideEmojiContainer(),
              style: TextStyle(color: UniversalVariables.blackColor),
              onChanged: (val) {
                // check if userr has not typed anything and is not sending a blank message
                (val.length > 0 && (val.trim() != ""))
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(
                  color: UniversalVariables.greyColor,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: UniversalVariables.blueColor),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: UniversalVariables.blueColor,
                    ),
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(50.0))),

                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                // filled: true,
                // fillColor: UniversalVariables.separatorColor,
              ),
            ),
            IconButton(
              // splashColor: Colors.black,
              // highlightColor: Colors.black,
              onPressed: () {
                // hideKeyboard();
                // showEmojiContainer();
                if (!showEmojiPicker) {
                  // Emoji Panel is shown
                  hideKeyboard();
                  showEmojiContainer();
                } else {
                  // Emoji Panel is hidden
                  showKeyboard();
                  hideEmojiContainer();
                }
              },
              icon: Icon(Icons.tag_faces, color: UniversalVariables.blueColor),
            ),
          ],
        )),

 
        sendMessageLoading
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              )
            : isWriting
                ? Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        gradient: UniversalVariables.fabGradient,
                        shape: BoxShape.circle),
                    child: IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () => sendMessage()),
                  )
                : Container(),
      ]),
    );
  }

  sendMessage() async {
    var text = textFieldController.text;

    Map _message = {"message_text": text, "receiver_number": receiver.number};

    setState(() {
      isWriting = false;
      sendMessageLoading = true;
    });

    var response = await httpService.sendMessage(_message);
    // dbHelper.createMessage(_message);


    if (response == 401) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/login_screen', (route) => false);
    }

    textFieldController.text = "";

    setState(() {
      sendMessageLoading = false;
    });
  }

  CustomAppBar customAppBar(context, {Widget leading}) {
    return CustomAppBar(
      leading: leading != null
          ? leading
          : IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
      centerTitle: false,
      title: Text(
        receiver.first_name ?? receiver.last_name ?? receiver.number,
        style: TextStyle(color: UniversalVariables.blackColor),
      ),
      actions: <Widget>[
        contactFound ? Container() : IconButton(
          icon: Icon(Icons.person_add, color: UniversalVariables.gradientColorEnd,),
          
          // IF CONTACT NAME IS NOT EMPTY THEN DONT SHOW ADD CPNTACT BUTTON 
          // ELSE SHOW
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => EditContact(receiver)));
            await _checkContact();
            }
          ),

        // IconButton(
        //   icon: Icon(Icons.phone, color: UniversalVariables.greyColor),
        //   onPressed: () {},
        //   ),
      ],
    );
  }
}