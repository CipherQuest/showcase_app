import 'package:another_stepper/dto/stepper_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/api_route.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/controllers/agent_search_tab_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/favorite_tab_controllers/agent_favorite_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/save_list_controller.dart';
import 'package:zeerac_flutter/modules/users/models/agents_listing_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

import '../../../utils/user_defaults.dart';

class AgentDetailController extends GetxController {
  RxBool isLoading = false.obs;
  String from = '';

  TextEditingController searchController = TextEditingController();
  RxList<PropertyModel>? agentsPropertiesList = <PropertyModel>[].obs;

  int pageToLoad = 1;
  bool hasNewPage = false;
  AgentsModel? agentsModel;
  RxList<StepperData> stepperData = <StepperData>[].obs;

  RxBool isFavorited = false.obs;
  final favoritedAgentsList = Get.arguments[1];

  int indexOfAgent = -1;
  bool fromFavoriteTab = false;

  RxBool favoriteLoader = false.obs;

  void initValues(
      AgentsModel agentsModel, int indexOfAgent, bool fromFavoriteTab) {
    this.agentsModel = agentsModel;
    this.indexOfAgent = indexOfAgent;
    this.fromFavoriteTab = fromFavoriteTab;
    stepperData.value = agentsModel.experience!.map<StepperData>((e) {
      return StepperData(
          //city: e.city as String,
          title: StepperText(e.companyName as String,
              textStyle: AppTextStyles.textStyleBoldBodyMedium
                  .copyWith(color: AppColor.primaryBlueColor)),
          subtitle: StepperText('${e.startDate!} -  ${e.endDate ?? "Working"}',
              textStyle: AppTextStyles.textStyleNormalBodyMedium
                  .copyWith(color: AppColor.primaryBlueColor)));
    }).toList();
  }

  void loadAgentzPropertiesFromServer() {
    isLoading.value = true;
    Map<String, dynamic> body = {
      "agent": agentsModel?.id.toString(),
      "page": pageToLoad.toString(),
    };

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.agentzPropertyListing,
              body: body,
            ),
            create: () => APIResponse<PropertyListingResponseModel>(
                create: () => PropertyListingResponseModel()),
            apiFunction: loadAgentzPropertiesFromServer)
        .then((response) {
      isLoading.value = false;

      PropertyListingResponseModel? responseModel = response.response?.data;

      if (responseModel?.results != null) {
        if ((responseModel?.next ?? '').isNotEmpty) {
          pageToLoad++;
          printWrapped('has new page');
          hasNewPage = true;
        } else {
          hasNewPage = false;
        }
        agentsPropertiesList?.addAll(response.response!.data!.results!);
      }
    }).catchError((error) {
      isLoading.value = false;
    });
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;

      if (before == max) {
        if (hasNewPage) {
          printWrapped('reached at then end');
          loadAgentzPropertiesFromServer();
        }
        // load next page
        // code here will be called only if scrolled to the very bottom
      }
    }
    return false;
  }

  checkIfFavorited() {
    int currentUserId = int.parse(UserDefaults.getCurrentUserId() ?? '-1');
    if (currentUserId != -1) {
      isFavorited.value = agentsModel!.favouritedBy!.contains(currentUserId);
    }
  }

  addToFavorited({bool fromFavoriteTab = false}) async {
    favoriteLoader.value = true;
    final dio = Dio();
    final agentId = agentsModel!.id;
    int currentUserId = int.parse(UserDefaults.getCurrentUserId() ?? '-1');
    Map<String, dynamic> headers = {};
    String token = UserDefaults.getApiToken()!.trim() ?? '';
    headers['Authorization'] = "$token";

    try {
      var response = await dio.post(
        '${ApiConstants.baseUrl}users/agents/$agentId/toggle_favourite/',
        options: Options(
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
            headers: headers),
      );
      if (response.data["status"] == true) {
        AgentSearchTabController agentSearchTabController = Get.find();
        AgentFavoriteController agentFavoriteController = Get.find();
        isFavorited.value = !isFavorited.value;

        if (response.data['result']['message'] ==
            "Agent unfavourited successfully") {
          if (fromFavoriteTab) {
            agentFavoriteController.favoritedAgentsList.removeAt(indexOfAgent);
            agentSearchTabController.onlyOnce = true;
          } else {
            agentSearchTabController.agentsList[indexOfAgent]!.favouritedBy!
                .remove(currentUserId);

            agentFavoriteController.onlyOnce = true;
          }
        } else if (response.data['result']['message'] ==
            "Agent favourited successfully") {
          agentSearchTabController.agentsList[indexOfAgent]!.favouritedBy!
              .add(currentUserId);
          agentFavoriteController.onlyOnce = true;
        }

        favoriteLoader.value = false;
      }
    } catch (err) {
      favoriteLoader.value = false;
      print('err is $err');
    }
  }
}
