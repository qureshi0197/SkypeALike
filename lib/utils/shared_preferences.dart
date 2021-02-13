import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../main.dart';

class SharedPreference {
  SharedPreferences sp;
  Future saveWelcomeMessage(String text) async {
    sp = await SharedPreferences.getInstance();
    await sp.setString('welcome_message', text);
  }

  Future changePassword(String new_password) async {
    sp = await SharedPreferences.getInstance();
    user.password = new_password;
    await sp.setString('password', user.password);
  }

  Future getWelcomeMessage() async {
    sp = await SharedPreferences.getInstance();
    print(sp.getString('welcome_message'));
    return sp.getString('welcome_message') ?? '';
  }

  Future login(session) async {
    sp = await SharedPreferences.getInstance();
    try {
      await sp.setBool('login', true);
      await sp.setString('session', session);
      await sp.setString('username', user.name);
      await sp.setString('password', user.password);
      await sp.setString('number', user.number);
      await sp.setString('welcome_message', user.welcome_message);
      return true;
    } catch (ex) {
      return false;
    }
  }

  lastContactFetchedTimeStamp(time) async {
    sp = await SharedPreferences.getInstance();
    await sp.setString('contacts', time);
  }

  getLastContactFetchedTimeStamp() async {
    sp = await SharedPreferences.getInstance();
    return sp.getString('contacts') ?? null;
  }

  lastMesgFetchedTimeStamp(time) async {
    sp = await SharedPreferences.getInstance();
    await sp.setString('messages', time);
  }

  getLastMesgFetchedTimeStamp() async {
    sp = await SharedPreferences.getInstance();
    return sp.getString('messages') ?? null;
  }

  session() async {
    sp = await SharedPreferences.getInstance();
    // try {
    // await sp.setBool('login', true);
    return sp.getString('session') ?? null;
  }

  Future logout() async {
    sp = await SharedPreferences.getInstance();
    try {
      await sp.remove('login');
      await sp.remove('session');
      await sp.remove('username');
      await sp.remove('password');
      await sp.remove('number');
      await sp.remove('welcome_message');
      return true;
    } catch (ex) {
      return false;
    }
  }

  clearAllStrings() async {
    sp = await SharedPreferences.getInstance();
    sp.remove('username');
    sp.remove('session');
    sp.remove('login');
    sp.remove('password');
    sp.remove('number');
    sp.remove('messages');
    sp.remove('contacts');
    sp.remove('welcome_message');
  }

  checklogin() async {
    sp = await SharedPreferences.getInstance();
    user.name = sp.getString('username') ?? '';
    user.password = sp.getString('password') ?? '';
    user.number = sp.getString('number') ?? '';
    user.welcome_message = sp.getString('welcome_message') ?? '';
    return (sp.getBool('login') ?? false);
  }
}
