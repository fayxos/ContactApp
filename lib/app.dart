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
  bool? isAuthenticated;
  bool? isEmailVerified;

  void _setAuthentication(bool? authenticated) {
    setState(() {
      isAuthenticated = authenticated;
    });
  }

  void _setEmailVerified(bool? verified) {
    setState(() {
      isEmailVerified = verified;
    });
  }

  @override
  void initState() {
    super.initState();
    authController = AuthController(_setAuthentication, _setEmailVerified);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Texts.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: _getHomeView(isAuthenticated, isEmailVerified),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _getHomeView(bool? isAuthenticated, bool? isEmailVerified) {
    return LoginView(authController: authController);

    if (isAuthenticated == null || isEmailVerified == null) {
      return const LoadingView();
    } else if (isAuthenticated && isEmailVerified) {
      return HomeView();
    } else if(isAuthenticated && !isEmailVerified) {
      return VerifyEmailView(authController: authController);
    } else {
      return LoginView(authController: authController);
    }
  }
}