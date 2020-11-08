import 'package:skypealike/db/database_helper.dart';
import 'package:skypealike/models/contact.dart';
import 'package:intl/intl.dart';

class Utils {

  // Contact receiver;

  static String getUsername(String email) {
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    if(name.length <1)
      return '';
    return name[0].toUpperCase();
  }

  static Future<Contact> checkContact(Contact contact) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List contacts = await dbHelper.searchContact(contact);

    if(contacts.isNotEmpty){
      return Contact.fromMap(contacts[0]);
    }
    return null;
  }

  static String checkNames(Contact contact){
    
    String title = '';


    if(contact.first_name.isNotEmpty){
      title = contact.first_name;
    }
    if(contact.last_name.isNotEmpty){
      if(title.isNotEmpty){
        title = title + ' ' + contact.last_name;
      }
      else{
        title = contact.last_name;
      }
    }
    if(title.isEmpty){
      title = contact.number;
    }

    return title;
  }

  static String formatDateTime(DateTime time) {
    if(time == null){
      return null;
    }
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(time);
    
    return formatter;
  }

  static DateTime convertStringToDateTime(String date){  
    if(date == null){
      return null;  
    }
    DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    return formatter.parse(date);
  }
}
