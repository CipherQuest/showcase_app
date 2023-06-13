import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:zeerac_flutter/modules/users/models/agency_model.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

import '../../../dio_networking/api_client.dart';
import '../../../dio_networking/api_response.dart';
import '../../../dio_networking/api_route.dart';
import '../../../dio_networking/app_apis.dart';
import '../../../utils/app_pop_ups.dart';
import '../../../utils/user_defaults.dart';

class AgencySearchTabController extends GetxController {
  RxBool isLoading = false.obs;

  RxBool filterVisible = false.obs;

  RxList<AgencyModel?> agenciesList = <AgencyModel?>[].obs;

  int pageToLoadIndex = 1;
  bool hasNextPage = true;
  String? activeFilter;

  ScrollController itemScrollController = ScrollController();

  String prevSearchController = '';
  TextEditingController searchController = TextEditingController();

  //cache search
  RxList<AgencyModel?> copyAgenciesList = <AgencyModel?>[].obs;
  RxList<AgencyModel?> copySearchedAgenciesList = <AgencyModel?>[].obs;

  bool onlyOnce = true;
  String searchItem = '';

  //filter controllers
  TextEditingController cityFilterController = TextEditingController();
  TextEditingController areaFilterController = TextEditingController();

  bool hasSearchedByTyping = false;

  @override
  void onInit() {
    print('check agency start');
    loadAgency(onComplete: (AgencyResponseModel agencyResponseModel) {});
    searchController.addListener(() {
      if (searchController.text.isEmpty && hasSearchedByTyping) {
        hasSearchedByTyping = false;
        getCacheData();
      }
    });

    super.onInit();
  }

  void loadAgency({required onComplete}) {
    isLoading.value = true;
    searchItem = searchController.text.trim();
    Map<String, dynamic> body = {
      //"order_by": activeFilter ?? '',
      'search': searchController.text.trim(),
      'page': pageToLoadIndex,
      'city': cityFilterController.text,
      'area': areaFilterController.text
    };

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.loadAgencies,
              body: body,
            ),
            create: () => APIResponse<AgencyResponseModel>(
                create: () => AgencyResponseModel()),
            apiFunction: loadAgency)
        .then((response) {
      isLoading.value = false;
      if (hasNextPage) {
        if ((response.response?.data?.count ?? 0) > 0) {
          if ((response.response?.data?.next ?? '').isNotEmpty) {
            pageToLoadIndex++;
            hasNextPage = true;
          } else {
            hasNextPage = false;
          }
        }

        agenciesList
            .addAll(response.response!.data!.results as Iterable<AgencyModel?>);

        if (onlyOnce) {
          copyAgenciesList.addAll(agenciesList);
          onlyOnce = false;
        }
        onComplete(response.response?.data);
      } else {
        AppPopUps.showDialogContent(
            title: 'Alert',
            description: 'No result found',
            dialogType: DialogType.INFO);
      }
    }).catchError((error) {
      isLoading.value = false;
      PrintError('agencySearchTabController', 'loadAgency', error.toString());
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }

  void reset() {
    hasNextPage = true;
    pageToLoadIndex = 1;
    agenciesList.clear();
  }

  bool onScrollNotification(ScrollNotification notification) {
    print('Hello');
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;

      if (before == max) {
        //printWrapped("end of the page");

        if (hasNextPage) {
          loadAgency(onComplete: (propertyListingModel) {});
        }
        // load next page
        // code here will be called only if scrolled to the very bottom
      }
    }
    return true;
  }

  getCacheData() {
    reset();
    agenciesList.addAll(copyAgenciesList);
  }

  void clearFilters() {
    searchController.clear();
    cityFilterController.clear();
    areaFilterController.clear();

    getCacheData();
  }
}
