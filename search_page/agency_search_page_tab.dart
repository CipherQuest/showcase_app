import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/models/agency_model.dart';
import 'package:zeerac_flutter/modules/users/models/agents_listing_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/agency_listing/agency_detail_page.dart';

import '../../../../common/loading_widget.dart';
import '../../../../dio_networking/app_apis.dart';
import '../../../../generated/assets.dart';
import '../../../../utils/recording_widget.dart';
import '../../controllers/agency_search_tab_controller.dart';
import '../agents_listing/agent_detail_page.dart';

class AgencySearchPageTab extends GetView<AgencySearchTabController> {
  const AgencySearchPageTab({Key? key}) : super(key: key);
  static const id = '/AgencySearchPageTab';

  @override
  Widget build(BuildContext context) {
    return GetX<AgencySearchTabController>(
      initState: (state) {
        if (controller.onlyOnce) {
          controller.reset();
          controller.loadAgency(
              onComplete: (AgencyResponseModel agencyResponseModel) {});
        }
        // controller.reset();
        //controller.getFavoritedAgencies();
        //controller.itemScrollController.addListener(controller.scrollListener);
        // controller.searchController.addListener(() {
        //   if (controller.searchController.text.isEmpty) {
        //     controller.clearFilters();
        //   }
        // });
        // controller.loadAgency(
        //     onComplete: (AgencyResponseModel agencyResponseModel) {});
      },
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                    child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: MyTextField(
                                  controller: controller.searchController,
                                  hintText:
                                      'Destination, Question, Query, etc.',
                                  borderRadius: 80,
                                  leftPadding: 0,
                                  rightPadding: 0,
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
                                  onFieldSubmit: (val) {
                                    controller.reset();
                                    controller.hasSearchedByTyping = true;
                                    controller.loadAgency(
                                        onComplete: (AgencyResponseModel
                                            agencyResponseModel) {});
                                  },
                                ),
                              ),
                            ),
                            hSpace,
                            InkWell(
                              onTap: () {
                                controller.filterVisible.toggle();
                              },
                              child: SvgViewer(
                                svgPath: controller.filterVisible.value == false
                                    ? Assets.iconsNewFilterIcBlck
                                    : Assets.iconsNewFilterIcBlue,
                                height: 55.h,
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: controller.filterVisible.value,
                          child: Card(
                            elevation: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 4),
                              height: 190.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  //color: Colors.red,
                                  borderRadius: BorderRadius.circular(1)),
                              child: Column(children: [
                                Align(
                                    alignment: Alignment.topRight,
                                    //TODO change the icon as per figma design
                                    child: InkWell(
                                        onTap: () {
                                          controller.clearFilters();
                                          // FocusScope.of(context)
                                          //     .requestFocus(FocusNode());
                                        },
                                        child: Icon(Icons.close))),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: MyTextField(
                                      controller:
                                          controller.cityFilterController,
                                      hintText: 'City',
                                      focusBorderColor:
                                          AppColor.primaryBlueColor,
                                      unfocusBorderColor: Colors.grey,
                                    )),
                                    Expanded(
                                        child: MyTextField(
                                      controller:
                                          controller.areaFilterController,
                                      hintText: 'Area',
                                      focusBorderColor:
                                          AppColor.primaryBlueColor,
                                      unfocusBorderColor: Colors.grey,
                                    ))
                                  ],
                                ),
                                vSpace,
                                InkWell(
                                  onTap: () {
                                    if (controller.cityFilterController.text
                                            .isNotEmpty ||
                                        controller.areaFilterController.text
                                            .isNotEmpty) {
                                      controller.reset();
                                      controller.loadAgency(
                                          onComplete: (AgencyResponseModel
                                              agencyResponseModel) {});
                                    }
                                  },
                                  child: Container(
                                    height: 50.h,
                                    width: 600.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                      color: AppColor.primaryBlueColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Apply',
                                        style: AppTextStyles
                                            .textStyleNormalBodyMedium
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ),
                        ),
                        vSpace,
                        Text(
                          "Displaying ${controller.agenciesList.length} Agencies",
                          style: AppTextStyles.textStyleNormalBodyMedium
                              .copyWith(color: AppColor.greyColor),
                        ),
                        vSpace,
                        Obx(
                          () => Container(
                            height: controller.filterVisible.value == true
                                ? context.height * 0.34
                                : context.height * 0.55,
                            child: NotificationListener(
                              onNotification: controller.onScrollNotification,
                              child: ListView.builder(
                                  controller: controller.itemScrollController,
                                  shrinkWrap: true,
                                  itemCount: controller.agenciesList.length,
                                  //physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return agencyListingWidget(
                                      controller.agenciesList.elementAt(index)
                                          as AgencyModel,
                                      index,
                                    );
                                  }),
                            ),
                          ),
                        ),
                        // vSpace,
                        // vSpace,
                        // vSpace,
                        // vSpace,
                        // vSpace,
                        // vSpace,
                      ],
                    ),
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

Widget agencyListingWidget(AgencyModel result, int indexOfAgency) {
  // String firstImage = ((result.photo ?? '').isEmpty)
  //     ? ApiConstants.imageNetworkPlaceHolder
  //     : "${ApiConstants.baseUrl}${result.photo ?? ''}";

  return InkWell(
    onTap: () {
      print('index is $indexOfAgency');
      Get.toNamed(AgencyDetailPage.id,
          arguments: [result, indexOfAgency, false]);
    },
    child: Card(
        child: ListTile(
      // onTap: () {
      //   ///send agent object to next page.....
      //   Get.toNamed(AgentDetailPage.id, arguments: null /*agent*/);
      // },
      contentPadding: const EdgeInsets.all(8),
      leading: Container(
        height: 50.h,
        width: 50.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: FadeInImage(
            placeholder: AssetImage('assets/images/place_your_image.png'),
            image: CachedNetworkImageProvider('${result.companyLogo}'),
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(ApiConstants.imagePlaceHolder);
            },
          ),
        ),
      ),
      title: Text(
        " ${result.companyName ?? ''}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.textStyleNormalBodyMedium
            .copyWith(color: AppColor.primaryBlueColor),
      ),
      subtitle: Text(
        " ${result.companyAddress ?? ''}",
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.textStyleNormalBodyXSmall
            .copyWith(color: AppColor.primaryBlueColor),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${result.noOfEmployees ?? '0'}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.textStyleNormalBodyMedium
                .copyWith(color: AppColor.primaryBlueColor),
          ),
          Text(
            "No Of Employees",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.textStyleNormalBodyXSmall
                .copyWith(color: AppColor.primaryBlueColor),
          ),
          // Text(
          //   result.company == ""
          //       ? "Private Agent"
          //       : "Company : ${result.company}",
          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          //   style: AppTextStyles.textStyleNormalBodyXSmall
          //       .copyWith(color: AppColor.greenColor),
          // ),
        ],
      ),
    )),
  );
}
