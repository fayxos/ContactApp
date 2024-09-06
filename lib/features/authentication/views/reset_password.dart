import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../common/widgets/appbar.dart';
import '../controllers/auth_controller.dart';
import 'login.dart';

class ResetPassword extends StatelessWidget {
  final AuthController authController;

  const ResetPassword({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Appbar to go back OR close all screens and Goto LoginScreen()
      appBar: CustomAppBar(
        actions: [
          IconButton(onPressed: () => Get.offAll(LoginView(authController: authController,)), icon: const Icon(CupertinoIcons.clear)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            children: [
              /// Image with 60% of screen width
              Image(
                image: const AssetImage(ImageStrings.deliveredEmailIllustration),
                width: HelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: Sizes.spaceBtwSections),

              /// Title & SubTitle
              Text(Texts.changeYourPasswordTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: Sizes.spaceBtwItems),
              Text(
                  'mrtaimoorsikander@gmail.com',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge
              ),
              const SizedBox(height: Sizes.spaceBtwItems),
              Text(
                Texts.changeYourPasswordSubTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: Sizes.spaceBtwSections),

              /// Buttons
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text(Texts.done))),
              const SizedBox(height: Sizes.spaceBtwItems),
              SizedBox(
                  width: double.infinity, child: TextButton(onPressed: () {}, child: const Text(Texts.resendEmail))),
            ],
          ),
        ),
      ),
    );
  }
}
