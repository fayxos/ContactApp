import 'package:contact_app/features/authentication/controllers/auth_controller.dart';
import 'package:contact_app/features/authentication/views/login.dart';
import 'package:contact_app/features/authentication/widgets/terms_conditions_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../views/verify_email.dart';

class SignupForm extends StatefulWidget {
  final AuthController authController;

  const SignupForm({
    super.key,
    required this.authController
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  bool registerPressed = false;
  bool hidePassword = true;
  bool isTermsChecked = false;

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void updateIsTermsChecked(bool value) {
    setState(() {
      isTermsChecked = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: registerFormKey,
      child: Column(
        children: [
          /// First & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: firstnameController,
                  autovalidateMode: registerPressed ? AutovalidateMode.always : AutovalidateMode.disabled,
                  expands: false,
                  decoration: InputDecoration(
                      labelText: Texts.firstName,
                      prefixIcon: const Icon(Iconsax.user),
                      errorStyle: TextStyle(fontSize: firstnameController.text.isEmpty ? 0 : Sizes.fontSizeSm),),
                  validator: MultiValidator([
                    RequiredValidator(errorText: ""),
                    MinLengthValidator(2, errorText: 'At least 2 characters'),
                    MaxLengthValidator(50, errorText: 'Can\'t be more than 50 characters'),
                    PatternValidator(
                      r"^[a-zA-ZÀ-ÖØ-öø-ÿ'\- ]+$",
                      errorText: 'Invalid characters',
                    ),
                  ]).call,
                  onChanged: (_) => setState(() { }),
                ),
              ),
              const SizedBox(width: Sizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: lastnameController,
                  autovalidateMode: registerPressed ? AutovalidateMode.always : AutovalidateMode.disabled,
                  expands: false,
                  decoration: InputDecoration(
                      labelText: Texts.lastName,
                      prefixIcon: const Icon(Iconsax.user),
                    errorStyle: TextStyle(fontSize: lastnameController.text.isEmpty ? 0 : Sizes.fontSizeSm),),
                  validator: MultiValidator([
                  RequiredValidator(errorText: ""),
                  MinLengthValidator(2, errorText: 'At least 2 characters'),
                  MaxLengthValidator(50, errorText: 'Can\'t be more than 50 characters'),
                  PatternValidator(
                    r"^[a-zA-ZÀ-ÖØ-öø-ÿ'\- ]+$",
                    errorText: 'Invalid characters',
                  )]).call,
                  onChanged: (_) => setState(() { }),
                ),
              ),
            ],
          ),
          const SizedBox(height: Sizes.spaceBtwInputFields),

          /// Email
          TextFormField(
            controller: emailController,
            autovalidateMode: registerPressed ? AutovalidateMode.always : AutovalidateMode.disabled,
            decoration: InputDecoration(
                labelText: Texts.email,
                prefixIcon: const Icon(Iconsax.direct),
              errorStyle: TextStyle(fontSize: emailController.text.isEmpty ? 0 : Sizes.fontSizeSm),),
            validator: MultiValidator([
              RequiredValidator(errorText: ""),
              EmailValidator(errorText: "Enter valid email")
            ]).call,
            onChanged: (_) => setState(() { }),
          ),
          const SizedBox(height: Sizes.spaceBtwInputFields),

          /// Phone Number
          // TextFormField(
          //   decoration: const InputDecoration(labelText: Texts.phoneNo, prefixIcon: Icon(Iconsax.call)),
          // ),
          // const SizedBox(height: Sizes.spaceBtwInputFields),

          /// Password
          TextFormField(
            controller: passwordController,
            autovalidateMode: registerPressed ? AutovalidateMode.always : AutovalidateMode.disabled,
            obscureText: true,
            decoration: InputDecoration(
              labelText: Texts.password,
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                child: hidePassword ? const Icon(Iconsax.eye_slash) : const Icon(Iconsax.eye),
              ),
              errorStyle: TextStyle(fontSize: passwordController.text.isEmpty ? 0 : Sizes.fontSizeSm),
            ),
            validator: MultiValidator([
              RequiredValidator(errorText: ""),
              MinLengthValidator(6, errorText: "At least 6 characters"),
              MaxLengthValidator(15, errorText: "Can't have more than 15 characters")
            ]).call,
            onChanged: (_) => setState(() { }),
          ),
          const SizedBox(height: Sizes.spaceBtwSections),

          /// Terms&Conditions Checkbox
          TermsAndConditionCheckbox(isChecked: isTermsChecked, onChanged: updateIsTermsChecked, registerPressed: registerPressed),
          const SizedBox(height: Sizes.spaceBtwSections),

          /// Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if(!registerPressed) {
                  setState(() {
                    registerPressed = true;
                  });
                }

                if(registerFormKey.currentState!.validate() && !isTermsChecked) {
                  const snackbar = SnackBar(
                    backgroundColor: CustomColors.warning,
                    content: Text("Please agree to Privacy Policy and Terms of use",
                      style: TextStyle(color: CustomColors.textWhite),),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Sizes.borderRadiusLg))),);
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                } else if(registerFormKey.currentState!.validate()) {
                  bool successful = await widget.authController.register(firstnameController.text, lastnameController.text, emailController.text, passwordController.text);

                  if(!successful) {
                    const snackbar = SnackBar(
                      backgroundColor: CustomColors.error,
                      content: Text("Registration Failed! Email already used.",
                        style: TextStyle(color: CustomColors.textWhite),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Sizes.borderRadiusLg))),);
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  } else {
                    Get.to(() => VerifyEmailView(authController: widget.authController,));
                  }
                }
              },
              child: const Text(Texts.createAccount),
            ),
          ),
          const SizedBox(height: Sizes.spaceBtwItems),

          /// Create Account Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(onPressed: () => Get.to(() => LoginView(authController: widget.authController,)), child: const Text(Texts.signIn)),
          ),
        ],
      ),
    );
  }
}
