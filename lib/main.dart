


import 'package:chat/Register%20tab/register.dart';
import 'package:chat/Utils/Theme.dart';
import 'package:chat/chat%20tab/ChatPage.dart';
import 'package:chat/chat%20tab/Layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'Login tab/Login.dart';
import 'Register tab/Register_ViewModel.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,);
  runApp( ChangeNotifierProvider(
    create:(context) => Register_ViewModel(),
      child: MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(412, 892),
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        theme: MyThemes.LightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: loginPage.routeName,
        routes: {
          loginPage.routeName:(context) => loginPage(),
          Register.routeName:(context) => Register(),

          Layout.routeName:(context) => Layout(),
          ChatPage.routeName:(context) => ChatPage(),
        },


      ),
    );
  }
}


