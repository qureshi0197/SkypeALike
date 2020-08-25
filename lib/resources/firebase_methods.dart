import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skypealike/constants/strings.dart';
import 'package:skypealike/models/message.dart';
import 'package:skypealike/models/user.dart';
import 'package:skypealike/provider/image_upload_provider.dart';
import 'package:skypealike/utils/utilities.dart';


class FirebaseMethods{

  User user = User();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  GoogleSignIn _googleSignIn = GoogleSignIn();
  
  static final Firestore firestore = Firestore.instance; 
  
  StorageReference _storageReference;


  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser; 
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken);

    FirebaseUser user = await _auth.signInWithCredential(credential);
    return user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async{
    QuerySnapshot result = await firestore
    .collection(USERS_COLLECTION)
    .where(EMAIL_FIELD, isEqualTo: user.email)
    .getDocuments();


    final List<DocumentSnapshot> docs = result.documents;
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = Utils.getUsername(currentUser.email);

    user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoUrl,
        username: username);

    firestore
        .collection(USERS_COLLECTION)
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();

  }

// Function to fetch all users into a list offline in one connection 
// instead of making connection again n again to search users

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).getDocuments();

// Loop through the list for users
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }
// Chat methods
  Future<void> addMessageToDb(Message message, User sender, User reciver) async {
    var map = message.toMap();

    await firestore.collection(MESSAGES_COLLECTION)
    .document(message.senderId)
    .collection(message.receiverId)
    .add(map);

    await firestore.collection(MESSAGES_COLLECTION)
    .document(message.receiverId)
    .collection(message.senderId)
    .add(map);

  }

// Storage
  Future<String> uploadImageToStorage(File image) async{
    try{
      _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');

    StorageUploadTask _storageUploadTask = _storageReference.putFile(image);

    var url = await (await _storageUploadTask.onComplete).ref.getDownloadURL();
    // print(url);
    return url;
    
    } catch(e) {
      print(e);
      return null;
    }
    
  }

  void setImageMessage(String url, String receiverId, String senderId) async {
    Message _message;

    _message = Message.imageMessage(
      message: "IMAGE",
      receiverId: receiverId,
      senderId: senderId,
      photoUrl: url,
      timestamp: Timestamp.now(),
      type: 'image',

    );

    var map = _message.toImageMap();

    // Set image message in database

    await firestore.collection(MESSAGES_COLLECTION)
    .document(_message.senderId)
    .collection(_message.receiverId)
    .add(map);

    await firestore.collection(MESSAGES_COLLECTION)
    .document(_message.receiverId)
    .collection(_message.senderId)
    .add(map);
  }

  void uploadImage(File image, String receiverId, String senderId, 
    ImageUploadProvider imageUploadProvider) async {
    
      imageUploadProvider.setToLoading();

      String url = await uploadImageToStorage(image);

      imageUploadProvider.setToIdle();
      setImageMessage(url, receiverId, senderId);
  
  }


}