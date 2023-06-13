import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as d;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/app_constants.dart';
import 'package:zeerac_flutter/modules/users/controllers/favorite_tab_controllers/agency_favorite_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/save_list_controller.dart';
import 'package:zeerac_flutter/modules/users/models/agency_model.dart';
import 'package:zeerac_flutter/modules/users/models/agents_listing_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/company_details_model.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

import '../../../dio_networking/api_client.dart';
import '../../../dio_networking/api_response.dart';
import '../../../dio_networking/api_route.dart';
import '../../../dio_networking/app_apis.dart';
import '../../../utils/app_pop_ups.dart';
import '../models/projects_response_model.dart';
import '../pages/agency_listing/agency_widgets.dart';
import 'agency_search_tab_controller.dart';

class AgencyDetailController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isCompanyProjectsLoading = false.obs;
  RxBool isCompanyListingsLoading = false.obs;
  RxBool isCompanyAgentsLoading = false.obs;
  RxBool isPartnerProjectsLoading = false.obs;
  RxBool requestToJoinAgencyLoading = false.obs;
  RxBool showPlusIcon = false.obs;
  RxBool isAdmin = false.obs;
  RxBool isUserLoggedIn = false.obs;
  AgencyModel? agencyModel;
  RxList<ProjectModel> projectsList = <ProjectModel>[].obs;
  RxList<PropertyModel> listingsList = <PropertyModel>[].obs;
  RxList<AgentsModel> agentsList = <AgentsModel>[].obs;
  RxList<AgentsModel> notAssociatedAgentsList = <AgentsModel>[].obs;
  RxList<ProjectModel> partnerProjectsList = <ProjectModel>[].obs;
  int currentUserType = 0;

  TextEditingController emailController = TextEditingController();

  RxBool filterVisible = false.obs;

  //add to favorites
  RxBool isFavorited = false.obs;
  final favoritedAgentsList = Get.arguments[1];
  RxBool favoriteLoader = false.obs;

  int indexOfAgency = -1;
  bool fromFavoriteTab = false;

  initValues(
      AgencyModel? agencyModel, int indexOfAgency, bool fromFavoriteTab) {
    this.agencyModel = agencyModel;
    this.indexOfAgency = indexOfAgency;
    this.fromFavoriteTab = fromFavoriteTab;

    if (UserDefaults.getCurrentUserId() != null) {
      currentUserType = UserDefaults.getUserSession()!.userType ?? 0;
      isUserLoggedIn.value = true;
    } else {
      isUserLoggedIn.value = false;
    }
  }

  void loadAgencyProjects(int companyId) async {
    isCompanyProjectsLoading.value = true;
    projectsList.clear();
    var dio = d.Dio();
    try {
      var response = await dio
          .get('${ApiConstants.baseUrl}users/company-project/${companyId}');
      if (response.data['result']['projects'] != null) {
        response.data['result']['projects'].forEach((v) {
          projectsList.add(ProjectModel.fromJson(v));
        });
      }

      isCompanyProjectsLoading.value = false;
    } catch (err) {
      isCompanyProjectsLoading.value = false;
    }
  }

  void loadAgencyListings(int companyId) async {
    isCompanyListingsLoading.value = true;
    projectsList.clear();
    Map<String, dynamic> queryParams = {'company': companyId};
    var dio = d.Dio();
    try {
      var response = await dio.get(
          '${ApiConstants.baseUrl}users/agency-listings',
          queryParameters: queryParams);

      if (response.data['result']['results'] != null) {
        response.data['result']['results'].forEach((v) {
          listingsList.add(PropertyModel.fromJson(v));
          print(v);
        });
      }
      isCompanyListingsLoading.value = false;
    } catch (err) {
      isCompanyListingsLoading.value = false;
    }
  }

  void loadAgencyAgents(int companyId) async {
    print('inside');
    isCompanyAgentsLoading.value = true;
    projectsList.clear();
    Map<String, dynamic> queryParams = {'company_id': companyId};
    var dio = d.Dio();
    try {
      var response = await dio.get('${ApiConstants.baseUrl}users/new_agents/',
          queryParameters: queryParams);

      if (response.data['results'] != null) {
        response.data['results'].forEach((v) {
          agentsList.add(AgentsModel.fromJson(v));
          print(v);
        });
      }
      isCompanyAgentsLoading.value = false;
    } catch (err) {
      print('err is $err');
      isCompanyAgentsLoading.value = false;
    }
  }

  void loadPartnerProjects() async {
    print('inside');
    isPartnerProjectsLoading.value = true;
    projectsList.clear();

    var dio = d.Dio();
    try {
      var response = await dio.get(
        '${ApiConstants.baseUrl}users/new-project/',
      );

      if (response.data['result']['results'] != null) {
        response.data['result']['results'].forEach((v) {
          partnerProjectsList.add(ProjectModel.fromJson(v));
        });
      }
      isPartnerProjectsLoading.value = false;
    } catch (err) {
      print('err is $err');
      isPartnerProjectsLoading.value = false;
    }
  }

  checkIfAdmin(int adminId) {
    int loggedIn = int.parse(UserDefaults.getCurrentUserId() ?? '-1');
    print('id is $loggedIn');
    print('admin is $adminId');

    if (loggedIn == adminId) {
      print('yes');
      showPlusIcon.value = true;
      isAdmin.value = true;
    } else {
      print('no');
      showPlusIcon.value = false;
      isAdmin.value = false;
    }
  }

  getNotAssociatedAgents(BuildContext context, int agencyId) async {
    print('inside');
    isLoading.value = true;

    Map<String, dynamic> queryParams = {'private_agent': true};
    var dio = d.Dio();
    try {
      var response = await dio.get('${ApiConstants.baseUrl}users/agents',
          queryParameters: queryParams);

      if (response.data['result'] != null) {
        response.data['result'].forEach((v) {
          notAssociatedAgentsList.add(AgentsModel.fromJson(v));
          print(v);
        });
      }
      isLoading.value = false;
      Get.dialog(AddAgentToCompanyWidget(
          containerHeight: context.height,
          containerWidth: context.width,
          notAssociatedAgentsList: notAssociatedAgentsList.value,
          agencyId: agencyId));
    } catch (err) {
      print('err is $err');
      isLoading.value = false;
    }
  }

  sendInviteLinkToAgent(int agencyId, int agentId, BuildContext context) async {
    print('$agencyId, $agentId');
    var dio = d.Dio();

    var formData =
        d.FormData.fromMap({'user_id': agentId, 'agency_id': agencyId});
    try {
      var response = await dio
          .post('${ApiConstants.baseUrl}users/send-add-agent/', data: formData);
      if (response.data['status'] == true) {
        Get.back();
        AppPopUps.showSnackBar(
            message: response.data['message'],
            context: context,
            color: Colors.green);
      }
    } catch (err) {
      print('err is $err');
    }
  }

  sendInviteLinkUsingEmail(int agencyId, BuildContext context) async {
    var dio = d.Dio();
    print('email is ${emailController.text}');
    Map<String, dynamic> queryParameters = {'email': emailController.text};
    try {
      var response1 = await dio.get(
          '${ApiConstants.baseUrl}users/unique-email/',
          queryParameters: queryParameters);
      print(response1);
      if (response1.data['status'] == true) {
        var formData = d.FormData.fromMap(
            {'email': emailController.text, 'agency_id': agencyId});
        var response2 = await dio.post(
            '${ApiConstants.baseUrl}users/send-add-agent/',
            data: formData);
        if (response2.data['status'] == true) {
          Get.back();
          AppPopUps.showSnackBar(
              message: response2.data['message'],
              context: context,
              color: Colors.green);
        } else {
          AppPopUps.showSnackBar(
              message: response2.data['message'],
              context: context,
              color: Colors.red);
        }
      } else {
        AppPopUps.showSnackBar(
            message: response1.data['message'],
            context: context,
            color: Colors.red);
      }
    } catch (err) {}
  }

  addToFavorited(
    int id,
  ) async {
    favoriteLoader.value = true;
    final dio = Dio();
    final companyId = id;
    print('company is is $id');
    int currentUserId = int.parse(UserDefaults.getCurrentUserId() ?? '-1');

    Map<String, dynamic> headers = {};
    String token = UserDefaults.getApiToken()!.trim() ?? '';
    headers['Authorization'] = "$token";
    try {
      var response = await dio.post(
        '${ApiConstants.baseUrl}users/company/$companyId/toggle_favourite/',
        options: Options(
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
            headers: headers),
      );
      if (response.data["status"] == true) {
        isFavorited.value = !isFavorited.value;

        AgencySearchTabController agencySearchTabController = Get.find();
        AgencyFavoriteController agencyFavoriteController = Get.find();

        if (response.data['message'] == "Agency removed from favourites") {
          if (fromFavoriteTab) {
            agencyFavoriteController.favoritedAgenciesList
                .removeAt(indexOfAgency);
            agencyFavoriteController.onlyOnce = true;
          } else {
            agencySearchTabController.agenciesList[indexOfAgency]!.favouritedBy!
                .remove(currentUserId);

            agencyFavoriteController.onlyOnce = true;
          }
        } else if (response.data['message'] == "Agency added to favourites") {
          agencySearchTabController.agenciesList[indexOfAgency]!.favouritedBy!
              .add(currentUserId);
          agencyFavoriteController.onlyOnce = true;
        }
        favoriteLoader.value = false;
      }
    } catch (err) {
      favoriteLoader.value = false;
      print('err is $err');
      favoriteLoader.value = false;
      isLoading.value = false;
    }
  }

  checkIfFavorited() {
    int currentUserId = int.parse(UserDefaults.getCurrentUserId() ?? '-1');
    if (currentUserId != -1) {
      isFavorited.value = agencyModel!.favouritedBy!.contains(currentUserId);
    }
  }

  requestToJoinAgency(BuildContext context) async {
    requestToJoinAgencyLoading.value = true;
    final dio = Dio();
    int currentUserId = int.parse(UserDefaults.getCurrentUserId() ?? '-1');
    Map<String, dynamic> data = {'agency': agencyModel!.id.toString() ?? '0'};
    Map<String, dynamic> headers = {};
    String token = UserDefaults.getApiToken()!.trim() ?? '';
    headers['Authorization'] = "$token";
    try {
      var response = await dio.post(
        '${ApiConstants.baseUrl}users/agency-join-request/',
        data: data,
        options: Options(
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
            headers: headers),
      );
      print(response.data);
      if (response.data["status"] == true) {
        requestToJoinAgencyLoading.value = false;
        AppPopUps.showSnackBar(
            message: response.data['message'],
            context: context,
            color: Colors.green);
      } else {
        requestToJoinAgencyLoading.value = false;
        AppPopUps.showSnackBar(
            message: response.data['message'],
            context: context,
            color: Colors.green);
      }
    } catch (err) {
      print('err is $err');
      requestToJoinAgencyLoading.value = false;
    }
  }
}
