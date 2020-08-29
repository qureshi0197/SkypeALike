import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skypealike/provider/image_upload_provider.dart';
import 'package:skypealike/provider/user_provider.dart';
import 'package:skypealike/resources/auth_methods.dart';
import 'package:skypealike/screens/home_screen.dart';
import 'package:skypealike/screens/login_screen.dart';
import 'package:skypealike/screens/search_screen.dart';

void main() => runApp(SkypeAlike());

class SkypeAlike extends StatefulWidget {
  @override
  _SkypeAlikeState createState() => _SkypeAlikeState();
}

class _SkypeAlikeState extends State<SkypeAlike> {
  // FirebaseRepository _repository = FirebaseRepository();
  AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: "SkypeAlike",
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          '/search_screen': (context) => SearchScreen(),
        },
        theme: ThemeData(
          brightness: Brightness.dark 
        ),
        home: FutureBuilder(
          future: _authMethods.getCurrentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot){
            if (snapshot.hasData){
              return HomeScreen();
            }else {
              return LoginScreen();
            }
          },

        ),
      ),
    );
  }
}