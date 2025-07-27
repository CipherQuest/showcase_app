import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/property_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/pages/home/recently_view_all_page.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

import '../../../../common/expandable_tile_model.dart';
import '../../../../common/loading_widget.dart';
import '../../../../common/spaces_boxes.dart';
import '../../../../dio_networking/app_apis.dart';
import '../../../../generated/assets.dart';
import '../../../../utils/app_alert_bottom_sheet.dart';
import '../../models/property_listing_model.dart' as pModel;
import '../home/widgets/property_item_widget.dart';

class PropertyDetailsPage extends GetView<PropertyDetailController> {
  PropertyDetailsPage({Key? key}) : super(key: key);
  static const id = '/PropertyDetailsPage';

  final pModel.PropertyModel? property = Get.arguments[0];
  BottomSheetType? bottomSheetType = Get.arguments[1];
  int index = Get.arguments[2];

  @override
  Widget build(BuildContext context) {
    String imageUrl = (property?.image.isNotEmpty ?? false)
        ? (property!.image.first.image!.toString())
        : ApiConstants.imageNetworkPlaceHolder;
    return GetX<PropertyDetailController>(initState: (state) {
      controller.initValues(property);
    }, builder: (_) {
      return Scaffold(
          appBar: myAppBar(
            title: 'Property Details',
            isTitleCenter: true,
            actions: [
              InkWell(
                onTap: () {
                  AppBottomSheets.showShareBottomSheet(
                      bottomSheetType: bottomSheetType,
                      propertyModel: property,
                      propertyIndex: index,
                      context: context);
                },
                child: const Icon(Icons.more_vert, color: AppColor.greyColor),
              ),
              hSpace,
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        expandedHeight: 500.h,
                        backgroundColor: AppColor.whiteColor,
                        floating: false,
                        pinned: false,
                        automaticallyImplyLeading: false,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            color: AppColor.primaryBlueColor,
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Positioned.fill(
                                  child: ShaderMask(
                                    shaderCallback: (rect) {
                                      return LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          AppColor.primaryBlueColor
                                              .withAlpha(20),
                                          AppColor.primaryBlueColor
                                              .withAlpha(10),
                                          AppColor.primaryBlueColor
                                              .withBlue(20),
                                        ],
                                      ).createShader(Rect.fromLTRB(
                                          0, 0, rect.width, rect.height));
                                    },
                                    blendMode: BlendMode.dstOut,
                                    child: NetworkPlainImage(url: imageUrl),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0, vertical: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              children: [
                                                const SvgViewer(
                                                  svgPath: Assets.iconsNewArea,
                                                  height: 10,
                                                  width: 12,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  "${property?.size ?? '-'} ${property?.unit ?? '-'}",
                                                  style: AppTextStyles
                                                      .textStyleNormalBodyXSmall
                                                      .copyWith(
                                                          color: AppColor
                                                              .whiteColor),
                                                ),
                                              ],
                                            ),
                                            hSpace,
                                            Row(
                                              children: [
                                                const SvgViewer(
                                                  svgPath: Assets.iconsNewBed,
                                                  height: 10,
                                                  width: 12,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  "${property?.bedrooms ?? '-'} ",
                                                  style: AppTextStyles
                                                      .textStyleNormalBodyXSmall
                                                      .copyWith(
                                                          color: AppColor
                                                              .whiteColor),
                                                )
                                              ],
                                            ),
                                            hSpace,
                                            Row(
                                              children: [
                                                const SvgViewer(
                                                  svgPath: Assets.iconsNewBatch,
                                                  height: 10,
                                                  width: 12,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  "${property?.bathrooms ?? '-'} ",
                                                  style: AppTextStyles
                                                      .textStyleNormalBodyXSmall
                                                      .copyWith(
                                                          color: AppColor
                                                              .whiteColor),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Flexible(
                                        child: Text(
                                          "${property?.title?.toUpperCase() ?? '-'} ",
                                          style: AppTextStyles
                                              .textStyleBoldBodyMedium
                                              .copyWith(
                                                  color: AppColor.whiteColor),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              "${property?.address ?? '-'} ",
                                              style: AppTextStyles
                                                  .textStyleNormalBodySmall
                                                  .copyWith(
                                                      color:
                                                          AppColor.whiteColor),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              "${property?.currency?.toUpperCase() ?? '-'} ${property?.price?.toUpperCase() ?? '-'}",
                                              style: AppTextStyles
                                                  .textStyleBoldBodyMedium
                                                  .copyWith(
                                                      color:
                                                          AppColor.whiteColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 18),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    if (property?.image.isNotEmpty ?? false)
                                      Container(
                                        height: 100.h,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: ListView.builder(
                                            itemCount: property?.image.length,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              String image = (property?.image
                                                      .elementAt(index)
                                                      .image ??
                                                  '');
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: NetworkPlainImage(
                                                  url: image,
                                                  height: 50,
                                                  width: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            }),
                                      ),

                                    ///description
                                    vSpace,
                                    Text(
                                      "Project Description",
                                      style: AppTextStyles
                                          .textStyleBoldSubTitleLarge
                                          .copyWith(
                                              color: AppColor.primaryBlueColor),
                                    ),
                                    vSpace,
                                    Text(
                                      property?.description ?? '',
                                      style: AppTextStyles
                                          .textStyleNormalBodySmall
                                          .copyWith(color: AppColor.greyColor),
                                    ),
                                    vSpace,
                                    const Divider(
                                      color: AppColor.greyColor,
                                      indent: 0,
                                      height: 1,
                                    ),
                                    ExpandAbleTile(
                                      model: ExpandableTileModel(
                                          title: 'Floor Plan',
                                          message: '',
                                          isExpanded: false),
                                      expandedWidgetChild: Container(
                                        alignment: Alignment.center,
                                        height: 400.h,
                                        padding: const EdgeInsets.all(2),
                                        child: ListView.builder(
                                            itemCount:
                                                property?.floorImage.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              String floorImage = (property
                                                      ?.floorImage
                                                      .elementAt(index)
                                                      .floorImage ??
                                                  '');
                                              return Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                width: 1400.w,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColor
                                                            .greyColor)),
                                                child: NetworkPlainImage(
                                                    url: floorImage,
                                                    fit: BoxFit.cover),
                                              );
                                            }),
                                      ),
                                    ),
                                    const Divider(
                                      color: AppColor.greyColor,
                                      indent: 0,
                                      height: 1,
                                    ),

                                    ExpandAbleTile(
                                        model: ExpandableTileModel(
                                            title: 'Construction Details',
                                            message: '',
                                            isExpanded: false),
                                        expandedWidgetChild: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Interior Details',
                                                    style: AppTextStyles
                                                        .textStyleBoldBodyMedium
                                                        .copyWith(
                                                            color: AppColor
                                                                .primaryBlueColor),
                                                  ),
                                                  vSpace,
                                                  vSpace,
                                                  keyValueRowWidget(
                                                      title: "Tv lounge:",
                                                      value: (property?.features
                                                                  ?.tvLounge ??
                                                              false)
                                                          ? 'Yes'
                                                          : 'No',
                                                      isGrey: false),
                                                  keyValueRowWidget(
                                                      title: "Store:",
                                                      value: (property?.features
                                                                  ?.storeRoom ??
                                                              false)
                                                          ? 'Yes'
                                                          : 'No',
                                                      isGrey: true),
                                                  keyValueRowWidget(
                                                      title: "Laundry:",
                                                      value: (property?.features
                                                                  ?.laundryRoom ??
                                                              false)
                                                          ? 'Yes'
                                                          : 'No',
                                                      isGrey: false),
                                                  keyValueRowWidget(
                                                      title: "Kitchen:",
                                                      value: (property?.features
                                                                  ?.kitchen ??
                                                              false)
                                                          ? 'Yes'
                                                          : 'No',
                                                      isGrey: true),
                                                  keyValueRowWidget(
                                                      title: "Balcony:",
                                                      value: (property?.features
                                                                  ?.balcony ??
                                                              false)
                                                          ? 'Yes'
                                                          : 'No',
                                                      isGrey: false),
                                                  keyValueRowWidget(
                                                      title: "Garden:",
                                                      value: (property?.features
                                                                  ?.garden ??
                                                              false)
                                                          ? 'Yes'
                                                          : 'No',
                                                      isGrey: true),
                                                ],
                                              ),
                                              vSpace,
                                              vSpace,
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Services',
                                                    style: AppTextStyles
                                                        .textStyleBoldBodyMedium
                                                        .copyWith(
                                                            color: AppColor
                                                                .primaryBlueColor),
                                                  ),
                                                  vSpace,
                                                  vSpace,
                                                  keyValueRowWidget(
                                                      title: "Electricity:",
                                                      value: ((property
                                                                      ?.services
                                                                      ?.electricity ??
                                                                  false)
                                                              ? 'Yes'
                                                              : 'No')
                                                          .toUpperCase(),
                                                      isGrey: false),
                                                  keyValueRowWidget(
                                                      title: "Gas:",
                                                      value: ((property
                                                                      ?.services
                                                                      ?.gas ??
                                                                  false)
                                                              ? 'Yes'
                                                              : 'No')
                                                          .toUpperCase(),
                                                      isGrey: true),
                                                  keyValueRowWidget(
                                                      title: "Water:",
                                                      value: ((property
                                                                      ?.services
                                                                      ?.water ??
                                                                  false)
                                                              ? 'Yes'
                                                              : 'No')
                                                          .toUpperCase(),
                                                      isGrey: false),
                                                  keyValueRowWidget(
                                                      title: "Maintenance:",
                                                      value: ((property
                                                                      ?.services
                                                                      ?.maintenance ??
                                                                  false)
                                                              ? 'Yes'
                                                              : 'No')
                                                          .toUpperCase(),
                                                      isGrey: true),
                                                  keyValueRowWidget(
                                                      title: "Security:",
                                                      value: ((property
                                                                      ?.services
                                                                      ?.security ??
                                                                  false)
                                                              ? 'Yes'
                                                              : 'No')
                                                          .toUpperCase(),
                                                      isGrey: false),
                                                  keyValueRowWidget(
                                                      title: "Sewerage:",
                                                      value: ((property
                                                                      ?.services
                                                                      ?.sewerage ??
                                                                  false)
                                                              ? 'Yes'
                                                              : 'No')
                                                          .toUpperCase(),
                                                      isGrey: true),
                                                ],
                                              ),
                                              vSpace,
                                              vSpace,
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Property Details',
                                                    style: AppTextStyles
                                                        .textStyleBoldBodyMedium
                                                        .copyWith(
                                                            color: AppColor
                                                                .primaryBlueColor),
                                                  ),
                                                  vSpace,
                                                  vSpace,
                                                  keyValueRowWidget(
                                                      title: "Heating:",
                                                      value: (property
                                                                  ?.constructionDetails
                                                                  ?.heating ??
                                                              'No')
                                                          .toUpperCase(),
                                                      isGrey: false),
                                                  keyValueRowWidget(
                                                      title: "Cooling:",
                                                      value: (property
                                                                  ?.constructionDetails
                                                                  ?.cooling ??
                                                              'No')
                                                          .toUpperCase(),
                                                      isGrey: true),
                                                  keyValueRowWidget(
                                                      title: "Furnished:",
                                                      value: (property
                                                                  ?.constructionDetails
                                                                  ?.furnished ??
                                                              'No')
                                                          .toUpperCase(),
                                                      isGrey: false),
                                                  keyValueRowWidget(
                                                      title: "Pool:",
                                                      value: (property
                                                                  ?.constructionDetails
                                                                  ?.pool ??
                                                              'No')
                                                          .toUpperCase(),
                                                      isGrey: true),
                                                  keyValueRowWidget(
                                                      title: "Appliances:",
                                                      value: (property
                                                                  ?.constructionDetails
                                                                  ?.appliances ??
                                                              'No')
                                                          .toUpperCase(),
                                                      isGrey: false),
                                                  keyValueRowWidget(
                                                      title: "Lawn:",
                                                      value: (property
                                                                  ?.constructionDetails
                                                                  ?.lawn ??
                                                              'No')
                                                          .toUpperCase(),
                                                      isGrey: true),
                                                  keyValueRowWidget(
                                                      title: "Garage:",
                                                      value: (property
                                                                  ?.constructionDetails
                                                                  ?.garage ??
                                                              'No')
                                                          .toUpperCase(),
                                                      isGrey: false),
                                                ],
                                              ),
                                              vSpace,
                                              vSpace,
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Style & Type',
                                                    style: AppTextStyles
                                                        .textStyleBoldBodyMedium
                                                        .copyWith(
                                                            color: AppColor
                                                                .primaryBlueColor),
                                                  ),
                                                  vSpace,
                                                  vSpace,
                                                  keyValueRowWidget(
                                                      title: "Home type:",
                                                      value: (property
                                                                  ?.constructionDetails
                                                                  ?.homeType ??
                                                              '-')
                                                          .toUpperCase(),
                                                      isGrey: true),
                                                  keyValueRowWidget(
                                                      title: "Sub type:",
                                                      value: (property
                                                                  ?.constructionDetails
                                                                  ?.propertySubtype ??
                                                              '-')
                                                          .toUpperCase(),
                                                      isGrey: false),
                                                  keyValueRowWidget(
                                                      title: "Condition:",
                                                      value: (property
                                                                  ?.constructionDetails
                                                                  ?.propertyCondition ??
                                                              '-')
                                                          .toUpperCase(),
                                                      isGrey: true),
                                                ],
                                              ),
                                              vSpace,
                                              vSpace,
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Condition',
                                                    style: AppTextStyles
                                                        .textStyleBoldBodyMedium
                                                        .copyWith(
                                                            color: AppColor
                                                                .primaryBlueColor),
                                                  ),
                                                  vSpace,
                                                  vSpace,
                                                  keyValueRowWidget(
                                                      title: "Material:",
                                                      value: (property
                                                                  ?.constructionDetails
                                                                  ?.materials ??
                                                              '-')
                                                          .toUpperCase(),
                                                      isGrey: true),
                                                  keyValueRowWidget(
                                                      title: "Year built:",
                                                      value: (property
                                                                  ?.constructionDetails
                                                                  ?.yearBuilt ??
                                                              '-')
                                                          .toUpperCase(),
                                                      isGrey: false),
                                                ],
                                              ),
                                              vSpace,
                                              vSpace,
                                            ])),
                                    const Divider(
                                      color: AppColor.greyColor,
                                      indent: 0,
                                      height: 1,
                                    ),

                                    ExpandAbleTile(
                                      model: ExpandableTileModel(
                                          title: 'Location',
                                          message: '',
                                          isExpanded: false),
                                      expandedWidgetChild: Container(
                                        alignment: Alignment.center,
                                        height: 400.h,
                                        padding: const EdgeInsets.all(2),
                                        child: Container(
                                            height: 300.h,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            child: Obx(
                                              () => GoogleMap(
                                                mapType: MapType.normal,
                                                myLocationEnabled: false,
                                                myLocationButtonEnabled: false,
                                                zoomGesturesEnabled: true,
                                                zoomControlsEnabled: false,
                                                initialCameraPosition:
                                                    controller.propertyPosition,
                                                markers:
                                                    controller.markers.value,
                                                onMapCreated:
                                                    controller.onMapCreated,
                                              ),
                                            )),
                                      ),
                                    ),
                                    const Divider(
                                      color: AppColor.greyColor,
                                      indent: 0,
                                      height: 1,
                                    ),
                                  ],
                                ),
                              ),
                              vSpace,
                              vSpace,
                              _recentlyViewedCard(context),
                              vSpace,
                              vSpace,
                            ],
                          ),
                        ),
                      ),
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
          ));
    });
  }

  Widget _recentlyViewedCard(BuildContext context) {
    return Container(
      color: AppColor.alphaGrey,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        //  crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Recently Viewed",
                  style: AppTextStyles.textStyleNormalBodyMedium),
              InkWell(
                onTap: () {
                  Get.to(
                    () => RecentlyViewAllPage(
                        propertiesList:
                            Get.find<HomeController>().recentlyViewedList),
                  );
                },
                child: Text("View all",
                    style: AppTextStyles.textStyleNormalBodyMedium),
              ),
            ],
          ),
          vSpace,
          SizedBox(
            height: context.height * 0.3,
            child: ListView.builder(
              itemCount: Get.find<HomeController>().recentlyViewedList.length,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return PropertyItemWidget(
                  isBlue: true,
                  propertyModel: Get.find<HomeController>()
                      .recentlyViewedList
                      .elementAt(index),
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
