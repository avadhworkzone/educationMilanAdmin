import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:ui' as ui;

Widget showShimmer({double? height}) {
  return Shimmer.fromColors(
    baseColor: ColorUtils.greyA7.withOpacity(0.2),
    highlightColor: Colors.grey.shade100,
    child: Container(
      color: Colors.white,
      height: height ?? 150,
      width: Get.width,
    ),
  );
}

class NetWorkOcToAssets extends StatelessWidget {
  const NetWorkOcToAssets({Key? key, required this.imgUrl}) : super(key: key);
  final String? imgUrl;

  @override
  Widget build(BuildContext context) {
    // if (kIsWeb) {
    //   ui.Pl.registerViewFactory(
    //     boxFit == null ? imgUrl : "contained${imgUrl}",
    //     (int _) => ImageElement()
    //       ..src = imgUrl
    //       ..style.objectFit = boxFit ?? "cover",
    //   );
    // }
    // print("image url==========>$imgUrl");
    // return HtmlElementView(
    //   viewType: imgUrl!,
    // );
    return OctoImage(
        image: NetworkImage("$imgUrl"),
        progressIndicatorBuilder: (context, progress) {
          return showShimmer();
        },
        errorBuilder: (context, error, stacktrace) {
          print("ERROR == $error");
          return Icon(
            Icons.error,
            color: Colors.red,
          );
        });
  }
}
