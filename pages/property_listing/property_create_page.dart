import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/property_create_controller.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_listing_widgets.dart';

import '../../../../common/common_widgets.dart';
import '../../../../common/loading_widget.dart';
import '../../../../common/spaces_boxes.dart';
import '../../../../utils/app_pop_ups.dart';

class PropertyCreatePage extends GetView<PropertyCreateController>
    with PropertyListingWidgets {
  PropertyCreatePage({Key? key}) : super(key: key);
  static const id = '/PropertyCreatePage';
  final String propertyPurpose = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return controller.goBackWard();
      },
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: GetX<PropertyCreateController>(
          initState: (state) {
            // controller.clearValues();
            controller.selectedPurpose.value = propertyPurpose;
          },
          builder: (_) {
            return SafeArea(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 120.h,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Text(
                              'Add Listing',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.textStyleNormalLargeTitle
                                  .copyWith(
                                      color: AppColor.primaryBlueColor,
                                      fontSize: 138.sp),
                            ),
                          ),
                          Positioned(
                            left: -750.w,
                            top: 30.h,
                            child: SvgViewer(
                              svgPath: 'assets/icons_new/blue_lines_left.svg',
                              height: 80.h,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                AppPopUps.showDialogContent(
                                  description: 'Are you sure to cancel?',
                                  onOkPress: () {
                                    //controller.clearValues();
                                    // controller.currentViewIndex.value = 0;
                                    return Get.back();
                                  },
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Entypo.cancel,
                                  color: AppColor.primaryBlueColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 80.h,
                        width: context.width,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                const Spacer(),
                                Container(
                                  height: 1,
                                  alignment: Alignment.center,
                                  color: AppColor.greyColor,
                                ),
                                const Expanded(flex: 3, child: IgnorePointer())
                              ],
                            ),
                            ScrollablePositionedList.builder(
                                itemScrollController:
                                    controller.stepperController,
                                itemCount: controller.viewsList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var isSelected =
                                      controller.currentViewIndex.value ==
                                          index;
                                  return SizedBox(
                                    width: 500.w,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        isSelected
                                            ? Expanded(
                                                child: InkWell(
                                                onTap: () {
                                                  // controller.stepperController
                                                  //     .scrollTo(
                                                  //         index: index,
                                                  //         duration:
                                                  //             const Duration(
                                                  //                 seconds: 1),
                                                  //         curve: Curves
                                                  //             .easeInOutCubic);
                                                  //
                                                  // controller.currentViewIndex
                                                  //     .value = index;
                                                },
                                                child: const CircleAvatar(
                                                  backgroundColor:
                                                      AppColor.primaryBlueColor,
                                                  child: Icon(
                                                    Icons.play_arrow,
                                                    color: AppColor.whiteColor,
                                                    size: 14,
                                                  ),
                                                ),
                                              ))
                                            : Expanded(
                                                child: InkWell(
                                                onTap: () {
                                                  // controller.currentViewIndex
                                                  //     .value = index;
                                                },
                                                child: const CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Icon(
                                                    Icons.play_arrow,
                                                    color: AppColor
                                                        .primaryBlueColor,
                                                    size: 16,
                                                  ),
                                                ),
                                              )),
                                        Expanded(
                                          child: Text(
                                            controller.viewsList.keys
                                                .toList()
                                                .elementAt(index),
                                            style: AppTextStyles
                                                .textStyleNormalBodyMedium
                                                .copyWith(
                                                    fontSize: isSelected
                                                        ? 80.sp
                                                        : 60.sp,
                                                    color: isSelected
                                                        ? AppColor.greenColor
                                                        : AppColor.greyColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                      vSpace,
                      Expanded(
                        child: IndexedStack(
                          index: controller.currentViewIndex.value,
                          children: controller.viewsList.values.toList(),
                        ),
                      ),
                    ],
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
          },
        ),
      ),
    );
  }

  getCurrentView() {
    return controller.viewsList.values
        .toList()[controller.currentViewIndex.value];
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
