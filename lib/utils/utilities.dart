import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Img;
import 'package:path_provider/path_provider.dart';
import 'package:skypealike/enum/user_state.dart';

class Utils {
  static String getUsername(String email) {

    return "live:${email.split('@')[0]}";

  }

  static String getInitials(String name){
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[1][0];

    return firstNameInitial + lastNameInitial;
  }

  static Future<File> pickImage({@required ImageSource source}) async {
    File selectedImage = await ImagePicker.pickImage(source: source);
    // return selectedImage;

    return compressImage(selectedImage);
  }

  static Future<File> compressImage(File imageToCompress) async {

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int random = Random().nextInt(1000);

    Img.Image image = Img.decodeImage(imageToCompress.readAsBytesSync());
    Img.copyResize(image, width: 500, height: 500);


    return new File('$path/img_$random.jpg')..writeAsBytesSync(Img.encodeJpg(image, quality: 85));

  }

  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;

      case UserState.Online:
        return 1;

      default:
        return 2;
    }
  }

  static UserState numToState(int number) {
    switch (number) {
      case 0:
        return UserState.Offline;

      case 1:
        return UserState.Online;

      default:
        return UserState.Waiting;
    }
  }
}

