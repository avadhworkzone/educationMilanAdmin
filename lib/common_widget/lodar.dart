import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showLoadingDialog({
  @required BuildContext? context,
  Color? barrierColor,
}) {
  Future.delayed(const Duration(seconds: 0), () {
    showDialog(
        context: context!,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Lottie.asset('assets/images/commonLoader.json', height: 100),
          );
        });
  });
}

void hideLoadingDialog({BuildContext? context}) {
  Navigator.pop(context!, false);
}

class CommonLoader extends StatelessWidget {
  const CommonLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset('assets/images/commonLoader.json', height: 100));
  }
}
