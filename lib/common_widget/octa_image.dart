import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';
import 'package:responsivedashboard/utils/color_utils.dart';
import 'package:responsivedashboard/utils/network_image_helper.dart';
import 'package:shimmer/shimmer.dart';

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
    final normalizedUrl = firstImageUrl(imgUrl);

    if (normalizedUrl == null) {
      return Container(
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }

    if (kIsWeb) {
      // For web - simple Image.network (works when CORS is properly configured)
      return Image.network(
        normalizedUrl,
        fit: BoxFit.cover,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Image Load Error: $error');
          debugPrint('URL: $normalizedUrl');
          return Container(
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
        },
      );
    }

    // For mobile/Android/iOS - OctoImage for better performance
    return OctoImage(
      image: NetworkImage(normalizedUrl),
      progressIndicatorBuilder: (context, progress) {
        return showShimmer();
      },
      errorBuilder: (context, error, stacktrace) {
        debugPrint('OctoImage Error: $error');
        return Container(
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );
  }
}
