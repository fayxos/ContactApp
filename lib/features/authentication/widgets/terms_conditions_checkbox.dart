import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';


class TermsAndConditionCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final bool registerPressed;

  const TermsAndConditionCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.registerPressed
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Wrap in a Sized box to remove extra padding
        SizedBox(width: 24,
            height: 24,
            child: Checkbox(
                value: isChecked,
                onChanged: (value) {
                  if (value != null) {
                    onChanged(value);
                  }
                }),
        ),
        const SizedBox(width: Sizes.md),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '${Texts.iAgreeTo} ', style: Theme.of(context).textTheme.bodySmall!.apply(color: registerPressed && !isChecked ? CustomColors.warning : null)),
              TextSpan(
                text: Texts.privacyPolicy,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: HelperFunctions.isDarkMode(context) ? Colors.white : CustomColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: HelperFunctions.isDarkMode(context) ? Colors.white : CustomColors.primary,
                ),
              ),
              TextSpan(text: ' ${Texts.and} ', style: Theme.of(context).textTheme.bodySmall!.apply(color: registerPressed && !isChecked ? CustomColors.warning : null)),
              TextSpan(
                text: Texts.termsOfUse,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: HelperFunctions.isDarkMode(context) ? Colors.white : CustomColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: HelperFunctions.isDarkMode(context) ? CustomColors.white : CustomColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}