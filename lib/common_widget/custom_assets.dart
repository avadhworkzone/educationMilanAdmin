import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LocalAssets extends StatelessWidget {
  const LocalAssets(
      {Key? key,
      required this.imagePath,
      this.height,
      this.width,
      this.imgColor,
      this.scaleSize})
      : super(key: key);
  final String imagePath;
  final double? height, width, scaleSize;
  final Color? imgColor;
  @override
  Widget build(BuildContext context) {
    return imagePath.split('.').last != 'svg'
        ? Image.asset(
            imagePath,
            height: height,
            width: width,
            scale: scaleSize,
            color: imgColor,
          )
        : SvgPicture.asset(
            imagePath,
            height: height,
            width: width,
            color: imgColor,
          );
  }
}
