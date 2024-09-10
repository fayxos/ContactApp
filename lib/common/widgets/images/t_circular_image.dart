import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class CircularImage extends StatelessWidget {
  const CircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    this.backgroundColor,
    required this.image,
    this.fit = BoxFit.cover,
    this.padding = Sizes.sm,
    this.isNetworkImage = false, this.jwtToken,
  });

  final BoxFit? fit;
  final String image;
  final String? jwtToken;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return jwtToken == null ? Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        // If image background color is null then switch it to light and dark mode color design.
        color: backgroundColor ?? (HelperFunctions.isDarkMode(context) ? CustomColors.black : CustomColors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Image(
          fit: fit,
          image: isNetworkImage ?
              NetworkImage(image) : AssetImage(image) as ImageProvider,
          color: overlayColor,
        ),
      ),
    ) : CachedNetworkImage(
      imageUrl: image,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: imageProvider, fit: fit),
        ),
      ),
      placeholder: (context, url) => Image(width: width, height: height, fit: fit, image: const AssetImage("assets/content/user.png") as ImageProvider),
      errorWidget: (context, url, error) => Image(width: width, height: height, fit: fit, image: const AssetImage("assets/content/user.png") as ImageProvider),
      httpHeaders: {
        "Authorization": "Bearer $jwtToken"
      },
    );
  }
}
