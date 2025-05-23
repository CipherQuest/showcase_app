import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zeerac_flutter/common/app_constants.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/generated/assets.dart';
import 'package:zeerac_flutter/modules/users/controllers/dash_board_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/notification_controller.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/modules/users/pages/home/recently_view_all_page.dart';
import 'package:zeerac_flutter/modules/users/pages/home/widgets/most_popular_widget.dart';
import 'package:zeerac_flutter/modules/users/pages/home/widgets/property_item_widget.dart';
import 'package:zeerac_flutter/utils/app_alert_bottom_sheet.dart';
import 'package:zeerac_flutter/utils/app_utils.dart';
import 'package:zeerac_flutter/utils/recording_widget.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

import '../../../../common/loading_widget.dart';
import '../../../../common/spaces_boxes.dart';
import '../../../../dio_networking/app_apis.dart';
import '../../controllers/home_controller.dart';
import '../../models/companies_response_model.dart';
import '../company_listing/company_detail_page.dart';
import '../company_listing/company_listing_widgets.dart';

class HomePage extends GetView<HomeController> with CompanyWidgetsMixin {
  final EdgeInsets _leftRightPadding =
      const EdgeInsets.symmetric(vertical: 10, horizontal: 18);

  const HomePage({Key? key}) : super(key: key);
  static const id = '/HomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<HomeController>(
        initState: (state) {
          if (controller.onlyOnce) {
            controller.loadPropertiesListings(onComplete: (_) {});
          }

          // controller.refreshPage();
        },
        builder: (_) {
          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () {
                return controller.refreshPage();
              },
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller:
                        Get.find<DashBoardController>().frostedController ??
                            ScrollController(),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                AppColor.primaryBlueDarkColor,
                                AppColor.primaryBlueColor,
                                AppColor.primaryBlueColor,
                              ])),
                          padding: _leftRightPadding,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              vSpace,
                              if (UserDefaults.getUserSession() != null)
                                Text(
                                    'Hello ${UserDefaults.getUserSession()?.firstName ?? ''} ${UserDefaults.getUserSession()?.lastName ?? ''},',
                                    style: AppTextStyles
                                        .textStyleNormalLargeTitle
                                        .copyWith(color: AppColor.whiteColor)),
                              InkWell(
                                onTap: () {
                                  NotificationController
                                      notificationController = Get.find();
                                  notificationController.checkSocketStatus();
                                },
                                child: Text('How would you like to search?',
                                    style: AppTextStyles
                                        .textStyleNormalLargeTitle
                                        .copyWith(color: AppColor.whiteColor)),
                              ),
                              vSpace,
                              InkWell(
                                onTap: () {
                                  DashBoardController dashBoardController =
                                      Get.find();
                                  dashBoardController.tabController.index = 2;
                                  dashBoardController.currentPage.value = 2;
                                },
                                child: IgnorePointer(
                                  child: MyTextField(
                                    hintText:
                                        'Destination, Question, Query, etc.',
                                    borderRadius: 80,
                                    leftPadding: 0,
                                    rightPadding: 0,
                                    textColor: AppColor.whiteColor,
                                    hintColor: AppColor.whiteColor,
                                    focusBorderColor: AppColor.greenColor,
                                    unfocusBorderColor: AppColor.greenColor,
                                    controller: controller.searchController,
                                    suffixIconWidet: RecordingWidget(
                                        iconColor: AppColor.greenColor,
                                        onStop: () {
                                          print("stopped");
                                          if (controller.searchController.text
                                              .isNotEmpty) {
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
                              vSpace,
                            ],
                          ),
                        ),
                        vSpace,
                        Obx(
                          () {
                            controller.zoomedPage.value;
                            return CarouselSlider.builder(
                              itemCount: controller
                                  .dashBoardSliderPagesNames.entries
                                  .toList()
                                  .length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                      int pageViewIndex) =>
                                  InkWell(
                                onTap: () {
                                  controller.onDashboardSliderPageTap(
                                      pageName: controller
                                          .dashBoardSliderPagesNames.entries
                                          .elementAt(itemIndex)
                                          .key
                                          .toString());
                                },
                                child: AnimatedContainer(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  padding: const EdgeInsets.all(10),
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: controller.zoomedPage.value ==
                                                itemIndex
                                            ? [
                                                AppColor.greenColor
                                                    .withAlpha(100),
                                                AppColor.greenColor,
                                                AppColor.greenColor,
                                              ]
                                            : [
                                                AppColor.primaryBlueColor
                                                    .withAlpha(100),
                                                AppColor.primaryBlueColor,
                                                AppColor.primaryBlueColor,
                                              ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // const Spacer(),
                                      RotatedBox(
                                        quarterTurns: 3,
                                        child: Text(
                                            controller.dashBoardSliderPagesNames
                                                .entries
                                                .elementAt(itemIndex)
                                                .key
                                                .toString(),
                                            style: AppTextStyles
                                                .textStyleNormalLargeTitle
                                                .copyWith(
                                                    letterSpacing: 3,
                                                    color:
                                                        AppColor.whiteColor)),
                                      ),
                                      //  const Spacer(),
                                      Expanded(
                                        child: SvgViewer(
                                            svgPath: controller
                                                .dashBoardSliderPagesNames
                                                .entries
                                                .elementAt(itemIndex)
                                                .value
                                                .toString(),
                                            height: 90.h,
                                            color: AppColor.whiteColor),
                                      ),
                                      // const Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                              options: CarouselOptions(
                                height: context.isTablet
                                    ? context.height * 0.35
                                    : context.height * 0.25,
                                // padEnds: false,
                                //aspectRatio: 14 / 8,
                                reverse: true,
                                viewportFraction: 0.45,
                                enlargeCenterPage: true,
                                pageSnapping: true,
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.scale,
                                enableInfiniteScroll: true,
                                autoPlay: true,
                                initialPage: 0,
                                onPageChanged: (i, reason) {
                                  controller.zoomedPage.value = i;
                                },
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                              ),
                            );
                          },
                        ),
                        vSpace,
                        Padding(
                          padding: _leftRightPadding,
                          child: _downloadZphereAppCardWidget(),
                        ),
                        vSpace,
                        if (controller.mostPopuloarPropertiesList.isNotEmpty)
                          Padding(
                            padding: _leftRightPadding,
                            child: _mostPopularCard(context),
                          ),
                        if (controller.companiesList.isNotEmpty)
                          Column(
                            children: [
                              vSpace,
                              //TODO uncomment this
                              // Padding(
                              //   padding: _leftRightPadding,
                              //   child: _partnersViewsCard(),
                              // ),
                            ],
                          ),
                        if (controller.recentlyViewedList.isNotEmpty)
                          _recentlyViewedCard(context),
                        Padding(
                            padding: _leftRightPadding,
                            child: _landIsComfort()),
                        vSpace,
                        vSpace,
                        vSpace,
                        vSpace,
                        vSpace,
                      ],
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
            ),
          );
        },
      ),
    );
  }

  void showBottom(BuildContext context) {
    AppBottomSheets.showAppAlertBottomSheet(
        context: context,
        isFull: true,
        title: "Apply Filters",
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              vSpace,
              MyTextField(
                hintText: "City",
                unfocusBorderColor: AppColor.primaryBlueColor,
                focusBorderColor: AppColor.primaryBlueDarkColor,
                leftPadding: 0,
                rightPadding: 0,
              ),
            ],
          ),
        ));
  }

  _downloadZphereAppCardWidget() {
    return InkWell(
      onTap: () {
        ///goto donwload.

        AppUtils.launchUriUrl(AppConstants.zSphereUlr);
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.greenColor.withAlpha(100),
                AppColor.greenColor,
                AppColor.greenColor,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                vSpace,
                Text(
                  "Make Strides in Real Estate with Unbeatable Customer Experience.",
                  style: AppTextStyles.textStyleBoldBodyMedium
                      .copyWith(color: AppColor.primaryBlueColor),
                ),
                vSpace,
                vSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    img.Image.asset(
                      Assets.iconsNewZph,
                      width: 100,
                    ),
                    Text(
                      'Download Now!',
                      style: AppTextStyles.textStyleBoldBodySmall
                          .copyWith(color: AppColor.whiteColor),
                    )
                  ],
                ),
                vSpace,
              ],
            ),
          ), //declare your widget here
        ),
      ),
    );
  }

  Widget _recentlyViewedCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            AppColor.primaryBlueDarkColor.withOpacity(0.8),
            AppColor.primaryBlueColor,
            AppColor.primaryBlueColor,
          ])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        //  crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          vSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Recently Viewed",
                  style: AppTextStyles.textStyleNormalBodyMedium
                      .copyWith(color: AppColor.whiteColor)),
              InkWell(
                onTap: () {
                  Get.to(() => RecentlyViewAllPage(
                      propertiesList: controller.recentlyViewedList.value));
                },
                child: Text("View all",
                    style: AppTextStyles.textStyleNormalBodyMedium
                        .copyWith(color: AppColor.whiteColor)),
              ),
            ],
          ),
          vSpace,
          SizedBox(
            height: context.height * 0.3,
            child: ListView.builder(
              itemCount: controller.recentlyViewedList.length,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return PropertyItemWidget(
                  isBlue: false,
                  propertyModel: controller.recentlyViewedList.elementAt(index),
                  size: 335.h,
                );
              },
            ),
          ),
          vSpace,
        ],
      ),
    );
  }

  Widget _mostPopularCard(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vSpace,
        Row(
          children: [
            Expanded(
              child: Text("Most Popular",
                  style: AppTextStyles.textStyleBoldBodySmall
                      .copyWith(color: AppColor.primaryBlueColor)),
            ),
            InkWell(
              onTap: () {
                if (controller.propertyListingModel != null) {
                  // Get.toNamed(PropertyListingPage.id, arguments: [
                  //   controller.propertyListingModel,
                  //   PropertySort.trending.toString().toLowerCase()
                  // ]);

                  controller.onDashboardSliderPageTap(pageName: 'Properties');
                }
              },
              child: Text("View All ",
                  style: AppTextStyles.textStyleBoldBodySmall
                      .copyWith(color: AppColor.greyColor)),
            ),
          ],
        ),
        const Divider(color: AppColor.greyColor),
        SizedBox(
          height:
              context.isTablet ? context.height * 0.21 : context.height * 0.15,
          child: ListView.builder(
              itemCount: controller.mostPopuloarPropertiesList.length,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                PropertyModel propertyModel =
                    controller.mostPopuloarPropertiesList.elementAt(index);
                String imageUrl = (propertyModel.image.isNotEmpty)
                    ? (ApiConstants.baseUrl +
                        (propertyModel.image.first.image!.toString()))
                    : ApiConstants.imageNetworkPlaceHolder;
                return MostPopularWidget(
                  imageUrl: imageUrl,
                  propertyModel: propertyModel,
                  bottomSheetType: BottomSheetType.popularListing,
                  index: index,
                );
              }),
        ),
      ],
    );
  }

  //TODO uncomment partners card
  // Widget _partnersViewsCard() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 0),
  //     //  color: AppColor.alphaGrey,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Expanded(
  //               child: Text("Partners",
  //                   style: AppTextStyles.textStyleBoldBodySmall
  //                       .copyWith(color: AppColor.primaryBlueColor)),
  //             ),
  //             InkWell(
  //               onTap: () {
  //                 controller.onDashboardSliderPageTap(pageName: 'Partner');
  //                 // if (controller.companiesList.isNotEmpty) {
  //                 //   // Get.toNamed(CompanyListingPage.id,
  //                 //   //     arguments: [controller.companiesList]);
  //                 //   Get.toNamed(AgencySearchPageTab.id);
  //                 // }
  //               },
  //               child: Text("View All ",
  //                   style: AppTextStyles.textStyleBoldBodySmall
  //                       .copyWith(color: AppColor.greyColor)),
  //             ),
  //           ],
  //         ),
  //         const Divider(color: AppColor.greyColor),
  //         SizedBox(
  //             height: 160.h,
  //             child: ListView.builder(
  //               itemCount: controller.companiesList.length,
  //               key: UniqueKey(),
  //               physics: const ClampingScrollPhysics(),
  //               shrinkWrap: true,
  //               scrollDirection: Axis.horizontal,
  //               itemBuilder: (context, index) {
  //                 CompanyModel companyModel =
  //                     controller.companiesList.elementAt(index)!;
  //                 String logo = companyModel.companyLogo == null
  //                     ? ApiConstants.imageNetworkPlaceHolder
  //                     : "${ApiConstants.baseUrl}${companyModel.companyLogo ?? ''}";

  //                 return InkWell(
  //                   onTap: () {
  //                     Get.toNamed(CompanyDetailPage.id,
  //                         arguments: companyModel.id.toString());
  //                   },
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       NetworkPlainImage(
  //                         url: logo,
  //                         width: 800.w,
  //                         fit: BoxFit.contain,
  //                       ),

  //                       ///to remove last vertical border in list..
  //                       (controller.companiesList.length - 1 == index)
  //                           ? const IgnorePointer()
  //                           : const VerticalDivider(color: AppColor.greyColor)
  //                     ],
  //                   ),
  //                 );
  //               },
  //             )),
  //         const Divider(color: AppColor.greyColor),
  //       ],
  //     ),
  //   );
  // }

  Widget _landIsComfort() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      //  color: AppColor.alphaGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Row(
                children: [
                  Text("Land is",
                      style: AppTextStyles.textStyleBoldSubTitleLarge.copyWith(
                          fontSize: 130.sp,
                          letterSpacing: 1,
                          color: AppColor.primaryBlueColor)),
                  const SizedBox(width: 6),
                  Text(
                    "Comfort",
                    style: AppTextStyles.textStyleBoldSubTitleLarge.copyWith(
                      color: AppColor.greenColor,
                      fontSize: 130.sp,
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 60),
                  child: Text(
                    "FEATURES",
                    style: AppTextStyles.textStyleBoldSubTitleLarge.copyWith(
                      color: AppColor.greyColor.withAlpha(20),
                      fontSize: 180.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 250.h,
            child: ListView.builder(
              itemCount: 10,
              key: UniqueKey(),
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    img.Image.asset(
                      key: UniqueKey(),
                      'assets/images_new/block_chain_img.png',
                    ),
                    const SizedBox(width: 3),
                  ],
                );
              },
            ),
          ),
        ],
      ),
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
