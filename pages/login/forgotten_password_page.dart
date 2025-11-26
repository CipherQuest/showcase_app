import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/utils/extension.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

import '../../../../common/common_widgets.dart';
import '../../../../common/loading_widget.dart';
import '../../../../common/styles.dart';
import '../../controllers/login_controller.dart';

class ForgottenPasswordPage extends GetView<LoginController> {
  ForgottenPasswordPage({Key? key}) : super(key: key);
  static const id = '/ForgottenPasswordPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      backgroundColor: AppColor.whiteColor,
      body: GetX<LoginController>(
          init: Get.put(LoginController()),
          initState: (state) {},
          builder: (_) {
            return SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Form(
                          key: controller.formKeyForgottenPassword,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Center(
                                    child: Image.asset(
                                      "assets/images/logo.png",
                                      height: 300,
                                      width: 300,
                                    ),
                                  ),
                                ],
                              ),
                              vSpace,
                              Text(
                                "Enter Your Email",
                                style: AppTextStyles.textStyleNormalLargeTitle
                                    .copyWith(color: AppColor.greyColor),
                              ),
                              vSpace,
                              vSpace,
                              MyTextField(
                                  controller: controller
                                      .forgottenPasswordEmailController,
                                  hintText: "Email",
                                  contentPadding: 20 /* context.height * 0.04*/,
                                  prefixIcon: "assets/icons/ic_mail.svg",
                                  focusBorderColor:
                                      AppColor.primaryBlueDarkColor,
                                  textColor: AppColor.blackColor,
                                  hintColor: AppColor.blackColor,
                                  fillColor: AppColor.alphaGrey,
                                  validator: (String? value) =>
                                      value!.toValidEmail()),
                              vSpace,
                              vSpace,
                              vSpace,
                              Button(
                                buttonText: "Send Reset Link".tr,
                                padding: 16 /*context.height * 0.04*/,
                                textColor: AppColor.whiteColor,
                                color: AppColor.primaryBlueDarkColor,
                                onTap: () async {
                                  if (controller
                                      .formKeyForgottenPassword.currentState!
                                      .validate()) {
                                    print('in');
                                    controller.forgottenPassword(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (controller.isLoading.isTrue)
                    LoadingWidget(
                      onCancel: () {
                        controller.isLoading.value = false;
                      },
                    ),
                ],
              ),
            );
          }),
    );
  }
}
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
# Contribution: Added comment
