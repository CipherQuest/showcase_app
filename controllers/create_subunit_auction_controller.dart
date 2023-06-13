import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:zeerac_flutter/common/app_constants.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

import '../../../dio_networking/api_route.dart';
import '../models/acutions_listing_response_model.dart';
import '../models/country_model.dart';
import '../pages/auctions/create_auction/subunit_create_auction.dart';
import 'edit_trading_controllers/edit_subunit_trading_controller.dart';

class CreateSubunitAuctionController extends GetxController {
  RxBool isLoading = false.obs;

  RxInt currentViewIndex = (0).obs;

  Map<String, Widget> viewsList = {
    "Information": SubunitAuctionBasicInformationWidget(),
    "Images": SubunitAuctionImagesWidget(),
    "Preview": SubunitAuctionPreviewWidget(),
  };

  RxList<File> picturesList = <File>[].obs;
  RxBool isTermsAccepted = false.obs;
  RxString selectedCountry = ''.obs;
  RxString selectedPredictionCity = ''.obs;
  RxString selectedPredictionArea = ''.obs;

  final ItemScrollController stepperController = ItemScrollController();

  ///attributes details

  RxString selectedCurrencyType = AppConstants.currenciesType.keys.first.obs;
  RxString selectedSpaceUnit = AppConstants.spaceUnits.keys.first.obs;
  RxString sharesPercentage = "0".obs;
  RxString selectedBidders = '0'.obs;

  TextEditingController auctionPriceController = TextEditingController();
  TextEditingController auctionSpaceController = TextEditingController();
  TextEditingController subUnitPriceValueController = TextEditingController();
  TextEditingController auctionAreaController = TextEditingController();
  TextEditingController auctionStartDateController = TextEditingController();
  TextEditingController auctionEndDateController = TextEditingController();

  RxInt updateDateTime = 1.obs;

  //edit
  bool isEdit = false;
  AuctionFileModel? modelToUpdate;
  void setValuesToEdit({required AuctionFileModel model}) {
    modelToUpdate = model;
    selectedCountry.value = model.country ?? "";
    selectedPredictionCity.value = model.city ?? '';
    auctionAreaController.text = model.area ?? "";
    auctionSpaceController.text = model.size ?? '';
    if (model.unit != null) {
      selectedSpaceUnit.value = AppConstants.spaceUnits.entries
          .firstWhere((element) => element.value == model.unit!)
          .key;
    }
    auctionPriceController.text = model.price ?? '';
    if (model.currency != null) {
      selectedCurrencyType.value = AppConstants.currenciesType.entries
          .firstWhere((element) => element.value == model.currency!)
          .key;
    }

    if (model.startDate != null) {
      auctionStartDateController.text = DateFormat('yyyy-MM-dd')
          .format(DateFormat('MM/dd/yyyy').parse(model.startDate!));
    }
    if (model.subUnitValue != null) {
      subUnitPriceValueController.text = model.subUnitValue ?? '';
    }

    if (model.endDate != null) {
      auctionEndDateController.text = DateFormat('yyyy-MM-dd')
          .format(DateFormat('MM/dd/yyyy').parse(model.endDate!));
    }
  }

  void goForward() {
    if (currentViewIndex.value < viewsList.length - 1) {
      currentViewIndex++;
    }
  }

  Future<bool> goBackWard() {
    if (currentViewIndex.value > 0) {
      currentViewIndex--;
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  String getValueFor(String key, PickResult? pickResult) {
    String result = 'not available';

    pickResult?.addressComponents?.forEach((element) {
      if (element.types.contains(key)) {
        result = element.longName;
      }
    });

    return result;
  }

  submit({required completion}) async {
    isLoading.value = true;
    Map<String, dynamic> body = {
      "auction_type": 'sub_unit',
      "total_files": 1,
      "price": auctionPriceController.text,
      "size": auctionSpaceController.text,
      "unit": AppConstants.spaceUnits[selectedSpaceUnit.value],
      "currency": AppConstants.currenciesType[selectedCurrencyType.value],
      "country": selectedCountry.value.trim(),
      "city": selectedPredictionCity.value.trim(),
      "area": auctionAreaController.text.trim(),
      "sub_unit_share_percentage": sharesPercentage.value,
      "sub_unit_value": subUnitPriceValueController.text,
      "is_sold": false,
      "is_active_listing": true,
      "start_date": auctionStartDateController.text.trim(),
      "end_date": auctionEndDateController.text.trim(),
    };
    printWrapped(selectedCurrencyType.value);
    printWrapped(body.toString());

    ///_______________________property images_________________________
    int i = 0;
    await Future.forEach(picturesList, (element) async {
      body['file[$i]'] = await dio.MultipartFile.fromFile(picturesList[i].path,
          filename: "file[$i].png");
      i++;
    });
    body['len'] = picturesList.length;

    // final data = dio.FormData.fromMap(body);
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.createFile,
              body: body,
            ),
            create: () =>
                APIResponse<AuctionFileModel>(create: () => AuctionFileModel()),
            apiFunction: submit)
        .then((response) {
      isLoading.value = false;
      if (response.response?.success ?? false) {
        //if isEdit is true, update the listing in the
        //profile -> MyTrading -> Auction
        if (isEdit == true) {
          EditSubUnitTradingController editSubUnitTradingController =
              Get.find();
          int index = editSubUnitTradingController.filteredItemList
              .indexOf(modelToUpdate);
          editSubUnitTradingController.filteredItemList[index] =
              response.response!.data!;
        } else {
          //if new property is created add it into the
          //Profile -> MyTrading -> Auction
          EditSubUnitTradingController editAuctionTradingController =
              Get.find();
          editAuctionTradingController.filteredItemList
              .insert(0, response.response!.data!);
        }
        AppPopUps.showDialogContent(
            title: 'Success',
            onCancelPress: () {
              Get.back();
            },
            onOkPress: () {
              Get.back();
            },
            description: response.response?.responseMessage ?? 'Success',
            dialogType: DialogType.SUCCES);
        completion();
      } else {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: AppConstants.defaultErrorString,
            dialogType: DialogType.ERROR);
      }
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }

  ///properties images uploading/////
  void _uploadImages(
      {required onComplete, required AuctionFileModel model}) async {
    Map<String, dynamic> map = {};

    /* for (var i = 0; i < picturesList.length; i++) {
      map['file[$i]'] = await dio.MultipartFile.fromFile(picturesList[i].path,
          filename: "image");
    }*/

    int i = 0;
    await Future.forEach(picturesList, (element) async {
      map['file[$i]'] = await dio.MultipartFile.fromFile(picturesList[i].path,
          filename: "file[$i].png");
      i++;
    });

    map['property_files_fk'] = model.id;
    map['len'] = picturesList.length;
    var data = dio.FormData.fromMap(map);

    printWrapped(data.fields.toString());
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.postFileImages,
              body: data,
            ),
            create: () => APIResponse<APIResponse>(decoding: false),
            apiFunction: _uploadImages)
        .then((response) {
      if ((response.response?.success ?? false)) {
        onComplete();
      } else {
        isLoading.value = false;
        AppPopUps.showDialogContent(
            title: 'Error',
            description: "Failed to post pictures",
            dialogType: DialogType.ERROR);
      }
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }

  Future<List<CountryModel>> getCountriesList() async {
    String data = await rootBundle.loadString('assets/all_countries.json');
    final List jsonResult = json.decode(data);
    return jsonResult.map((e) => CountryModel.fromJson(e)).toList();
  }
}
