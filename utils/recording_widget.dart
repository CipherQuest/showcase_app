import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/recording_widget_controller.dart';

import '../common/common_widgets.dart';

class RecordingWidget extends StatelessWidget {
  final Null Function(String? s) onListenComplete;
  final Color iconColor;
  final Null Function() onStop;

  const RecordingWidget(
      {super.key,
      required this.onListenComplete,
      required this.onStop,
      this.iconColor = AppColor.blackColor});

  @override
  Widget build(BuildContext context) {
    return GetX<RecordingWidgetController>(
      init: RecordingWidgetController(),
      initState: ((state) {}),
      builder: ((controller) {
        return InkWell(
          onTap: () {
            controller.toogleListening(
                onStop: onStop,
                onListenComplete: (String? s) {
                  onListenComplete(s);
                });
          },
          child: AvatarGlow(
            endRadius: context.width * 0.04,
            glowColor: iconColor == AppColor.blackColor
                ? AppColor.greenColor
                : AppColor.whiteColor,
            duration: const Duration(milliseconds: 2000),
            repeat: true,
            showTwoGlows: true,
            animate: controller.isRecording.value,
            repeatPauseDuration: const Duration(milliseconds: 100),
            child: SvgViewer(
                svgPath: 'assets/icons_new/mic_ic.svg',
                height: double.infinity,
                color: iconColor),
          ),
        );
      }),
    );
  }
}
