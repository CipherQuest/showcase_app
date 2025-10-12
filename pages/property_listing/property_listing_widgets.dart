import 'dart:io';
import 'dart:io' show File, Platform;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/image.dart' as core;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_detail_page.dart';
import 'package:zeerac_flutter/utils/app_utils.dart';

import '../../../../common/spaces_boxes.dart';

mixin PropertyListingWidgets {
  Widget getImageWidget({required dynamic onDelete, required File imageFile}) {
    return Stack(
      children: [
        Container(
          height: 140.h,
          width: 500.w,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: AppColor.greyColor,
              borderRadius: BorderRadius.circular(6)),
          child: core.Image.file(
            imageFile,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: -12,
          right: -10,
          child: IconButton(
              icon: const CircleAvatar(
                radius: 10,
                child: Icon(
                  Icons.clear,
                  color: AppColor.whiteColor,
                  size: 16,
                ),
              ),
              onPressed: onDelete),
        )
      ],
    );
  }

  Widget getVideoWidget({required dynamic onDelete, required File video}) {
    return Stack(
      children: [
        Container(
          height: 140.h,
          width: 500.w,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: AppColor.greyColor,
              borderRadius: BorderRadius.circular(6)),
          child: FutureBuilder<Uint8List?>(
              future: getVideoThumnail(video),
              builder: (context, snapShot) {
                if (snapShot.data != null) {
                  return core.Image.memory(
                    snapShot.data!,
                    fit: BoxFit.fill,
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
        Positioned(
          top: -12,
          right: -10,
          child: IconButton(
              icon: const CircleAvatar(
                radius: 10,
                child: Icon(
                  Icons.clear,
                  color: AppColor.whiteColor,
                  size: 16,
                ),
              ),
              onPressed: onDelete),
        )
      ],
    );
  }

  Future<Uint8List?> getVideoThumnail(File value) async {
    return await VideoThumbnail.thumbnailData(
      video: value.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
  }

  Widget propertiesWidget(PropertyModel result) {
    // String firstImage = result.thumbnail == null
    //     ? ApiConstants.imageNetworkPlaceHolder
    //     : "${ApiConstants.baseUrl}${result.thumbnail ?? ''}";

    return InkWell(
      onTap: () {
        Get.toNamed(PropertyDetailsPage.id, arguments: result);
      },
      child: Card(
        child: SizedBox(
          height: 260.h,
          child: Row(
            children: [
              ///images
              Expanded(
                flex: 4,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    NetworkPlainImage(
                      url: "firstImage",
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      color: AppColor.alphaGrey,
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${result.image.length}",
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const Icon(
                            Icons.image,
                            size: 12,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              hSpace,

              ///features and information
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              AppUtils.readTimestamp(
                                  DateTime.parse(result.createdAt!)
                                      .millisecondsSinceEpoch),
                              style: AppTextStyles.textStyleBoldBodyXSmall,
                            ),
                          ),
                          Row(
                            children: [
                              Text("Verified",
                                  style:
                                      AppTextStyles.textStyleNormalBodyXSmall),
                              hSpace,
                              const Icon(
                                Icons.verified_outlined,
                                size: 10,
                                color: AppColor.green,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    vSpace,
                    Flexible(
                      child: Text(
                        ("${result.currency ?? ''} ${result.price ?? ''}"),
                        style: AppTextStyles.textStyleBoldBodyMedium,
                      ),
                    ),
                    // Text(
                    //   result.loca ?? '',
                    //   style: AppTextStyles.textStyleBoldBodySmall,
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    Flexible(
                      child: Text(
                        result.purpose ?? '',
                        style: AppTextStyles.textStyleNormalBodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.bed, size: 12),
                              //  Text("${result.beds ?? 0}"),
                            ],
                          ),
                          SizedBox(width: 10.h),
                          Row(
                            children: [
                              const Icon(Icons.bathtub, size: 12),
                              Text("${result.bathrooms ?? 0}"),
                            ],
                          ),
                          SizedBox(width: 10.h),
                          Flexible(
                            child: Row(
                              children: [
                                const Icon(Icons.area_chart, size: 12),
                                // Flexible(
                                //     child: Text(
                                //         "${result.space ?? '0'} ${result.unit ?? ''}",
                                //         overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.h),
                          const Icon(Icons.favorite_border),
                        ],
                      ),
                    ),
                    vSpace,
                    Expanded(
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {}, child: const Text('Call')),
                          hSpace,
                          ElevatedButton(
                              onPressed: () {},
                              child: const Text(
                                'Message',
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getTextField(
      {required String hintText,
      String? title,
      required TextEditingController controller,
      String? validateText,
      bool validate = true,
      bool enabled = true,
      int minLines = 1,
      int maxLines = 2,
      Widget? suffixWidget,
      List<TextInputFormatter> inputFormatters = const [],
      TextInputType inputType = TextInputType.text,
      Color fillColor = AppColor.whiteColor,
      validator}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextField(
            controller: controller,
            enable: enabled,
            leftPadding: 0,
            rightPadding: 0,
            hintText: hintText,
            unfocusBorderColor: AppColor.greyColor,
            minLines: minLines,
            maxLines: maxLines,
            keyboardType: inputType,
            suffixIconWidet: suffixWidget,
            inputFormatters: inputFormatters,
            focusBorderColor: AppColor.primaryBlueColor,
            textColor: AppColor.blackColor,
            hintColor: AppColor.greyColor,
            fillColor: fillColor,
            validator: validator ??
                (String? value) => validate
                    ? (value!.trim().isEmpty
                        ? validateText ?? "Required"
                        : null)
                    : null),
      ],
    );
  }

  Widget getImageWidgetPlain(Rx<File?> file, {String? networkImage = ''}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        (file.value != null)
            ? core.Image.file(file.value!, fit: BoxFit.fill)
            : (networkImage != ''
                ? NetworkPlainImage(url: "${ApiConstants.baseUrl}$networkImage")
                : core.Image.asset(
                    'assets/images/place_your_image.png',
                    fit: BoxFit.fill,
                  )),
        Positioned(
          bottom: 5,
          right: 15,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: Colors.white,
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(2, 4),
                    color: Colors.black.withOpacity(
                      0.3,
                    ),
                    blurRadius: 3,
                  ),
                ]),
            child: const Padding(
              padding: EdgeInsets.all(2.0),
              child: Icon(Icons.add_a_photo, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget getBottomActionButtons(
      {required onForwardTap,
      bool showForward = true,
      required onBackWardTap,
      required RxInt index}) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                (index.value != 0)
                    ? InkWell(
                        onTap: onBackWardTap,
                        child: Container(
                          width: 500.w,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: AppColor.primaryBlueColor)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.navigate_before,
                                color: AppColor.primaryBlueColor,
                              ),
                              Text(
                                'Previous',
                                style: AppTextStyles.textStyleNormalBodyMedium
                                    .copyWith(color: AppColor.primaryBlueColor),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(width: 500.w),
                (showForward)
                    ? InkWell(
                        onTap: onForwardTap,
                        child: Container(
                          width: 500.w,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: AppColor.primaryBlueColor)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Next',
                                style: AppTextStyles.textStyleNormalBodyMedium
                                    .copyWith(color: AppColor.primaryBlueColor),
                              ),
                              const Icon(
                                Icons.navigate_next,
                                color: AppColor.primaryBlueColor,
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(width: 500.w),
              ],
            )));
  }

  Widget getTypeItemCard(
      {required String title,
      required String icon,
      required bool isSelected,
      required onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        width: 700.w,
        decoration: BoxDecoration(
            color: isSelected ? AppColor.primaryBlueColor : AppColor.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.greyColor)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: SvgViewer(
                  svgPath: icon,
                  width: 50,
                  height: 50,
                  color: isSelected
                      ? AppColor.whiteColor
                      : AppColor.primaryBlueColor),
            ),
            vSpace,
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.textStyleBoldBodyMedium.copyWith(
                  color: isSelected
                      ? AppColor.whiteColor
                      : AppColor.primaryBlueColor),
            )
          ],
        ),
      ),
    );
  }

  Widget getIncrementDecrementButtons(
      {required String title, required dynamic onChange, int? initalvalue}) {
    RxInt value = (initalvalue ?? 1).obs;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.textStyleBoldBodyMedium
                .copyWith(color: AppColor.primaryBlueColor),
          ),
        ),
        hSpace,
        Row(
          children: [
            InkWell(
              onTap: () {
                if (value.value > 0) {
                  value.value--;
                }
              },
              child: Container(
                padding: EdgeInsets.all(10.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.primaryBlueColor),
                child: Icon(
                  Icons.remove,
                  size: 70.r,
                  color: AppColor.whiteColor,
                ),
              ),
            ),
            Obx(() {
              onChange(value.value);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: AppColor.whiteColor),
                child: Text(
                  value.toString(),
                  style: AppTextStyles.textStyleBoldBodyMedium
                      .copyWith(color: AppColor.primaryBlueColor),
                ),
              );
            }),
            InkWell(
              onTap: () {
                value.value++;
              },
              child: Container(
                padding: EdgeInsets.all(10.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.primaryBlueColor),
                child: Icon(
                  Icons.add,
                  size: 70.r,
                  color: AppColor.whiteColor,
                ),
              ),
            ),
          ],
        ),
        hSpace,
      ],
    );
  }

  Widget getDropDownValues(
      {required String title,
      required List<String> values,
      String? initialValue,
      required dynamic onChange}) {
    return Row(
      children: [
        Expanded(
            child: Text(
          title,
          style: AppTextStyles.textStyleNormalLargeTitle
              .copyWith(color: AppColor.greyColor),
        )),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 6.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.greyColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: MySmallDropDown(
                initialValue: initialValue,
                isDense: true,
                items: values,
                onChange: onChange),
          ),
        )
      ],
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
