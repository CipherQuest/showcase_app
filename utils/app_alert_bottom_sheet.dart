import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:get/get.dart';
import 'package:google_places_for_flutter/google_places_for_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/generated/assets.dart';
import 'package:zeerac_flutter/modules/users/controllers/favorite_tab_controllers/listing_favorite_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/property_search_tab_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/report_controller.dart';
import 'package:zeerac_flutter/modules/users/models/acutions_listing_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/firebase_conversations_model.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/modules/users/models/user_model.dart';
import 'package:zeerac_flutter/modules/users/pages/chat/chat_screen.dart';
import 'package:zeerac_flutter/modules/users/pages/favourite_page/save_list_tb.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_listing_widgets.dart';
import 'package:zeerac_flutter/modules/users/pages/report.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import 'package:zeerac_flutter/utils/myAnimSearchBar.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

import '../common/app_constants.dart';
import '../common/search_place_widgt.dart';
import '../common/spaces_boxes.dart';
import '../dio_networking/app_apis.dart';
import '../modules/users/pages/edit_property_listing/edit_property_listing_detail_page.dart';

enum BottomSheetType {
  listing,
  auctionFile,
  searchListing,
  favoriteListing,
  popularListing,
  recentlyViewed
}

class AppBottomSheets with PropertyListingWidgets {
  //bool isDialogShowing = false;
  static final AppBottomSheets _singleton = AppBottomSheets._internal();

  factory AppBottomSheets() {
    return _singleton;
  }

  AppBottomSheets._internal();

