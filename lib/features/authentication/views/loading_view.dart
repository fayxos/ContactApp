import 'dart:async';

import 'package:contact_app/features/authentication/controllers/auth_controller.dart';
import 'package:contact_app/utils/logging/logger.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatefulWidget {
  final AuthController authController;

  const LoadingView({super.key, required this.authController});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      widget.authController.goToView();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("loading"),
    );
  }
}

