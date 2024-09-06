import 'package:contact_app/features/authentication/controllers/auth_controller.dart';
import 'package:contact_app/features/authentication/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../utils/constants/colors.dart';
import '../views/forget_password.dart';

class LoginForm extends StatefulWidget {
  final AuthController authController;

  const LoginForm({
    super.key,
    required this.authController
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  bool loginPressed = false;
  bool hidePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.direct_right),
                  labelText: Texts.email,
                  errorStyle: TextStyle(fontSize: emailController.text.isEmpty ? 0 : Sizes.fontSizeSm),
              ),
              autovalidateMode: loginPressed ? AutovalidateMode.always : AutovalidateMode.disabled,
              validator: MultiValidator([
                RequiredValidator(errorText: ""),
                EmailValidator(errorText: "Enter valid email")
              ]).call,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            /// Password
            TextFormField(
              controller: passwordController,
              obscureText: hidePassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: Texts.password,
                errorStyle: TextStyle(fontSize: passwordController.text.isEmpty ? 0 : Sizes.fontSizeSm),
                suffixIcon: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  child: hidePassword ? const Icon(Iconsax.eye_slash) : const Icon(Iconsax.eye),
                ),
              ),
              autovalidateMode: loginPressed ? AutovalidateMode.always : AutovalidateMode.disabled,
              validator: MultiValidator([
                RequiredValidator(errorText: ""),
                MinLengthValidator(6, errorText: "At least 6 characters"),
                MaxLengthValidator(15, errorText: "Can't have more than 15 characters")
              ]).call,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields / 2),

            /// Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /// Forget Password
                TextButton(onPressed: () => Get.to(() => ForgetPassword(authController: widget.authController,)), child: const Text(Texts.forgetPassword)),
              ],
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            /// Sign In Button
            // TODO implement LogIn
            SizedBox(width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      if(!loginPressed) {
                        setState(() {
                          loginPressed = true;
                        });
                      }

                      if(loginFormKey.currentState!.validate()) {
                        bool successful = await widget.authController.login(emailController.text, passwordController.text);

                        if(!successful) {
                          const snackbar = SnackBar(
                            backgroundColor: CustomColors.error,
                            content: Text("Login failed! Wrong email or password.",
                              style: TextStyle(color: CustomColors.textWhite),),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Sizes.borderRadiusLg))),);
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }
                      }
                    },
                    child: const Text(Texts.signIn))),
            const SizedBox(height: Sizes.spaceBtwItems),

            /// Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(onPressed: () => Get.to(() => SignupView(authController: widget.authController,)), child: const Text(Texts.createAccount)),
            ),
          ],
        ),
      ),
    );
  }
}
