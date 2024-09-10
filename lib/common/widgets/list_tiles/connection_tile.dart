import 'package:contact_app/features/authentication/models/user.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../images/t_circular_image.dart';

class ConnectionTile extends StatelessWidget {
  const ConnectionTile({
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
      leading: CircularImage(padding: 0, image: imageUrl ?? "assets/content/user.png", width: 40, height: 40, fit: BoxFit.cover, isNetworkImage: imageUrl != null && jwtToken == null, jwtToken: imageUrl == null ? null : jwtToken,),
      title: Text("${user.firstname} ${user.lastname}", style: Theme.of(context).textTheme.headlineSmall!),
      trailing: trailingWidget,
    );
  }
}
