import 'package:contact_app/features/authentication/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../widgets/form_divider.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';
import '../widgets/social_buttons.dart';

class LoginView extends StatelessWidget {
  final AuthController authController;

  const LoginView({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: SpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              ///  Header
              const LoginHeader(),

              /// Form
              LoginForm(authController: authController),

              /// Divider
              FormDivider(dividerText: Texts.orSignInWith.toUpperCase()),
              const SizedBox(height: Sizes.spaceBtwSections),

              /// Footer
              const SocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
