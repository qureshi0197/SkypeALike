import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:skypealike/db/database_helper.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/models/message.dart';
import 'package:skypealike/utils/shared_preferences.dart';
import 'package:skypealike/utils/utilities.dart';

import '../main.dart';
import '../models/user.dart';

class HttpService {
  static String SERVER = 'https://smsapp.intrelligent.com:4043/';
  static String LOGIN = SERVER + 'customer/login';
  static String LOGOUT = SERVER + 'customer/logout';
  static String MESSAGES = SERVER + 'message/all';
  static String GET_CONTACTS = SERVER + "contact/all";
  static String ADD_CONTACT = SERVER + "contact/register";
  static String UPDATE_CONTACT = SERVER + "contact/modify";
  static String SEND_MESSAGE = SERVER + "message/send";
  static String DELETE_MESSAGE = SERVER + "message/delete";
  static String DELETE_CONTACT = SERVER + "contact/delete";
  static String CHANGE_PASSWORD = SERVER + "customer/password_change";
  static String WELCOME_MESSAGE = SERVER + "customer/welcome_message_change";
  static String DELETE_CHAT = SERVER + "message/chat/delete";

  Future<bool> signOut() async {
    var head = {
      "Content-Type": "application/json",
    };
    Response response = await post(Uri.parse(MESSAGES), headers: head);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<dynamic> login(username, password) async {
    SharedPreference sharedPreference = SharedPreference();
    FirebaseMessaging firebaseMessaging;
    firebaseMessaging = FirebaseMessaging.instance;
    String firebaseToken = await firebaseMessaging.getToken();
    print("FCM Token:" + " " + firebaseToken);

    var body = jsonEncode({
      'username': username,
      'password': password,
      'registration_id': firebaseToken
    });
    var header = {
      "Content-Type": "application/json",
    };

    Response response =
        await post(Uri.parse(LOGIN), body: body, headers: header);
    if (response.statusCode != 200) {
      var responseBody = jsonDecode(response.body);
      return responseBody['resultCode'];
    }
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var loginBody = jsonDecode(body);
      loginBody['number'] = responseBody['number'];
      loginBody['welcome_message'] = responseBody['welcome_message'];
      user = User.fromMap(loginBody);
      await sharedPreference.login(response.headers['set-cookie']);
    }
    var responseBody = jsonDecode(response.body);
    return responseBody['resultCode'];
  }

  Future<dynamic> logout() async {
    SharedPreference sharedPreference = SharedPreference();
    DatabaseHelper databaseHelper = DatabaseHelper();
    String session = await sharedPreference.session();
    var header = {"Cookie": session};
    Response response = await get(Uri.parse(LOGOUT), headers: header);
    if (response.statusCode != 200) {
      return false;
    }
    await sharedPreference.logout();
    await databaseHelper.deleteDB();
    return true;
  }

  Future<dynamic> getAllMessages(String time) async {
    SharedPreference sharedPreference = SharedPreference();
    String session = await sharedPreference.session();
    var body = {
      'timestamp': time // "2020-08-31 07:00:00"
    };

    if (time == null) {
      body = {};
    }

    var header = {"Cookie": session};
    Response response;
    List<Message> messages = [];

    if (time == null) {
      response = await post(Uri.parse(MESSAGES), headers: header);
    } else {
      header['Content-Type'] = "application/json";
      response = await post(Uri.parse(MESSAGES),
          headers: header, body: jsonEncode(body));
    }
    time = Utils.formatDateTime(DateTime.now().toUtc());
    if (response.statusCode == 401) {
      return 401;
    } else if (response.statusCode != 200) {
      Fluttertoast.showToast(msg: "Server Error");
      return null;
    }

    await sharedPreference.lastMesgFetchedTimeStamp(time);
    Map responseBody = jsonDecode(response.body);

    if (responseBody.containsKey('data')) {
      Map responseData = (responseBody['data']);
      responseData.forEach((key, value) {
        messages.add(Message.fromMap(value));
      });
    }
    return messages;
  }

  Future<dynamic> getAllContacts(time) async {
    SharedPreference sharedPreference = SharedPreference();

    String session = await sharedPreference.session();
    var body = {'timestamp': time};
    var header = {"Cookie": session};
    Response response;
    if (time == null) {
      response = await post(Uri.parse(GET_CONTACTS), headers: header);
    } else {
      header['Content-Type'] = "application/json";
      response = await post(Uri.parse(GET_CONTACTS),
          headers: header, body: jsonEncode(body));
    }
    time = Utils.formatDateTime(DateTime.now().toUtc());
    if (response.statusCode == 401) {
      return 401;
    } else if (response.statusCode != 200) {
      Fluttertoast.showToast(msg: "Error fetching contacts");
      return null;
    }
    Map responseBody = jsonDecode(response.body);
    List<Contact> contacts = [];
    await sharedPreference.lastContactFetchedTimeStamp(time);
    if (responseBody.containsKey('data')) {
      responseBody['data'].forEach((key, value) {
        contacts.add(Contact.fromMap(value));
      });
      return contacts;
    } else {
      return null;
    }
  }