  static showAppAlertBottomSheet(
      {isDismissable = false,
      required BuildContext context,
      required Widget child,
      String title = '',
      bool isFull = false}) {
    //   isDialogShowing =true;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 0,
        isScrollControlled: isFull,
        enableDrag: isDismissable,
        context: context,
        builder: (context) {
          return Container(
            margin: EdgeInsets.only(top: 80.h, left: 30.w, right: 30.w),
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(100.r),
                  topLeft: Radius.circular(100.r)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.textStyleBoldBodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.cancel,
                        color: AppColor.blackColor,
                      ),
                    )
                  ],
                ),
                Expanded(child: child)
              ],
            ),
          );
        });
  }

  static showShareBottomSheet(
      {isDismissable = true,
      BottomSheetType? bottomSheetType,
      bool compare = true,
      bool share = true,
      bool like = true,
      PropertyModel? propertyModel,
      AuctionFileModel? auctionFileModel,
      required BuildContext context,
      Widget? child,
      String title = 'Choose what you want with this item',
      bool isScrollControlled = true,
      int propertyIndex = -1,
      bool isEdit = false}) {
    RxBool isAddedToLikeAlready = false.obs;
    RxBool isAddedToCompareAlready = false.obs;
    RxBool favoriteLoading = false.obs;
    // RxBool showSocialShare = false.obs;
    RxString message = ''.obs;

    showMessage(msg) {
      message.value = msg;
      Future.delayed(const Duration(seconds: 2), () {
        message.value = '';
      });
    }

    ///check liked
    // checkIsLikes({required isFirst}) {
    //   if (propertyModel != null) {
    //     UserDefaults.checkIfIsInFavListOfProperties(propertyModel,
    //             isFirst: isFirst)
    //         .then((value) {
    //       isAddedToLikeAlready.value = value;
    //       if (!isFirst) {
    //         showMessage(
    //             value ? 'Added to favourites list' : 'Removed from favourites');
    //       }
    //     });
    //   } else if (auctionFileModel != null) {
    //     UserDefaults.checkIfIsInFavListOfAuctions(auctionFileModel,
    //             isFirst: isFirst)
    //         .then((value) {
    //       isAddedToLikeAlready.value = value;
    //       if (!isFirst) {
    //         showMessage(
    //             value ? 'Added to favourites list' : 'Removed from favourites');
    //       }
    //     });
    //   }
    // }

    //checking if the property is favorited or not. If favorited make the heart red
    checkIfFavorited() {
      int currentUserId = int.parse(UserDefaults.getCurrentUserId() ?? '-1');
      print('currentUser id $currentUserId');
      print(propertyModel!.favoritesCount);
      if (propertyModel!.favoritesCount!.contains(currentUserId)) {
        isAddedToLikeAlready.value = true;
      }
    }

    //change favorite of property from backend
    toggleFavoriteApi(int? propertyId) async {
      try {
        Map<String, dynamic> headers = {};
        Map<String, dynamic> body = {'property_id': propertyId.toString()};
        String token = UserDefaults.getApiToken()!.trim() ?? '';
        headers['Authorization'] = token;
        var dio = Dio();
        var response = await dio.post(
          '${ApiConstants.baseUrl}users/property-favorite/',
          data: body,
          options: Options(
              validateStatus: (_) => true,
              responseType: ResponseType.json,
              contentType: Headers.jsonContentType,
              headers: headers),
        );
        if (response.data['status'] == true) {
          if (response.data['message'] == "Property favorited") {
            return 'Favorited';
          } else {
            return 'UnFavorited';
          }
        }
        return 'Error';
      } catch (e) {
        PrintError('propertySearchTabController', 'loadListings', e.toString());
        return 'Error';
      }
    }

    int getPropertyIndex(List<PropertyModel> propertyList) {
      return propertyList
          .indexWhere((element) => element.id == propertyModel!.id);
    }

    toggleFavoriteModified() async {
      favoriteLoading.value = true;
      int currentUserId = int.parse(UserDefaults.getCurrentUserId() ?? '-1');
      String response = await toggleFavoriteApi(propertyModel!.id);
      print('response is $response');
      if (response == 'Favorited') {
        //////////   HomeScreen  ///////////

        HomeController homeController = Get.find();
        //check if recently viewed not empty
        if (homeController.recentlyViewedList.isNotEmpty) {
          //check if property exists in recently viewed
          int index = getPropertyIndex(homeController.recentlyViewedList);
          if (index != -1) {
            //save the property, remove it and than add the updated property
            var temp = homeController.recentlyViewedList.elementAt(index);
            homeController.recentlyViewedList.removeAt(index);
            temp.favoritesCount!.add(currentUserId);
            homeController.recentlyViewedList.insert(index, temp);
            //since recently viewed store in local storage also need to update the local storage
            UserDefaults.removePropertyFromRecentList(temp);
            UserDefaults.addPropertyToRecentList(temp);
          }
        }
        if (homeController.mostPopuloarPropertiesList.isNotEmpty) {
          //check if property exists in mostPopuloarPropertiesList viewed
          int index =
              getPropertyIndex(homeController.mostPopuloarPropertiesList);
          if (index != -1) {
            //save the property, remove it and than add the updated property
            var temp =
                homeController.mostPopuloarPropertiesList.elementAt(index);
            homeController.mostPopuloarPropertiesList.removeAt(index);
            temp.favoritesCount!.add(currentUserId);
            homeController.mostPopuloarPropertiesList.insert(index, temp);
          }
        }
        //////////   Favorite Screen  ///////////
        ListingFavoriteController listingFavoriteController = Get.find();
        listingFavoriteController.favoritedListingsList.add(propertyModel);

        //////////   Property Search Tab  ///////////

        PropertySearchTabController propertySearchTabController = Get.find();
        //check if recently viewed not empty
        if (propertySearchTabController.propertiesList.isNotEmpty) {
          //check if property exists in recently viewed
          int index =
              getPropertyIndex(propertySearchTabController.propertiesList);
          if (index != -1) {
            //save the property, remove it and than add the updated property
            var temp =
                propertySearchTabController.propertiesList.elementAt(index);
            propertySearchTabController.propertiesList.removeAt(index);
            temp.favoritesCount!.add(currentUserId);
            propertySearchTabController.propertiesList.insert(index, temp);
          }
        }

        isAddedToLikeAlready.value = true;
      } else if (response == 'UnFavorited') {
        //////////   HomeScreen  ///////////
        HomeController homeController = Get.find();
        //check if recently viewed not empty
        if (homeController.recentlyViewedList.isNotEmpty) {
          //check if property exists in recently viewed
          int index = getPropertyIndex(homeController.recentlyViewedList);
          if (index != -1) {
            //save the property, remove it and than add the updated property
            var temp = homeController.recentlyViewedList.elementAt(index);
            homeController.recentlyViewedList.removeAt(index);
            temp.favoritesCount!.remove(currentUserId);
            homeController.recentlyViewedList.insert(index, temp);
            //since recently viewed store in local storage also need to update the local storage
            UserDefaults.removePropertyFromRecentList(temp);
            UserDefaults.addPropertyToRecentList(temp);
          }
        }
        if (homeController.mostPopuloarPropertiesList.isNotEmpty) {
          //check if property exists in mostPopuloarPropertiesList viewed
          int index =
              getPropertyIndex(homeController.mostPopuloarPropertiesList);
          if (index != -1) {
            //save the property, remove it and than add the updated property
            var temp =
                homeController.mostPopuloarPropertiesList.elementAt(index);
            homeController.mostPopuloarPropertiesList.removeAt(index);
            temp.favoritesCount!.remove(currentUserId);
            homeController.mostPopuloarPropertiesList.insert(index, temp);
          }
        }

        //////////   Favorite Screen  ///////////
        ListingFavoriteController listingFavoriteController = Get.find();
        //get index of property
        int index =
            getPropertyIndex(listingFavoriteController.favoritedListingsList);
        print('index is $index');
        //remove the property
        if (index != -1) {
          listingFavoriteController.favoritedListingsList.removeAt(index);
        }

        //////////   Property Search Tab  ///////////

        PropertySearchTabController propertySearchTabController = Get.find();
        //check if recently viewed not empty
        if (propertySearchTabController.propertiesList.isNotEmpty) {
          //check if property exists in recently viewed
          int index =
              getPropertyIndex(propertySearchTabController.propertiesList);
          if (index != -1) {
            //save the property, remove it and than add the updated property
            var temp =
                propertySearchTabController.propertiesList.elementAt(index);
            propertySearchTabController.propertiesList.removeAt(index);
            temp.favoritesCount!.remove(currentUserId);
            propertySearchTabController.propertiesList.insert(index, temp);
          }
        }

        isAddedToLikeAlready.value = false;
      }
      favoriteLoading.value = false;
    }

    toggleFavorite() async {
      favoriteLoading.value = true;
      HomeController homeController = Get.find();
      if (bottomSheetType == BottomSheetType.searchListing) {
        PropertySearchTabController propertySearchTabController = Get.find();
        int currentUserId = int.parse(UserDefaults.getCurrentUserId() ?? '-1');
        String response =
            await propertySearchTabController.toggleFavorite(propertyModel!.id);
        if (response == 'Favorited') {
          ListingFavoriteController listingFavoriteController = Get.find();
          listingFavoriteController.onlyOnce = true;
          homeController.onlyOnce = true;
          isAddedToLikeAlready.value = true;
          propertySearchTabController
              .propertiesList[propertyIndex].favoritesCount!
              .add(currentUserId);
        } else if (response == 'UnFavorited') {
          ListingFavoriteController listingFavoriteController = Get.find();
          listingFavoriteController.onlyOnce = true;
          homeController.onlyOnce = true;
          isAddedToLikeAlready.value = false;
          propertySearchTabController
              .propertiesList[propertyIndex].favoritesCount!
              .remove(currentUserId);
        } else {}
        favoriteLoading.value = false;
      } else if (bottomSheetType == BottomSheetType.favoriteListing) {
        favoriteLoading.value = true;
        ListingFavoriteController listingFavoriteController = Get.find();
        int currentUserId = int.parse(UserDefaults.getCurrentUserId() ?? '-1');
        String response =
            await listingFavoriteController.toggleFavorite(propertyModel!.id);
        if (response == 'Favorited') {
          PropertySearchTabController propertySearchTabController = Get.find();
          propertySearchTabController.onlyOnce = true;
          homeController.onlyOnce = true;
          isAddedToLikeAlready.value = true;
          listingFavoriteController.favoritedListingsList.add(propertyModel);
          listingFavoriteController
              .favoritedListingsList[propertyIndex].favoritesCount!
              .add(currentUserId);
        } else if (response == 'UnFavorited') {
          PropertySearchTabController propertySearchTabController = Get.find();
          propertySearchTabController.onlyOnce = true;
          homeController.onlyOnce = true;
          //isAddedToLikeAlready.value = false;
          Get.back();
          listingFavoriteController
              .favoritedListingsList[propertyIndex].favoritesCount!
              .remove(currentUserId);
          listingFavoriteController.favoritedListingsList
              .removeAt(propertyIndex);
          //isAddedToLikeAlready.value = false;
        } else {}
        favoriteLoading.value = false;
        print('response is $response');
      } else if (bottomSheetType == BottomSheetType.popularListing) {
        PropertySearchTabController propertySearchTabController = Get.find();
        HomeController homeController = Get.find();
        int currentUserId = int.parse(UserDefaults.getCurrentUserId() ?? '-1');
        String response =
            await propertySearchTabController.toggleFavorite(propertyModel!.id);
        if (response == 'Favorited') {
          ListingFavoriteController listingFavoriteController = Get.find();
          listingFavoriteController.onlyOnce = true;
          propertySearchTabController.onlyOnce = true;
          isAddedToLikeAlready.value = true;
          homeController
              .mostPopuloarPropertiesList[propertyIndex].favoritesCount!
              .add(currentUserId);
        } else if (response == 'UnFavorited') {
          ListingFavoriteController listingFavoriteController = Get.find();
          listingFavoriteController.onlyOnce = true;

          isAddedToLikeAlready.value = false;
          homeController
              .mostPopuloarPropertiesList[propertyIndex].favoritesCount!
              .remove(currentUserId);
        } else {}
        favoriteLoading.value = false;
      }
    }

    //check in compared
    checkIsCompared({required isFirst}) {
      if (propertyModel != null) {
        UserDefaults.checkIfIsInCompareList(propertyModel, isFirst: isFirst)
            .then((value) {
          isAddedToCompareAlready.value = value;
          if (!isFirst) {
            showMessage(
                value ? 'Added to compared list' : 'Removed from compared');
          }
        });
      }
    }

    String getShareLink() {
      String url = "";
      if (propertyModel != null) {
        url = "${ApiConstants.dynamicLinkBase}/properties/${propertyModel.id}/";
      } else if (auctionFileModel != null) {
        url =
            "${ApiConstants.dynamicLinkBase}/property-files/${auctionFileModel.id}/";
      }
      return url;
    }

    //checkIsLikes(isFirst: true);
    checkIfFavorited();
    checkIsCompared(isFirst: true);

    telePhone(BottomSheetType? bottomSheetType) async {
      if (bottomSheetType == BottomSheetType.listing ||
          bottomSheetType == BottomSheetType.popularListing ||
          bottomSheetType == BottomSheetType.searchListing) {
        var type = ReportTypeEnum.listing;
        String phoneNo = propertyModel!.user!.phoneNumber ?? '';
        Uri phoneno = Uri.parse('tel:$phoneNo');
        if (await launchUrl(phoneno)) {
          int id = propertyModel.id ?? 0;
          //increment reveal number count
          ReportController reportController = Get.put(ReportController());
          reportController.revealNumberCount(type, id);
        } else {
          //dailer is not opened
        }
      } else if (bottomSheetType == BottomSheetType.auctionFile) {
        var type = ReportTypeEnum.listing;
        String phoneNo = auctionFileModel!.userFk!.phoneNumber ?? '';
        Uri phoneno = Uri.parse('tel:$phoneNo');
        if (await launchUrl(phoneno)) {
          int id = auctionFileModel.id ?? 0;
          //increment reveal number count
          // ReportController reportController = Get.put(ReportController());
          // reportController.revealNumberCount(type, id);
        }
      }
    }

    chat(BottomSheetType? bottomSheetType) {
      //AppPopUps.showSnackBar(message: 'Comming Soon', context: context);
      //todo
      print('bottomSheetType is ${bottomSheetType}');
      if (bottomSheetType == BottomSheetType.listing ||
          bottomSheetType == BottomSheetType.popularListing ||
          bottomSheetType == BottomSheetType.searchListing) {
        // ChatUserModel chatUserModel = ChatUserModel(
        //     otherUserId: propertyModel!.user!.id.toString(),
        //     otherUserContact: propertyModel!.user!.phoneNumber.toString(),
        //     otherUserName: propertyModel!.user!.fullName,
        //     otherUserProfileImage:
        //         "${ApiConstants.baseUrl}${propertyModel!.user!.photo!}");

        FirebaseUserModelNew firebaseUserModelNew = FirebaseUserModelNew(
            name: propertyModel!.user!.firstName,
            photo: propertyModel.user!.photo,
            isOnline: false,
            email: propertyModel.user!.email);
        Get.toNamed(ChatScreen.id, arguments: [
          firebaseUserModelNew,
          propertyModel.user!.id.toString()
        ]);
      } else if (bottomSheetType == BottomSheetType.auctionFile) {
        // ChatUserModel chatUserModel = ChatUserModel(
        //     otherUserId: auctionFileModel!.userFk!.id.toString(),
        //     otherUserContact: auctionFileModel!.userFk!.phoneNumber.toString(),
        //     otherUserName: auctionFileModel!.userFk!.fullName,
        //     otherUserProfileImage:
        //         "${ApiConstants.baseUrl}${auctionFileModel!.userFk!.photo!}");

        // Get.toNamed(ChatScreen.id, arguments: chatUserModel);
      }
    }

    report(BottomSheetType? bottomSheetType) {
      Get.back();
      if (bottomSheetType == BottomSheetType.listing) {
        var type = ReportTypeEnum.agent;
        Get.to(Report(
          type: type,
          id: propertyModel!.id ?? 0,
        ));
      } else if (bottomSheetType == BottomSheetType.auctionFile) {
        var type = ReportTypeEnum.agent;
        // Get.to(Report(
        //   type: type,
        //   id: propertyModel!.id ?? 0,
        // ));
      }
    }

    _increaseShareCount() async {
      var dio = Dio();
      Map<String, dynamic> headers = {};
      String token = UserDefaults.getApiToken()!.trim() ?? '';
      headers['Authorization'] = token;
      var response = await dio.post(
          '${ApiConstants.baseUrl}users/property/${propertyModel!.id}/share_count/',
          options: Options(
              validateStatus: (_) => true,
              responseType: ResponseType.json,
              contentType: Headers.jsonContentType,
              headers: headers));
    }

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 0,
        isScrollControlled: isScrollControlled,
        enableDrag: isDismissable,
        context: context,
        builder: (context) {
          return Container(
            height: context.height * 0.3,
            margin: EdgeInsets.only(left: 30.w, right: 30.w, bottom: 50.h),
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(80.r)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(80.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.textStyleNormalBodyMedium
                              .copyWith(color: AppColor.blackColor),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: AppColor.blackColor,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: child ??
                        SingleChildScrollView(
                          child: Obx(
                            () => Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (like)
                                      UserDefaults.getUserSession() != null
                                          ? UserDefaults.getCurrentUserId() !=
                                                  propertyModel!.user!.id
                                                      .toString()
                                              ? favoriteLoading.value == false
                                                  ? InkWell(
                                                      onTap: () {
                                                        //checkIsLikes(isFirst: false);
                                                        //toggleFavorite();
                                                        toggleFavoriteModified();
                                                      },
                                                      child: Icon(
                                                        isAddedToLikeAlready
                                                                .value
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_outline,
                                                        size: 26,
                                                        color:
                                                            isAddedToLikeAlready
                                                                    .value
                                                                ? AppColor
                                                                    .redColor
                                                                : AppColor
                                                                    .blackColor,
                                                      ),
                                                    )
                                                  : CircularProgressIndicator(
                                                      strokeWidth: 3,
                                                      color: AppColor
                                                          .primaryBlueColor,
                                                    )
                                              : Icon(
                                                  Icons.favorite_outline,
                                                  size: 26,
                                                  color: Colors.grey,
                                                )
                                          : Icon(
                                              Icons.favorite_outline,
                                              size: 26,
                                              color: Colors.grey,
                                            ),
                                    if (compare)
                                      InkWell(
                                        onTap: () {
                                          checkIsCompared(isFirst: false);
                                        },
                                        child: SvgViewer(
                                          svgPath:
                                              'assets/icons_new/compare_ic.svg',
                                          color: isAddedToCompareAlready.value
                                              ? AppColor.greenColor
                                              : AppColor.blackColor,
                                          height: 26,
                                        ),
                                      ),
                                    if (share)
                                      InkWell(
                                        onTap: () async {
                                          var response = await FlutterShareMe()
                                              .shareToSystem(
                                                  msg: getShareLink());
                                          if (response == 'success') {
                                            _increaseShareCount();
                                          }
                                          print('share response is $response');
                                        },
                                        child: const SvgViewer(
                                          svgPath: Assets.iconsNewShareArrowIc,
                                          color: AppColor.blackColor,
                                          height: 26,
                                        ),
                                      ),
                                    UserDefaults.getUserSession() != null
                                        ? UserDefaults.getCurrentUserId() !=
                                                propertyModel!.user!.id
                                                    .toString()
                                            ? InkWell(
                                                onTap: () async {
                                                  telePhone(bottomSheetType);
                                                },
                                                child: const SvgViewer(
                                                  svgPath:
                                                      'assets/icons_new/mobile_call_ic.svg',
                                                  color: AppColor.blackColor,
                                                  height: 26,
                                                ),
                                              )
                                            : const SvgViewer(
                                                svgPath:
                                                    'assets/icons_new/mobile_call_ic.svg',
                                                color: AppColor.greyColor,
                                                height: 26,
                                              )
                                        : const SvgViewer(
                                            svgPath:
                                                'assets/icons_new/mobile_call_ic.svg',
                                            color: AppColor.greyColor,
                                            height: 26,
                                          ),
                                    UserDefaults.getUserSession() != null
                                        ? UserDefaults.getCurrentUserId() !=
                                                propertyModel!.user!.id
                                                    .toString()
                                            ? InkWell(
                                                onTap: () {
                                                  chat(bottomSheetType);
                                                },
                                                child: const SvgViewer(
                                                  svgPath:
                                                      'assets/icons_new/chat_ic.svg',
                                                  color: AppColor.blackColor,
                                                  height: 26,
                                                ),
                                              )
                                            : SvgViewer(
                                                svgPath:
                                                    'assets/icons_new/chat_ic.svg',
                                                color: AppColor.greyColor,
                                                height: 26,
                                              )
                                        : SvgViewer(
                                            svgPath:
                                                'assets/icons_new/chat_ic.svg',
                                            color: AppColor.greyColor,
                                            height: 26,
                                          ),
                                  ],
                                ),
                                vSpace,
                                Obx(
                                  () => Visibility(
                                    visible: message.value != '',
                                    child: Column(
                                      children: [
                                        const Divider(
                                            color: AppColor.greyColor,
                                            height: 1,
                                            thickness: 1),
                                        Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 4),
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(1)),
                                            child: Text(
                                              message.value,
                                              textAlign: TextAlign.center,
                                              style: AppTextStyles
                                                  .textStyleBoldBodyMedium
                                                  .copyWith(
                                                      color:
                                                          AppColor.greyColor),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(
                                    color: AppColor.greyColor,
                                    height: 1,
                                    thickness: 1),
                                !isEdit! == true
                                    ? Column(
                                        children: [
                                          vSpace,
                                          vSpace,
                                          UserDefaults.getUserSession() != null
                                              ? UserDefaults
                                                          .getCurrentUserId() !=
                                                      propertyModel!.user!.id
                                                          .toString()
                                                  ? InkWell(
                                                      onTap: () async {
                                                        telePhone(
                                                            bottomSheetType);
                                                      },
                                                      child: Container(
                                                        width: 1000.w,
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        60),
                                                            color: AppColor
                                                                .whiteColor,
                                                            border: Border.all(
                                                                color: AppColor
                                                                    .greyColor)),
                                                        child: Text(
                                                          'Request for Appointment',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: AppTextStyles
                                                              .textStyleBoldBodySmall
                                                              .copyWith(
                                                                  color: AppColor
                                                                      .primaryBlueColor),
                                                        ),
                                                      ),
                                                    )
                                                  : IgnorePointer()
                                              : IgnorePointer(),
                                          vSpace,
                                          UserDefaults.getUserSession() != null
                                              ? UserDefaults
                                                          .getCurrentUserId() !=
                                                      propertyModel!.user!.id
                                                          .toString()
                                                  ? InkWell(
                                                      onTap: () {
                                                        report(bottomSheetType);
                                                        print('looksfake');
                                                      },
                                                      child: Container(
                                                        width: 1000.w,
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        60),
                                                            color: AppColor
                                                                .whiteColor,
                                                            border: Border.all(
                                                                color: AppColor
                                                                    .greyColor)),
                                                        child: Text(
                                                          'Looks Fake? Report it',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: AppTextStyles
                                                              .textStyleBoldBodySmall
                                                              .copyWith(
                                                                  color: AppColor
                                                                      .primaryBlueColor),
                                                        ),
                                                      ),
                                                    )
                                                  : IgnorePointer()
                                              : IgnorePointer(),
                                          vSpace,
                                        ],
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ))
              ],
            ),
          );
        });
  }

  showFilterWidget(
      {required BuildContext context,
      required String spaceUnit,
      required String currencyUnit,
      required TextEditingController filterPropertyMinBudgetController,
      required TextEditingController filterPropertyMaxBudgetController,
      required TextEditingController filterPropertySpaceController,
      required TextEditingController filterAddressController,
      required Function onApplyTap}) {
    RxInt tempLoad = 1.obs;
    AppBottomSheets.showAppAlertBottomSheet(
        isFull: true,
        context: context,
        child: Obx(() {
          ///to manually rerender widget...
          tempLoad.value;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Budget",
                style: AppTextStyles.textStyleNormalBodyMedium
                    .copyWith(color: AppColor.primaryBlueColor),
              ),
              vSpace,
              Row(
                children: [
                  Expanded(
                    child: getTextField(
                        title: 'Min',
                        hintText: 'Minimum Price',
                        inputType: TextInputType.number,
                        validate: false,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: filterPropertyMinBudgetController),
                  ),
                  hSpace,
                  Expanded(
                    child: getTextField(
                        title: 'Max',
                        validate: false,
                        hintText: 'Maximum Price',
                        inputType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: filterPropertyMaxBudgetController),
                  ),
                  hSpace,
                  Expanded(
                    child: MySmallDropDown(
                        items: AppConstants.currenciesType.keys.toList(),
                        bgColor: AppColor.skyBlueColor,
                        onChange: (String? value) {
                          currencyUnit = value ?? '';
                        }),
                  ),
                ],
              ),
              vSpace,
              getTextField(
                  title: 'Property Size',
                  hintText: 'Property Size',
                  validate: false,
                  inputType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  suffixWidget: MySmallDropDown(
                      items: AppConstants.spaceUnits.keys.toList(),
                      bgColor: AppColor.skyBlueColor,
                      onChange: (String? value) {
                        spaceUnit = value ?? '';
                      }),
                  controller: filterPropertySpaceController),
              vSpace,
              vSpace,
              Row(
                children: [
                  Expanded(
                    child: MySearchGooglePlacesWidget(
                      placeType: PlaceType.cities,
                      // PlaceType.cities, PlaceType.geocode, PlaceType.region etc
                      // placeholder: filterAddressController.text.isNotEmpty
                      //     ? filterAddressController.text
                      //     : 'Search for location',
                      icon: Icons.location_on,
                      iconColor: AppColor.blackColor,
                      apiKey: ApiConstants.googleApiKey,
                      hasClearButton: false,

                      textEditingController: filterAddressController,
                      onSearch: (Place place) {},

                      onSelected: (Place place) async {
                        //filterAddressController.text = place.description ?? '';
                        tempLoad.value++;
                      },
                    ),
                  ),
                  if (filterAddressController.text.isNotEmpty)
                    Row(
                      children: [
                        hSpace,
                        InkWell(
                            onTap: () {
                              filterAddressController.clear();
                              tempLoad.value++;
                            },
                            child: const Icon(
                              Icons.clear,
                              color: AppColor.primaryBlueColor,
                            ))
                      ],
                    )
                ],
              ),
              vSpace,
              vSpace,
              Button(
                buttonText: "Clear All",
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  filterAddressController.clear();
                  filterPropertySpaceController.clear();
                  filterPropertyMinBudgetController.clear();
                  filterPropertyMaxBudgetController.clear();
                  tempLoad.value++;
                },
              ),
              vSpace,
              Button(
                buttonText: "Apply",
                onTap: onApplyTap,
              )
            ],
          );
        }));
  }
}
