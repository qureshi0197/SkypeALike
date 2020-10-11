import 'dart:convert';
// import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:skypealike/models/contact.dart';
import 'package:skypealike/models/post.dart';
import 'package:skypealike/utils/shared_preferences.dart';

import '../main.dart';
import '../models/user.dart';

class HttpService {
  final String postsUrl = "https://jsonplaceholder.typicode.com/posts";
  static String SERVER = 'http://testing.intrelligent.com:8080/';
  static String LOGIN = SERVER + 'customer/login';
  static String LOGOUT = SERVER + 'customer/logout';
  static String MESSAGES = SERVER + 'message/all';
  static String GET_CONTACTS = SERVER + "contact/all";
  static String SAVE_CONTACT = SERVER + "contact/register";

  // toLoginMap()
  Future<bool> signOut() async {
    var head = {
      "Content-Type": "application/json",
    };
    Response response = await post(MESSAGES, headers: head);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<dynamic> login(username, password) async {
    SharedPreference sharedPreference = SharedPreference();
    var body = jsonEncode({'username': username, 'password': password});
    var header = {
      "Content-Type": "application/json",
      // "Cookie":"remember_token=5|90226507456dcc7bb26523997e7c07da9a930ccfebb4af3f3407cb85140a75b8a148ba5eaa3f1e7de5a6c2fee2f1d4171f28cb93802ebbf7e7294c47aeb66645; session=.eJwdj7uOwjAQRX8FuaaIndBE2gJkFFHMWFmNscYNEhAIDmnCok2C-HdG1Pfc10sdLkPzaFX5NzybpTrczqp8qcVRlQrMvsXAU7TbKZIfoaozoFo74gJD7NnAigNrtLvRERgmn3OPnaOr4bnLXcV5tMJXoGHetFhJnoFCfHNM_M-pHjFhF4MXfl1g-r2hhSkGztCeNNBd-n3mqBMdJrBe-HOSPRp6mIG8RqpzSNcf9Zbtz0czfA-s3h85YkWn.X3if_Q.mObhdmD8qeLkjHXsh3Vr1F4LXNI",
      // "Connection":"keep-alive"
    };

    Response response = await post(LOGIN, body: body, headers: header);
    // print(response.headers['set-cookie']);
    if (response.statusCode != 200) {
      return null;
    }
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var loginBody = jsonDecode(body);
      loginBody['number'] = responseBody['number'];
      // If response will have the number
      user = User.fromMap(loginBody);
      await sharedPreference.login(response.headers['set-cookie']);
      // await sharedPreference.saveUserLogin()
    }
    var responseBody = jsonDecode(response.body);
    return responseBody['resultCode'];
  }

  Future<dynamic> logout() async {
    SharedPreference sharedPreference = SharedPreference();
    String session = await sharedPreference.session();
    var header = {"Cookie": session};
    Response response = await get(LOGOUT, headers: header);
    if (response.statusCode != 200) {
      return false;
    }
    await sharedPreference.logout();
    return true;
  }

  Future<dynamic> getAllMessages(time) async {
    SharedPreference sharedPreference = SharedPreference();
    String session = await sharedPreference.session();
    var body = {
      'timestamp': time // "2020-08-31 07:00:00"
    };
    // if (time == null) {
    //   body = {};
    // }
    var header = {"Cookie": session};
    Response response;
    if (time == null) {
      response = await post(MESSAGES, headers: header);
    } else {
      header['Content-Type'] = "application/json";
      response = await post(MESSAGES, headers: header, body: body);
    }
    print(response.body);
    if (response.statusCode == 401) {
      return 401;
    } else if (response.statusCode != 200) {
      Fluttertoast.showToast(msg: "Server Error");
      return null;
    }
    var responseBody = jsonDecode(response.body);
    return responseBody;
  }

  Future<dynamic> getAllContacts(time) async {
    SharedPreference sharedPreference = SharedPreference();
    String session = await sharedPreference.session();
    var body = {
      'timestamp': time // "2020-08-31 07:00:00"
    };
    // if (time == null) {
    //   body = {};
    // }
    var header = {"Cookie": session};
    Response response;
    if (time == null) {
      response = await post(GET_CONTACTS, headers: header);
    } else {
      header['Content-Type'] = "application/json";
      response = await post(GET_CONTACTS, headers: header, body: body);
    }
    print(response.body);
    if (response.statusCode == 401) {
      return 401;
    } else if (response.statusCode != 200) {
      Fluttertoast.showToast(msg: "Error fetching contacts");
      return null;
    }
    Map responseBody = jsonDecode(response.body);
    List<Contact> contacts = [];
    if(responseBody.containsKey('data')){
      responseBody['data'].forEach((key,value){
        // Map contact = {
        //   'displayName': value['first_name'],
        //   'givenName': value['last_name'],
        //   'phones': [value['number']],
        //   'postalAddresses': [value['address']],
        //   'company': value['company'],
        //   'emails': [value['email']],
        // }; 
        contacts.add(Contact.fromMap(value));
      });
      return contacts;

    }else{
      return null;
    }
    // return responseBody;
  }

  Future<dynamic> createContact(Contact contact) async {
    SharedPreference sharedPreference = SharedPreference();
    String session = await sharedPreference.session();
    var body = jsonEncode(contact.toMap(contact));

    var header = {"Cookie": session};
    Response response;
    
      header['Content-Type'] = "application/json";
      response = await post(SAVE_CONTACT, headers: header, body: body);
    
    print(response.body);
    if (response.statusCode == 401) {
      return 401;
    } else if (response.statusCode != 200) {
      Fluttertoast.showToast(msg: "Error saving contact");
      return null;
    }

    return 200;
  }
}
