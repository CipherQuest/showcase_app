import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:range_slider_flutter/range_slider_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:zeerac_flutter/common/app_constants.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/generated/assets.dart';
import 'package:zeerac_flutter/modules/users/controllers/property_search_tab_controller.dart';
import 'package:zeerac_flutter/utils/app_alert_bottom_sheet.dart';
import 'package:zeerac_flutter/utils/recording_widget.dart';

import '../../../../common/loading_widget.dart';
import '../../../../utils/app_pop_ups.dart';
import '../../models/property_listing_model.dart';
import '../home/widgets/most_popular_widget.dart';

class PropertiesSearchPageTab extends GetView<PropertySearchTabController> {
  const PropertiesSearchPageTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<PropertySearchTabController>(
      initState: (_) {
        if (controller.onlyOnce == true) {
          controller.resetListResults();
          controller.loadListings(
              onComplete:
                  (PropertyListingResponseModel propertyListingModel) {},
              onlyOnce: true);
          controller.onlyOnce = false;
        }
      },
      builder: (logic) {
        return Stack(
          children: [
            logic.isSearchingResultFound.value
                ? _propertiesFoundUi(context)

                ///when result is not found make search...
                : _resultFilterUi(context),
            if (controller.isLoading.isTrue)
              LoadingWidget(
                onCancel: () {
                  controller.isLoading.value = false;
                },
              ),
          ],
        );
      },
    );
  }

  Widget getTypeItemCard(
      {required String title,
      required String icon,
      required bool isSelected,
      required onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.only(right: 20, top: 20, bottom: 20, left: 20),
        margin: const EdgeInsets.only(right: 20),
        width: 700.w,
        decoration: BoxDecoration(
            color:
                !isSelected ? AppColor.whiteColor : AppColor.primaryBlueColor,
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
              style: AppTextStyles.textStyleNormalBodySmall.copyWith(
                  color: isSelected
                      ? AppColor.whiteColor
                      : AppColor.primaryBlueColor),
            )
          ],
        ),
      ),
    );
  }

  Widget _getCountCard({required String text, required bool isSelected}) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Card(
        color: isSelected ? AppColor.primaryBlueColor : AppColor.whiteColor,
        elevation: 2,
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.textStyleNormalBodyXSmall.copyWith(
              color:
                  !isSelected ? AppColor.primaryBlueColor : AppColor.whiteColor,
            ),
          ),
        ),
      ),
    );
  }

  _propertiesFoundUi(context) {
    return AppPopUps.showSlidingPanel(
      context: context,
      title: 'Displaying ${controller.totalProperties} Properties ',
      child: Column(
        children: [
          Row(
            children: [
              hSpace,
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: MyTextField(
                    hintText: 'Destination, Question, Query, etc.',
                    borderRadius: 80,
                    leftPadding: 0,
                    rightPadding: 0,
                    textColor: AppColor.blackColor,
                    focusBorderColor: AppColor.blackColor,
                    unfocusBorderColor: AppColor.blackColor,
                    controller: controller.searchController,
                    onFieldSubmit: (s) {
                      controller.hasSearchedByTyping = true;
                      controller.resetListResults();
                      controller.loadListings(
                          onComplete: (PropertyListingResponseModel
                              propertyListingModel) {});
                    },
                    suffixIconWidet: RecordingWidget(
                        iconColor: AppColor.blackColor,
                        onStop: () {
                          if (controller.searchController.text.isNotEmpty) {
                            controller.hasSearchedByTyping = true;
                            controller.resetListResults();
                            controller.loadListings(
                                onComplete: (PropertyListingResponseModel
                                    propertyListingModel) {});
                          }
                        },
                        onListenComplete: (String? s) {
                          if (s != null) {
                            controller.searchController.text = s.toString();
                          }
                        }),
                  ),
                ),
              ),
              hSpace,
              InkWell(
                onTap: () {
                  controller.isSearchingResultFound.value = false;
                },
                child: SvgViewer(
                  svgPath: Assets.iconsNewFilterIcBlck,
                  color: AppColor.blackColor,
                  height: 55.h,
                ),
              ),
              hSpace,
            ],
          ),
          vSpace,
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  padding: const EdgeInsets.only(bottom: 80),
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: controller.initialPosition,
                  markers: controller.markers,
                  onMapCreated: controller.onMapCreated,
                ),
                InkWell(
                  onTap: () {
                    controller.updateLatLngBoundsMarkers();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColor.whiteColor,
                      child: Icon(
                        Icons.navigation_outlined,
                        color: AppColor.primaryBlueColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          vSpace,
        ],
      ),
      pannelWidget: NotificationListener(
        onNotification: controller.onScrollNotification,
        child: Obx(() => ScrollablePositionedList.builder(
              itemScrollController: controller.itemScrollController,
              itemCount: controller.propertiesList.length,
              padding: EdgeInsets.only(bottom: 380.h),
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                PropertyModel propertyModel =
                    controller.propertiesList.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: MostPopularWidget(
                      bottomSheetType: BottomSheetType.searchListing,
                      index: index,
                      propertyModel: propertyModel,
                      sizeHeight: context.isTablet ? 220.h : 180.h),
                );
              },
            )),
      ),
    );
  }

  _resultFilterUi(BuildContext context) {
    TextEditingController budgetController = TextEditingController(
        text:
            '${controller.lowerPropertyPrice.toString()} - ${controller.upperPropertyPrice.toString()}');
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      controller.isSearchingResultFound.value = true;
                    },
                    child: SvgViewer(
                      svgPath: Assets.iconsNewFilterIcBlck,
                      height: 55.h,
                    ),
                  ),
                ),
                vSpace,

                ///selcect type of searching...
                Container(
                  height: 60.h,
                  decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      border: Border.all(
                          color: AppColor.greyColor,
                          style: BorderStyle.solid,
                          width: 1),
                      borderRadius: BorderRadius.circular(28)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: TabBar(
                      controller: controller.propertySearchTypeTab,
                      labelColor: AppColor.whiteColor,
                      unselectedLabelColor: AppColor.greyColor,
                      indicator: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28)),
                          color: AppColor.primaryBlueColor),
                      tabs: controller.tabs,
                    ),
                  ),
                ),
                vSpace,
                vSpace,
                Text(
                  "Select one to choose",
                  style: AppTextStyles.textStyleBoldSubTitleLarge
                      .copyWith(color: AppColor.greyColor),
                ),
                vSpace,
                vSpace,
                Obx(() {
                  return SizedBox(
                    height: 180.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: AppConstants.propertiesTypeFilterListing.entries
                          .map((e) => getTypeItemCard(
                              isSelected: controller
                                      .selectedPropertyTypeFilterListing
                                      .value ==
                                  e.value,
                              title: e.value.toUpperCase(),
                              icon: AppConstants.getSvgIcon(e.value),
                              onTap: () {
                                controller.selectedPropertyTypeFilterListing
                                    .value = e.value;
                              }))
                          .toList(),
                    ),
                  );
                }),

                vSpace,

                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Obx(() => Column(
                //           children: [
                //             vSpace,
                //             AppUtils.getCountryDropDown(
                //                 title: "Select Country",
                //                 withBorder: false,
                //                 labelColor: AppColor.greyColor,
                //                 initialItem: controller
                //                         .selectedCountry.value.isNotEmpty
                //                     ? Predictions(
                //                         description:
                //                             controller.selectedCountry.value)
                //                     : null,
                //                 onChange: (Predictions? data) {
                //                   controller.selectedCountry.value =
                //                       data?.description ?? '';
                //                   controller.selectedPredictionCity.value = '';
                //                   controller.selectedPredictionArea.value = '';
                //                 }),
                //             if (controller.selectedCountry.value.isNotEmpty)
                //               Column(
                //                 children: [
                //                   vSpace,
                //                   AppUtils.getCitySelectDropDown(
                //                       title: "Select City",
                //                       withBorder: false,
                //                       labelColor: AppColor.greyColor,
                //                       country: AppConstants.countriesMap[
                //                               controller
                //                                   .selectedCountry.value] ??
                //                           'pk',
                //                       initialItem: controller
                //                               .selectedPredictionCity
                //                               .value
                //                               .isNotEmpty
                //                           ? Predictions(
                //                               description: controller
                //                                   .selectedPredictionCity.value)
                //                           : null,
                //                       onChange: (Predictions? data) {
                //                         controller.selectedPredictionCity
                //                             .value = data?.description ?? '';
                //
                //                         controller
                //                             .selectedPredictionArea.value = '';
                //                       }),
                //                 ],
                //               ),
                //             if (controller
                //                 .selectedPredictionCity.value.isNotEmpty)
                //               Column(
                //                 children: [
                //                   vSpace,
                //                   AppUtils.getAreaSelectDropDown(
                //                       title: "Select Area",
                //                       withBorder: false,
                //                       labelColor: AppColor.greyColor,
                //                       initialItem: controller
                //                               .selectedPredictionArea
                //                               .value
                //                               .isNotEmpty
                //                           ? Predictions(
                //                               description: controller
                //                                   .selectedPredictionArea.value)
                //                           : null,
                //                       country: AppConstants.countriesMap[
                //                               controller
                //                                   .selectedCountry.value] ??
                //                           'pk',
                //                       city: controller
                //                           .selectedPredictionCity.value,
                //                       onChange: (Predictions? data) {
                //                         controller.selectedPredictionArea
                //                             .value = data?.description ?? '';
                //                       }),
                //                 ],
                //               ),
                //             vSpace
                //           ],
                //         )),
                //   ],
                // ),
                // vSpace,
                Text(
                  "Currency",
                  style: AppTextStyles.textStyleBoldBodyMedium
                      .copyWith(color: AppColor.greyColor),
                ),
                MyDropDown(
                  fillColor: AppColor.whiteColor,
                  items: AppConstants.currenciesTypeFilterListing.keys.toList(),
                  value: controller.selectedCurrencyTypeKeyFilterListing.value,
                  onChange: (value) {
                    controller.selectedCurrencyTypeKeyFilterListing.value =
                        value;
                  },
                ),
                vSpace,
                Text(
                  "Sort by",
                  style: AppTextStyles.textStyleBoldBodyMedium
                      .copyWith(color: AppColor.greyColor),
                ),
                MyDropDown(
                  fillColor: AppColor.whiteColor,
                  items: AppConstants.propertiesSortBy.keys.toList(),
                  value: controller.sortByKey.value,
                  onChange: (value) {
                    controller.sortByKey.value = value;
                  },
                ),
                vSpace,
                Text(
                  "Your budget",
                  style: AppTextStyles.textStyleBoldBodyMedium
                      .copyWith(color: AppColor.greyColor),
                ),
                TextField(
                  enabled: false,
                  decoration:
                      const InputDecoration(contentPadding: EdgeInsets.zero),
                  style: AppTextStyles.textStyleNormalBodyMedium
                      .copyWith(color: AppColor.primaryBlueColor),
                  controller: budgetController,
                ),
                vSpace,
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('min',
                            style: AppTextStyles.textStyleBoldBodyMedium
                                .copyWith(color: AppColor.greyColor)),
                        Text('max',
                            style: AppTextStyles.textStyleBoldBodyMedium
                                .copyWith(color: AppColor.greyColor)),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: context.height * 0.03,
                          right: context.width * 0.04,
                          left: context.width * 0.04),
                      child: RangeSliderFlutter(
                        values: [
                          controller.lowerPropertyPrice,
                          controller.upperPropertyPrice
                        ],
                        rangeSlider: true,
                        //   selectByTap: true,
                        tooltip: RangeSliderFlutterTooltip(
                            alwaysShowTooltip: true,
                            boxStyle: const RangeSliderFlutterTooltipBox(
                                decoration:
                                    BoxDecoration(color: Colors.transparent)),
                            textStyle: AppTextStyles.textStyleBoldBodyXSmall
                                .copyWith(color: AppColor.primaryBlueColor)),
                        max: 100000000,
                        min: 0,
                        maximumDistance: 100000000,
                        minimumDistance: 0,
                        textPositionTop: -40,
                        handlerHeight: 20,
                        trackBar: RangeSliderFlutterTrackBar(
                          activeTrackBarHeight: 4,
                          inactiveTrackBarHeight: 3,
                          activeTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColor.primaryBlueColor,
                          ),
                          inactiveTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey,
                          ),
                        ),
                        fontSize: 8,
                        textBackgroundColor: AppColor.primaryBlueColor,

                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          controller.lowerPropertyPrice =
                              double.parse((lowerValue).toStringAsFixed(2));
                          controller.upperPropertyPrice =
                              double.parse((upperValue).toStringAsFixed(2));
                          budgetController.text =
                              '${controller.lowerPropertyPrice.toString()} - ${controller.upperPropertyPrice.toString()}';
                        },
                      ),
                    ),
                  ],
                ),
                vSpace,
                // Text(
                //   "Your Size",
                //   style: AppTextStyles.textStyleNormalBodyMedium
                //       .copyWith(color: AppColor.greyColor),
                // ),
                // Row(
                //   children: [
                //     Flexible(
                //         child: MyDropDown(
                //       fillColor: AppColor.whiteColor,
                //       items:
                //           AppConstants.currenciesType.keys.toList(),
                //       onChange: (value) {
                //         // controller.selectedPurpose.value = value;
                //       },
                //     )),
                //     hSpace,
                //     Text(
                //       "TO",
                //       style: AppTextStyles.textStyleNormalBodyMedium
                //           .copyWith(color: AppColor.greyColor),
                //     ),
                //     hSpace,
                //     Flexible(
                //         child: MyDropDown(
                //       fillColor: AppColor.whiteColor,
                //       hintText: "select",
                //       items:
                //           AppConstants.currenciesType.values.toList(),
                //       onChange: (value) {
                //         // controller.selectedPurpose.value = value;
                //       },
                //     )),
                //   ],
                // ),

                Text(
                  "Measurement",
                  style: AppTextStyles.textStyleBoldBodyMedium
                      .copyWith(color: AppColor.greyColor),
                ),
                MyDropDown(
                  fillColor: AppColor.whiteColor,
                  hintText: 'Select',
                  value: controller.selectedSpaceUnitKeyFilterListing.value,
                  items: AppConstants.spaceUnitsFilterListing.keys.toList(),
                  onChange: (value) {
                    controller.selectedSpaceUnitKeyFilterListing.value = value;
                  },
                ),
                vSpace,
                Text("Range",
                    style: AppTextStyles.textStyleBoldBodyMedium
                        .copyWith(color: AppColor.greyColor)),
                vSpace,
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('min',
                            style: AppTextStyles.textStyleBoldBodyMedium
                                .copyWith(color: AppColor.greyColor)),
                        Text('max',
                            style: AppTextStyles.textStyleBoldBodyMedium
                                .copyWith(color: AppColor.greyColor)),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: context.height * 0.03,
                          right: context.width * 0.04,
                          left: context.width * 0.04),
                      child: RangeSliderFlutter(
                        values: [
                          controller.lowerPropertySize,
                          controller.upperPropertySize
                        ],
                        rangeSlider: true,
                        selectByTap: true,
                        tooltip: RangeSliderFlutterTooltip(
                            alwaysShowTooltip: true,
                            boxStyle: const RangeSliderFlutterTooltipBox(
                                decoration:
                                    BoxDecoration(color: Colors.transparent)),
                            textStyle: AppTextStyles.textStyleBoldBodyXSmall
                                .copyWith(color: AppColor.primaryBlueColor)),
                        max: 1050,
                        min: 0,
                        maximumDistance: 1000,
                        minimumDistance: 0,
                        textPositionTop: -40,
                        handlerHeight: 20,
                        trackBar: RangeSliderFlutterTrackBar(
                          activeTrackBarHeight: 4,
                          inactiveTrackBarHeight: 3,
                          activeTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColor.primaryBlueColor,
                          ),
                          inactiveTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey,
                          ),
                        ),
                        fontSize: 8,
                        textBackgroundColor: AppColor.primaryBlueColor,
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          controller.lowerPropertySize =
                              double.parse((lowerValue).toStringAsFixed(2));
                          controller.upperPropertySize =
                              double.parse((upperValue).toStringAsFixed(2));
                        },
                      ),
                    ),
                  ],
                ),
                vSpace,
                const Divider(color: AppColor.greyColor),
                vSpace,

                ///bedrooms
                SizedBox(
                  height: 60.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text("Bedroom",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.textStyleBoldBodyMedium
                                .copyWith(color: AppColor.greyColor)),
                      ),
                      hSpace,
                      Flexible(
                        flex: 3,
                        child: Obx(() {
                          controller.selectedBed.value;
                          return ListView.builder(
                            itemCount: 6,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var text = index == 0
                                  ? 'Any'
                                  : (index == 5)
                                      ? '5+'
                                      : index.toString();
                              return InkWell(
                                onTap: () {
                                  controller.selectedBed.value = text;
                                },
                                child: _getCountCard(
                                    text: text,
                                    isSelected:
                                        controller.selectedBed.value == text),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                vSpace,
                const Divider(color: AppColor.greyColor),
                vSpace,

                ///bathrooms
                SizedBox(
                  height: 60.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text("Bathroom",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.textStyleBoldBodyMedium
                                .copyWith(color: AppColor.greyColor)),
                      ),
                      hSpace,
                      Flexible(
                        flex: 3,
                        child: Obx(() {
                          controller.selectedBath.value;
                          return ListView.builder(
                            itemCount: 6,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var text = index == 0
                                  ? 'Any'
                                  : (index == 5)
                                      ? '5+'
                                      : index.toString();
                              return InkWell(
                                onTap: () {
                                  controller.selectedBath.value = text;
                                },
                                child: _getCountCard(
                                    text: text,
                                    isSelected:
                                        controller.selectedBath.value == text),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                vSpace,
                const Divider(color: AppColor.greyColor),

                ///stores
                // SizedBox(
                //   height: 60.h,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Expanded(
                //         child: Text("Stores",
                //             textAlign: TextAlign.center,
                //             style: AppTextStyles.textStyleBoldBodyMedium
                //                 .copyWith(color: AppColor.greyColor)),
                //       ),
                //       hSpace,
                //       Flexible(
                //         flex: 3,
                //         child: Obx(() {
                //           controller.selectedStores.value;
                //           return ListView.builder(
                //             itemCount: 6,
                //             shrinkWrap: true,
                //             scrollDirection: Axis.horizontal,
                //             itemBuilder: (context, index) {
                //               var text = index == 0
                //                   ? 'Any'
                //                   : (index == 5)
                //                       ? '5+'
                //                       : index.toString();
                //               return InkWell(
                //                 onTap: () {
                //                   controller.selectedStores.value = text;
                //                 },
                //                 child: _getCountCard(
                //                     text: text,
                //                     isSelected:
                //                         controller.selectedStores.value ==
                //                             text),
                //               );
                //             },
                //           );
                //         }),
                //       ),
                //     ],
                //   ),
                // ),

                // vSpace,
                // const Divider(color: AppColor.greyColor),
                vSpace,
                Text("Amenities/Features",
                    style: AppTextStyles.textStyleBoldBodyMedium
                        .copyWith(color: AppColor.greyColor)),
                vSpace,
                Wrap(
                  children: AppConstants.propertyFeatures.entries
                      .toList()
                      .map((e) => InkWell(
                            onTap: () {
                              controller.addRemoveAmenities(e.key);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: controller.selectedAmenties
                                          .contains(e.key)
                                      ? AppColor.primaryBlueColor
                                      : AppColor.whiteColor,
                                  border: Border.all(color: AppColor.greyColor),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                e.value.toString(),
                                style: AppTextStyles.textStyleNormalBodyXSmall
                                    .copyWith(
                                        color: !controller.selectedAmenties
                                                .contains(e.key)
                                            ? AppColor.greyColor
                                            : AppColor.whiteColor),
                              ),
                            ),
                          ))
                      .toList(),
                ),

                SizedBox(height: context.height * 0.2)
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 118.h, horizontal: 18),
          width: context.width,
          child: Button(
            buttonText: "Search",
            onTap: () {
              controller.resetListResults();
              controller.loadListings(
                  onComplete:
                      (PropertyListingResponseModel propertyListingModel) {});
            },
          ),
        )
      ],
    );
  }
}
