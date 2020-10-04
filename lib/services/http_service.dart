import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
      // If response will have the number
      user = User.fromMap(jsonDecode(body));
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
      return null;
    }
    var responseBody = jsonDecode(response.body);
    return responseBody;
  }

  Future<List<Post>> getPosts() async {
    Response response = await get(postsUrl);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Post> posts =
          body.map((dynamic item) => Post.fromJson(item)).toList();

      return posts;
    } else {
      throw "Cant get Posts";
    }
  }

  Future<void> deletePost(int id) async {
    Response response = await delete("$postsUrl/$id");

    try {
      if (response.statusCode == 200) {
        print("Deleted!");
        getPosts();
      }
    } catch (e) {
      print(e);
    }
  }
}
