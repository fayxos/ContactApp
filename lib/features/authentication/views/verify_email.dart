import 'package:contact_app/features/authentication/controllers/auth_controller.dart';
import 'package:contact_app/features/connections/views/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/appbar.dart';
import '../../../common/widgets/success_view.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import 'login.dart';


class VerifyEmailView extends StatelessWidget {
  final AuthController authController;

  const VerifyEmailView({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Appbar close icon will first Logout the user & then redirect back to Login Screen()
      /// Reason: We will store the data when user enters the Register Button on Previous screen.
      /// Whenever the user opens the app, we will check if email is verified or not.
      /// If not verified we will always show this Verification screen.
      appBar: CustomAppBar(actions: [IconButton(onPressed: () {
        authController.logout();
        Get.offAll(() => LoginView(authController: authController,));
    }, icon: const Icon(CupertinoIcons.clear))]),
      body: SingleChildScrollView(
        // Padding to Give Default Equal Space on all sides in all screens.
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            children: [
              /// Image
              Image(
                image: const AssetImage(ImageStrings.deliveredEmailIllustration),
                width: HelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: Sizes.spaceBtwSections),

              /// Title & SubTitle
              Text(Texts.confirmEmail, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: Sizes.spaceBtwItems),
              Text(authController.currentUser.email!, style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center),
              const SizedBox(height: Sizes.spaceBtwItems),
              Text(Texts.confirmEmailSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: Sizes.spaceBtwSections),

              /// Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      bool isEmailVerified = await authController.getEmailVerified();
                      if(isEmailVerified) {
                        Get.to(() => SuccessView(
                            image: ImageStrings.staticSuccessIllustration,
                            title: Texts.yourAccountCreatedTitle,
                            subTitle: Texts.yourAccountCreatedSubTitle,
                            onPressed: () { Get.offAll(() => HomeView(authController: authController,)); }),
                          );
                      } else {
                        const snackbar = SnackBar(
                          backgroundColor: CustomColors.warning,
                          content: Text("Please verify your email first.",
                            style: TextStyle(color: CustomColors.textWhite),),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Sizes.borderRadiusLg))),);
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      }

                    },
                    child: const Text(Texts.tContinue)),
              ),
              const SizedBox(height: Sizes.spaceBtwItems),
              // TODO resend email
              SizedBox(width: double.infinity, child: TextButton(onPressed: () { }, child: const Text(Texts.resendEmail))),
            ],
          ),
        ),
      ),
    );
  }
}