  Future<dynamic> welcomeMessage(String textMessage) async {
    SharedPreference sharedPreference = SharedPreference();
    String session = await sharedPreference.session();

    var body =
        jsonEncode({'username': user.name, 'welcome_message': textMessage});

    var header = {"Cookie": session};
    Response response;

    header['Content-Type'] = "application/json";
    try {
      response =
          await post(Uri.parse(WELCOME_MESSAGE), headers: header, body: body);
    } catch (ex) {
      Fluttertoast.showToast(msg: 'Internet Error');
      return false;
    }

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      if (responseBody["resultCode"] == 0) {
        await sharedPreference.saveWelcomeMessage(textMessage);
        try {
          user.welcome_message = textMessage;
          return true;
        } catch (ex) {
          print(ex.message);
        }
      }
    } else {
      Fluttertoast.showToast(msg: 'Server Error');
      return false;
    }
  }

  Future<dynamic> changePassword(String newPassword, String oldPassword) async {
    SharedPreference sharedPreference = SharedPreference();
    String session = await sharedPreference.session();

    var body = jsonEncode({
      'username': user.name,
      'old_password': oldPassword,
      'new_password': newPassword
    });

    var header = {"Cookie": session};
    Response response;

    header['Content-Type'] = "application/json";
    try {
      response =
          await post(Uri.parse(CHANGE_PASSWORD), headers: header, body: body);
    } catch (ex) {
      Fluttertoast.showToast(msg: 'Server Error');
      return;
    }

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      if (responseBody["resultCode"] == 0) {
        sharedPreference.changePassword(newPassword);
        return 200;
      } else {
        return response.statusCode;
      }
    }
  }

  Future<dynamic> createContact(Contact contact) async {
    SharedPreference sharedPreference = SharedPreference();
    String session = await sharedPreference.session();
    if (contact.address == null) {
      contact.address = '';
    }
    if (contact.company == null) {
      contact.company = '';
    }
    if (contact.email == null) {
      contact.email = '';
    }
    if (contact.first_name == null) {
      contact.first_name = '';
    }
    if (contact.last_name == null) {
      contact.last_name = '';
    }
    Map contactMap = contact.toMap(contact);
    contactMap.remove('status');
    contactMap.remove('id');
    var body = jsonEncode(contactMap);

    var header = {"Cookie": session};
    Response response;

    header['Content-Type'] = "application/json";
    response = await post(Uri.parse(ADD_CONTACT), headers: header, body: body);

    if (response.statusCode == 401) {
      return 401;
    } else if (response.statusCode != 200) {
      return null;
    }

    return 200;
  }

  Future<dynamic> updateContact(Contact contact) async {
    SharedPreference sharedPreference = SharedPreference();
    String session = await sharedPreference.session();

    Map contactMap = contact.toMap(contact);
    contactMap.remove('id');
    var body = jsonEncode(contactMap);

    var header = {"Cookie": session};
    Response response;

    header['Content-Type'] = "application/json";
    response =
        await post(Uri.parse(UPDATE_CONTACT), headers: header, body: body);

    if (response.statusCode == 401) {
      return 401;
    } else if (response.statusCode != 200) {
      Fluttertoast.showToast(msg: "Server Error");
      return null;
    }

    return 200;
  }

  Future<dynamic> deleteContact(Contact contact) async {
    SharedPreference sharedPreference = SharedPreference();
    String session = await sharedPreference.session();
    var body = jsonEncode({'number': contact.number});

    var header = {"Cookie": session};
    Response response;

    header['Content-Type'] = "application/json";
    response =
        await post(Uri.parse(DELETE_CONTACT), headers: header, body: body);

    if (response.statusCode == 401) {
      return false;
    } else if (response.statusCode != 200) {
      Fluttertoast.showToast(msg: "Server Error");
      return false;
    }

    return true;
  }

  Future<dynamic> deleteMessage(Message message) async {
    SharedPreference sharedPreference = SharedPreference();
    String session = await sharedPreference.session();
    var body = jsonEncode({'sms_id': message.sms_id});

    var header = {"Cookie": session};
    Response response;

    header['Content-Type'] = "application/json";
    response =
        await post(Uri.parse(DELETE_MESSAGE), headers: header, body: body);

    if (response.statusCode == 401) {
      return 401;
    } else if (response.statusCode != 200) {
      Fluttertoast.showToast(msg: "Server Error");
      return null;
    }

    return 200;
  }

  Future<dynamic> deleteChat(String number) async {
    SharedPreference sharedPreference = SharedPreference();
    String session = await sharedPreference.session();
    var body = jsonEncode({'receiver_number': number});

    var header = {"Cookie": session};
    Response response;

    header['Content-Type'] = "application/json";
    response = await post(Uri.parse(DELETE_CHAT), headers: header, body: body);

    if (response.statusCode == 401) {
      return 401;
    } else if (response.statusCode != 200) {
      Fluttertoast.showToast(msg: "Server Error");
      return null;
    }

    return 200;
  }

  Future<dynamic> sendMessage(Map message) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    SharedPreference sharedPreference = SharedPreference();
    String session = await sharedPreference.session();
    var body = jsonEncode(message);

    var header = {"Cookie": session};
    Response response;

    header['Content-Type'] = "application/json";
    response = await post(Uri.parse(SEND_MESSAGE), headers: header, body: body);

    if (response.statusCode == 401) {
      Fluttertoast.showToast(msg: 'Session Expired');
      return 401;
    } else if (response.statusCode != 200) {
      Fluttertoast.showToast(msg: "Server Error");
      return null;
    }
    Map responseBody = jsonDecode(response.body);
    responseBody['timestamp'] = responseBody['created_at'];
    responseBody['text'] = message['message_text'];

    Fluttertoast.showToast(msg: "Message Sent");
    Message dbMessage = Message.fromMap(responseBody);
    await databaseHelper.createMessage(dbMessage);
    return 200;
  }
}
