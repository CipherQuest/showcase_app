import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/controllers/partner_search_tab_controller.dart';
import 'package:zeerac_flutter/modules/users/models/companies_response_model.dart';
import 'package:zeerac_flutter/utils/recording_widget.dart';

import '../../../../common/loading_widget.dart';
import '../../../../common/spaces_boxes.dart';
import '../../../../common/styles.dart';
import '../../../../generated/assets.dart';
import '../company_listing/company_detail_page.dart';

class PartnerSearchPageTab extends GetView<PartnerSearchTabController> {
  const PartnerSearchPageTab({Key? key}) : super(key: key);
  static const id = '/PartnerSearchPageTab';

  @override
  Widget build(BuildContext context) {
    return GetX<PartnerSearchTabController>(
      initState: (state) {
        controller.searchController.clear();
        controller.searchController.addListener(() {
          controller.searchFromList();
        });
      },
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: MyTextField(
                                hintText: 'Destination, Question, Query, etc.',
                                borderRadius: 80,
                                leftPadding: 0,
                                rightPadding: 0,
                                controller: controller.searchController,
                                textColor: AppColor.blackColor,
                                focusBorderColor: AppColor.blackColor,
                                unfocusBorderColor: AppColor.blackColor,
                                suffixIconWidet: RecordingWidget(
                                    iconColor: AppColor.blackColor,
                                    onStop: () {
                                      print("stopped");
                                      if (controller
                                          .searchController.text.isNotEmpty) {
                                        print("doing searching......");
                                      }
                                    },
                                    onListenComplete: (String? s) {
                                      print(s?.toString());
                                      if (s != null) {
                                        controller.searchController.text =
                                            s.toString();
                                      }
                                    }),
                              ),
                            ),
                          ),

                          ///not being used for now
                          // hSpace,
                          // InkWell(
                          //   onTap: () {
                          //     controller.filterVisible.toggle();
                          //   },
                          //   child: SvgViewer(
                          //     svgPath: Assets.iconsNewFilterIcBlck,
                          //     height: 55.h,
                          //   ),
                          // ),
                        ],
                      ),
                      Visibility(
                        visible: controller.filterVisible.value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          height: 80.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(1)),
                        ),
                      ),
                      vSpace,
                      Text(
                        "Displaying ${controller.filteredItemList.length} Partners",
                        style: AppTextStyles.textStyleNormalBodyMedium
                            .copyWith(color: AppColor.greyColor),
                      ),
                      vSpace,
                      Expanded(
                        child: NotificationListener(
                          onNotification: controller.onScrollNotification,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.filteredItemList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              CompanyModel companyModel =
                                  controller.companiesList.elementAt(index)!;
                              String logo = companyModel.companyLogo == null
                                  ? ApiConstants.imageNetworkPlaceHolder
                                  : "${ApiConstants.baseUrl}${companyModel.companyLogo ?? ''}";

                              return InkWell(
                                onTap: () {
                                  Get.toNamed(CompanyDetailPage.id,
                                      arguments: companyModel.id.toString());
                                },
                                child: Card(
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    child: NetworkPlainImage(
                                      url: logo,
                                      width: 600.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      vSpace,
                      vSpace,
                      vSpace,
                      vSpace,
                      vSpace,
                      vSpace,
                      vSpace,
                    ],
                  ),
                )),
                if (controller.isLoading.isTrue)
                  LoadingWidget(
                    onCancel: () {
                      controller.isLoading.value = false;
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
