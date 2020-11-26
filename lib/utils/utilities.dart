import 'package:skypealike/db/database_helper.dart';
import 'package:skypealike/models/contact.dart';
import 'package:intl/intl.dart';
import 'package:skypealike/utils/universal_variables.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  // Contact receiver;
  // UniversalVariables uVariables = UniversalVariables();

  static String getUsername(String email) {
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    if (name.length < 1) return '';
    return name[0].toUpperCase();
  }

  static Future<Contact> checkContact(Contact contact) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List contacts = await dbHelper.searchContact(contact);

    if (contacts.isNotEmpty) {
      return Contact.fromMap(contacts[0]);
    }
    return null;
  }

  static String checkNames(Contact contact) {
    String title = '';

    if (contact.first_name.isNotEmpty) {
      title = contact.first_name;
    }
    if (contact.last_name.isNotEmpty) {
      if (title.isNotEmpty) {
        title = title + ' ' + contact.last_name;
      } else {
        title = contact.last_name;
      }
    }
    if (title.isEmpty) {
      title = contact.number;
    }

    return title;
  }

  static String formatDateTime(DateTime time) {
    if (time == null) {
      return null;
    }
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(time);

    return formatter;
  }

  static DateTime convertStringToDateTime(String date) {
    if (date == null) {
      return null;
    }
    DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    return formatter.parse(date);
  }

  static call(String number) => launch("tel:$number");

  static onLongPress() {}

  static isSelectedTile(Contact contact, bool onLongPress,List<String> selectedNumber) {
    if (onLongPress &&
        selectedNumber.contains(contact.number)) {
      return true;
    }
    return false;
  }

  static selectAll(List chatList,List<String> selectedNumber) {
    if (selectedNumber.length == chatList.length) {
      return true;
    }
    return false;
  }
}
