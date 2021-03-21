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
import 'package:skypealike/utils/utilities.dart';
import 'package:skypealike/widgets/appbar.dart';

import 'edit_contact_screen.dart';

class ChatScreen extends StatefulWidget {
  final Contact receiver;

  ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  UniversalVariables uVariable = UniversalVariables();
  TextEditingController textFieldController = TextEditingController();
  ScrollController _listScrollController = ScrollController();
  bool loading = true;
  bool contactFound = false;
  bool isWriting = false;
  bool showEmojiPicker = false;
  User sender;
  String _currentUserId;
  FocusNode textFieldFocus = FocusNode();
  Contact receiver;
  List<Message> userChat = [];
  bool sendMessageLoading = false;

  DatabaseHelper dbHelper = DatabaseHelper();

  Future message;

  Stream getPeriodicStream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) async {
      return await httpService.getAllMessages(null);
    }).asyncMap(
      (value) async => await value,
    );
  }

  @override
  void initState() {
    super.initState();
    receiver = widget.receiver;

    if (receiver.first_name.isNotEmpty || receiver.last_name.isNotEmpty) {
      contactFound = true;
    }
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
    return WillPopScope(
      onWillPop: () {
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

        textFieldController.text = textFieldController.text + emoji.emoji;
      },
    );
  }

  Widget messageList() {
    message = httpService.getAllMessages(null);
    var smessage = getPeriodicStream();

    return StreamBuilder(
      stream: getPeriodicStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          for (var message in snapshot.data) {
            Future<bool> condition = dbHelper.searchMessages(message);
            condition.then((bool onValue) {
              if (!onValue) {
                dbHelper.createMessage(message);
              }
            });
          }
        }

        return FutureBuilder(
          future: dbHelper.getMessages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState.index == 1 && userChat.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            userChat = [];
            for (Message message in snapshot.data) {
              if (message.sender == receiver.number ||
                  message.receiver == receiver.number) {
                userChat.add(message);
              }
            }

            userChat = userChat.reversed.toList();

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
      },
    );
  }

  Widget chatMessageItem(Message message) {
    return GestureDetector(
      onTap: () {
        if (uVariable.onLongPress) {
          if (!uVariable.selectedMessagesIds.contains(message.sms_id)) {
            uVariable.selectedMessagesIds.add(message.sms_id);
          } else {
            uVariable.selectedMessagesIds.remove(message.sms_id);
          }
          if (uVariable.selectedMessagesIds.isEmpty) {
            uVariable.onLongPress = false;
          }
        }
        setState(() {});
      },
      onLongPress: () {
        if (!uVariable.selectedMessagesIds.contains(message.sms_id))
          uVariable.selectedMessagesIds.add(message.sms_id);
        uVariable.onLongPress = true;
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Container(
            alignment: message.direction == "outbound"
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: message.direction == "outbound"
                ? senderLayout(message)
                : receiverLayout(message)),
      ),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: Utils.isSelectedTile(Contact(number: message.sms_id),
                uVariable.onLongPress, uVariable.selectedMessagesIds)
            ? Colors.grey
            : UniversalVariables.blueColor,
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
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: Utils.isSelectedTile(Contact(number: message.sms_id),
                uVariable.onLongPress, uVariable.selectedMessagesIds)
            ? Colors.grey
            : UniversalVariables.sendMessageColor,
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
              minLines: 1,
              maxLines: 10,
              maxLengthEnforced: true,
              controller: textFieldController,
              focusNode: textFieldFocus,
              onTap: () => hideEmojiContainer(),
              style: TextStyle(color: UniversalVariables.blackColor),
              onChanged: (val) {
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
                  contentPadding: EdgeInsets.fromLTRB(25, 10, 35, 10)),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                if (!showEmojiPicker) {
                  hideKeyboard();
                  showEmojiContainer();
                } else {
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
        Utils.checkNames(receiver),
        style: TextStyle(color: UniversalVariables.blackColor),
      ),
      actions: <Widget>[
        uVariable.onLongPress
            ? Container(
                child: Wrap(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: UniversalVariables.gradientColorEnd,
                        ),
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          for (String messageId
                              in uVariable.selectedMessagesIds) {
                            Message tempMessage = Message(sms_id: messageId);
                            var response =
                                await httpService.deleteMessage(tempMessage);
                            await dbHelper.deleteMessages(tempMessage);
                          }
                          setState(() {
                            loading = false;
                          });
                          uVariable.onLongPress = false;
                          uVariable.selectedMessagesIds = [];
                        }),
                    IconButton(
                      color: UniversalVariables.gradientColorEnd,
                      onPressed: () {
                        if (Utils.selectAll(
                            userChat, uVariable.selectedMessagesIds)) {
                          uVariable.selectedMessagesIds = [];
                          uVariable.onLongPress = false;
                        } else {
                          uVariable.onLongPress = true;
                          for (var message in userChat) {
                            if (!uVariable.selectedMessagesIds
                                .contains(message.sms_id))
                              uVariable.selectedMessagesIds.add(message.sms_id);
                          }
                        }
                        setState(() {});
                      },
                      icon: Utils.selectAll(
                              userChat, uVariable.selectedMessagesIds)
                          ? Icon(Icons.check_box)
                          : Icon(Icons.check_box_outline_blank),
                    )
                  ],
                ),
              )
            : contactFound
                ? IconButton(
                    onPressed: () => Utils.call(receiver.number),
                    icon: Icon(Icons.add_call),
                    color: UniversalVariables.gradientColorEnd,
                  )
                : Wrap(
                    spacing: 3,
                    children: <Widget>[
                      IconButton(
                        onPressed: () =>
                            {Utils.call(receiver.number), setState(() {})},
                        icon: Icon(Icons.add_call),
                        color: UniversalVariables.gradientColorEnd,
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.person_add,
                            color: UniversalVariables.gradientColorEnd,
                          ),
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditContact(receiver, update: false)));
                            setState(() {});
                          })
                    ],
                  ),
      ],
    );
  }
}
