import 'package:contact_app/features/authentication/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../common/widgets/appbar.dart';
import '../widgets/form_divider.dart';
import '../widgets/signup_form.dart';
import '../widgets/social_buttons.dart';

class SignupView extends StatelessWidget {
  final AuthController authController;

  const SignupView({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///  Title
              Text(Texts.signupTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: Sizes.spaceBtwSections),

              /// Form
              SignupForm(authController: authController),
              const SizedBox(height: Sizes.spaceBtwSections),

              /// Divider
              FormDivider(dividerText: Texts.orSignUpWith.capitalize!),
              const SizedBox(height: Sizes.spaceBtwSections),

              /// Social Buttons
              const SocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}
