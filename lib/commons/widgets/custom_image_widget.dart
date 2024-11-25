import 'package:cached_network_image/cached_network_image.dart';
import 'package:app_delivary_task/utill/images.dart';
import 'package:flutter/material.dart';

class CustomImageWidget extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final BoxFit fit;
  final String placeholder;
  const CustomImageWidget({Key? key, required this.image, required this.height, required this.width, this.fit = BoxFit.cover, this.placeholder = Images.placeholder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: CachedNetworkImage(
        imageUrl: image, height: height, width: width, fit: fit,
        placeholder: (context, url) => Image.asset(placeholder, height: height, width: width, fit: fit),
        errorWidget: (context, url, error) => Image.asset(placeholder, height: height, width: width, fit: fit),
      ),
    );
  }
}
