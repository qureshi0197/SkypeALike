import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  SharedPreferences sp;
  _getInstance() async {
    sp = await SharedPreferences.getInstance();
  }

  SharedPreference() {
    _getInstance();
  }
  Future login(session) async {
    sp = await SharedPreferences.getInstance();
    try {
      await sp.setBool('login', true);
      await sp.setString('session', session);
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
      return true;
    } catch (ex) {
      return false;
    }
  }

  checklogin() async{
    sp = await SharedPreferences.getInstance();
    return sp.getBool('login') ?? false;
  }
}
