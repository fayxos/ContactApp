import 'package:contact_app/features/authentication/views/verify_email.dart';
import 'package:contact_app/utils/constants/text_strings.dart';
import 'package:contact_app/features/connections/views/home_view.dart';
import 'package:contact_app/features/authentication/views/loading_view.dart';
import 'package:contact_app/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'features/authentication/controllers/auth_controller.dart';
import 'features/authentication/views/login.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = AuthController();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Texts.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: LoadingView(authController: authController,),
      debugShowCheckedModeBanner: false,
    );
  }

}