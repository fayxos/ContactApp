import 'package:contact_app/features/authentication/views/reset_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../common/widgets/appbar.dart';
import '../controllers/auth_controller.dart';

class ForgetPassword extends StatelessWidget {
  final AuthController authController;

  const ForgetPassword({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Custom Appbar
      appBar: CustomAppBar(actions: [IconButton(onPressed: () => Get.back(), icon: const Icon(CupertinoIcons.clear))]),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            Text(Texts.forgetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: Sizes.spaceBtwItems),
            Text(Texts.forgetPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: Sizes.spaceBtwSections * 2),

            /// Text field
            const TextField(
              decoration: InputDecoration(labelText: Texts.email, prefixIcon: Icon(Iconsax.direct_right)),
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(() => ResetPassword(authController: authController,)),
                child: const Text(Texts.submit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
