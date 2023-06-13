import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:zeerac_flutter/my_application.dart';

import '../common/styles.dart';

class AppPopUps {
  static bool isDialogShowing = true;

  static Future<bool> showConfirmDialog({
    onSubmit,
    required String title,
    required String message,
  }) async {
    return await showDialog(
        context: myContext!,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: AppTextStyles.textStyleBoldBodyMedium,
            ),
            content: Text(
              message,
              style: AppTextStyles.textStyleNormalBodyMedium,
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              ElevatedButton(
                child: const Text('Confirm'),
                onPressed: () {
                  onSubmit();
                },
              ),
            ],
          );
        });
  }

  static void showSnackBar(
      {required String message,
      required BuildContext context,
      Color color = Colors.red}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showDialogContent(
      {DialogType dialogType = DialogType.WARNING,
      String? title,
      onOkPress,
      onCancelPress,
      String? description,
      Widget? body}) {
    AwesomeDialog(
      context: myContext!,
      animType: AnimType.SCALE,
      dialogType: dialogType,
      body: body,
      title: title ?? '',
      desc: description ?? '',
      dismissOnTouchOutside: false,
      btnOkOnPress: onOkPress ??
          () {
            //Navigator.pop(myContext!);
          },
      btnCancelOnPress: onCancelPress ??
          () {
            // Get.back();
          },
    ).show();
  }

  dissmissDialog() {
    if (isDialogShowing) {
      navigatorKey.currentState!.pop();
    }
  }

  static showProgressDialog({BuildContext? context, bool? barrierDismissal}) {
    isDialogShowing = true;
    showDialog(
        useRootNavigator: false,
        useSafeArea: false,
        barrierDismissible: barrierDismissal ?? false,
        context: context!,
        builder: (context) => Center(
              child: Container(
                decoration: BoxDecoration(
                  //color: AppColors(..blackcardsBackground,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(25.r)),
                  boxShadow: [
                    BoxShadow(
                      //  color: AppColors().shadowColor,
                      color: Colors.transparent,
                      spreadRadius: 5.r,
                      blurRadius: 5.r,
                      offset: const Offset(3, 5), // changes position of shadow
                    ),
                  ],
                ),
                height: 120.h,
                width: 120.h,
                //  child: Lottie.asset(AssetsNames().loader),
                child: const CircularProgressIndicator(),
              ),
            )).then((value) {
      isDialogShowing = false;
    });
  }

  static Widget showSlidingPanel(
      {required BuildContext context,
      String? title,
      required Widget child,
      required Widget pannelWidget}) {
    SlidingUpPanel panel = SlidingUpPanel(
      maxHeight: context.height * 0.99,
      minHeight: context.height * 0.4,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14), topRight: Radius.circular(14)),
      panel: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: 10.h,
              decoration: BoxDecoration(
                  color: AppColor.greyColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(22)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(title ?? '',
                style: AppTextStyles.textStyleNormalLargeTitle),
          ),
          Expanded(child: pannelWidget),
        ],
      )),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: context.height * 0.6),
        child: child,
      ),
    );
    return panel;
  }
}
