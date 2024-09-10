import 'package:contact_app/features/authentication/models/user.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../images/t_circular_image.dart';

class UserProfileTile extends StatelessWidget {
  const UserProfileTile({
    super.key,
    required this.user,
    required this.onPressed, this.imageUrl, this.jwtToken,
    this.trailingWidget
  });

  final User user;
  final String? imageUrl;
  final String? jwtToken;
  final Widget? trailingWidget;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircularImage(padding: 0, image: imageUrl ?? "assets/content/user.png", width: 50, height: 50, fit: BoxFit.cover, isNetworkImage: imageUrl != null && jwtToken == null, jwtToken: imageUrl == null ? null : jwtToken,),
      title: Text("${user.firstname} ${user.lastname}", style: Theme.of(context).textTheme.headlineSmall!.apply(color: CustomColors.white)),
      subtitle: Text(user.email!, style: Theme.of(context).textTheme.bodyMedium!.apply(color: CustomColors.white)),
      trailing: trailingWidget,
    );
  }
}
