import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../main.dart';

class SharedPreference {
  SharedPreferences sp;
  // _getInstance() async {
  //   sp = await SharedPreferences.getInstance();
  // }

  // SharedPreference() {
  //   _getInstance();
  // }
  Future login(session) async {
    sp = await SharedPreferences.getInstance();
    try {
      await sp.setBool('login', true);
      await sp.setString('session', session);
      await sp.setString('username', user.name);
      await sp.setString('password', user.password);
      await sp.setString('number', user.number);
      return true;
    } catch (ex) {
      return false;
    }
  }

  session() async {
    sp = await SharedPreferences.getInstance();
    // try {
    // await sp.setBool('login', true);
    return sp.getString('session') ?? null;
    //   return true;
    // } catch (ex) {
    //   return false;
    // }
  }

  Future logout() async {
    sp = await SharedPreferences.getInstance();
    try {
      await sp.remove('login');
      await sp.remove('session');
      await sp.remove('username');
      await sp.remove('password');
      await sp.remove('number');
      return true;
    } catch (ex) {
      return false;
    }
  }

  checklogin() async {
    sp = await SharedPreferences.getInstance();
    user.name = sp.getString('username') ?? '';
    user.password = sp.getString('password') ?? '';
    user.number = sp.getString('number') ?? '';
    return (sp.getBool('login') ?? false);
  }
}
