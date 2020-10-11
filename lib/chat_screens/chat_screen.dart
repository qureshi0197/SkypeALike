// import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:skypealike/chat_screens/widgets/cached_image.dart';
import 'package:skypealike/constants/strings.dart';
import 'package:skypealike/enum/view_state.dart';
import 'package:skypealike/main.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/models/message.dart';
import 'package:skypealike/models/user.dart';
import 'package:skypealike/provider/image_upload_provider.dart';
import 'package:skypealike/screens/home_screen.dart';
import 'package:skypealike/utils/universal_variables.dart';
// import 'package:skypealike/utils/utilities.dart';
import 'package:skypealike/widgets/appbar.dart';
// import 'package:skypealike/widgets/custom_tile.dart';
import 'package:skypealike/resources/auth_methods.dart';
import 'package:skypealike/resources/chat_methods.dart';
import 'package:skypealike/resources/storage_methods.dart';

class ChatScreen extends StatefulWidget {
  final Contact receiver;

  ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  // FirebaseRepository _repository = FirebaseRepository();
  AuthMethods _authMethods = AuthMethods();
  StorageMethods _storageMethods = StorageMethods();
  ChatMethods _chatMethods = ChatMethods();
  ScrollController _listScrollController = ScrollController();
  bool loading = true;

  bool isWriting = false;
  bool showEmojiPicker = false;
  User sender;
  String _currentUserId;
  FocusNode textFieldFocus = FocusNode();
  ImageUploadProvider _imageUploadProvider;
  Contact receiver;
  var userChat = [];
  bool sendMessageLoading = false;
  // var loading = true;

  // getMessages()async{

  //   setState(() {
  //   });
  //   loading = false;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    receiver = widget.receiver;
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
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);

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
            _imageUploadProvider.getViewState == ViewState.LOADING
                ? Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 15),
                    child: CircularProgressIndicator(),
                  )
                : Container(),
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
    return FutureBuilder(
      future: httpService.getAllMessages(null),
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
    return Text(message.message,
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
    // display for attachment(+) button knwonw as Modal
    // addMediaModal(context){
    //   showModalBottomSheet(
    //     context: context,
    //     elevation: 0,
    //     backgroundColor: Colors.white,
    //     builder: (context) {
    //       return Column(
    //         children: <Widget>[
    //           Container(
    //             padding: EdgeInsets.symmetric(vertical: 15),
    //             child: Row(
    //               children: <Widget>[
    //                 FlatButton(
    //                   child: Icon(
    //                     Icons.close,color: UniversalVariables.blackColor,
    //                   ),
    //                   onPressed: () => Navigator.maybePop(context),

    //                   ),
    //                   Expanded(
    //                     child: Align( alignment: Alignment.centerLeft,
    //                       child: Text("Content and Tools", // title of modal
    //                       style: TextStyle(
    //                         color: UniversalVariables.blackColor,
    //                         fontSize: 20,
    //                         fontWeight: FontWeight.bold),

    //                       ),
    //                     ),
    //                   ),
    //               ],
    //             ),
    //           ),
    //           // Labels of every tile that is included in modal
    //           Flexible(
    //             child: ListView(
    //               children: <Widget>[
    //                 // ModalTile(
    //                 //   title: "Media",
    //                 //   subtitle: "Share Photos",
    //                 //   icon: Icons.image,
    //                 // ),

    //                 // ModalTile(
    //                 //   title: "File",
    //                 //   subtitle: "Share Files",
    //                 //   icon: Icons.tab,
    //                 // ),

    //                 // ModalTile(
    //                 //   title: "Contact",
    //                 //   subtitle: "Share Contacts",
    //                 //   icon: Icons.contacts,
    //                 // ),

    //                 // ModalTile(
    //                 //   title: "Location",
    //                 //   subtitle: "Share Location",
    //                 //   icon: Icons.add_location,
    //                 // ),

    //                 // ModalTile(
    //                 //   title: "Schedule Call",
    //                 //   subtitle: "Schedule a skype call and get reminders",
    //                 //   icon: Icons.schedule,
    //                 // ),

    //                 // ModalTile(
    //                 //   title: "Create Poll",
    //                 //   subtitle: "Share Polls",
    //                 //   icon: Icons.poll,
    //                 // ),

    //               ],
    //             ),
    //             )

    //         ],
    //       );
    //     }
    //   );
    // }

    // pickImage({@required ImageSource source}) async {
    //   File selectedImage = await Utils.pickImage(source: source);
    //   _storageMethods.uploadImage(
    //     image: selectedImage,
    //     receiverId: widget.receiver.uid,
    //     senderId: _currentUserId,
    //     imageUploadProvider: _imageUploadProvider,
    //   );

    // }

    // Design of tiles in modal and with conditions to chhk
    // if user is typing or not
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(children: <Widget>[
        //       GestureDetector(
        //         onTap: () => addMediaModal(context),
        //         child: Container(
        //           padding: EdgeInsets.all(5),
        //         decoration: BoxDecoration(
        //           gradient: UniversalVariables.fabGradient,
        //           shape: BoxShape.circle,
        //         ),
        //   child: Icon(Icons.add_a_photo),
        // ),
        //       ),
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

        // isWriting ? Container() : Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 10),
        //   child: Icon(Icons.record_voice_over,
        //           color: UniversalVariables.greyColor,
        //   )
        // ),

        // isWriting ? Container()
        //   : GestureDetector(
        //     onTap: () => pickImage(source: ImageSource.camera),
        //       child: Icon(Icons.camera_alt,
        //       color: UniversalVariables.greyColor,
        //       ),
        //   ),

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
        receiver.first_name ?? receiver.last_name ?? receiver.number,
        style: TextStyle(color: UniversalVariables.blackColor),
      ),
      actions: <Widget>[
        // IconButton(
        //   icon: Icon(Icons.video_call, color: UniversalVariables.greyColor,),
        //   onPressed: () {},
        //   ),

        // IconButton(
        //   icon: Icon(Icons.phone, color: UniversalVariables.greyColor),
        //   onPressed: () {},
        //   ),
      ],
    );
  }
}

// Function for Design of Modal Tile and its details
// class ModalTile extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final IconData icon;

//   const ModalTile({
//     @required this.title,
//     @required this.subtitle,
//     @required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 15),
//       child: CustomTile(
//         mini: false,
//         leading: Container(
//           margin: EdgeInsets.only(right: 10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             color: UniversalVariables.receiverColor,
//           ),
//           padding: EdgeInsets.all(10),
//           child: Icon(
//             icon,
//             color: Colors.white70,
//             size: 38,
//           ),
//         ),
//         subtitle: Text(
//           subtitle,
//           style: TextStyle(
//             color: UniversalVariables.greyColor,
//             fontSize: 14,
//           ),
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: UniversalVariables.blackColor,
//             fontSize: 18,
//           ),
//         ),
//       ),
//     );
//   }
// }
