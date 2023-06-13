import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:zeerac_flutter/common/app_constants.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';

import '../../../dio_networking/api_client.dart';
import '../../../dio_networking/api_response.dart';
import '../../../dio_networking/api_route.dart';
import '../../../dio_networking/app_apis.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_pop_ups.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/helpers.dart';
import '../../../utils/user_defaults.dart';

class PropertySearchTabController extends GetxController
    with GetTickerProviderStateMixin {
  RxBool isSearchingResultFound = false.obs;
  RxBool isLoading = false.obs;
  final ItemScrollController itemScrollController = ItemScrollController();
  RxList<PropertyModel> propertiesList = <PropertyModel>[].obs;
  List<LatLng> latLngLists = [];
  RxInt selectedIndex = (-1).obs;
  TextEditingController searchController = TextEditingController();
  int pageToLoadIndex = 1;
  bool hasNextPage = false;
  RxInt totalProperties = 0.obs;

  GoogleMapController? googleMapController;
  late CameraPosition initialPosition;
  RxSet<Marker> markers = <Marker>{}.obs;
  bool onlyOnce = false;

  var tabs = [
    const Tab(text: 'All'),
    const Tab(text: 'Sell'),
    const Tab(text: 'Rent'),
    const Tab(text: 'Lease'),
  ];

  late TabController propertySearchTypeTab;

  double upperPropertySize = (0.0);
  double lowerPropertySize = (0.0);
  double upperPropertyPrice = (1000.0);
  double lowerPropertyPrice = (0.0);
  RxString selectedBath = 'Any'.obs;
  RxString selectedBed = 'Any'.obs;
  RxString selectedStores = 'Any'.obs;
  RxSet<String> selectedAmenties = <String>{}.obs;
  RxString selectedCountry = ''.obs;
  RxString selectedPredictionCity = ''.obs;
  RxString selectedPredictionArea = ''.obs;
  RxString selectedSpaceUnitKey = AppConstants.spaceUnits.keys.first.obs;
  RxString selectedSpaceUnitKeyFilterListing =
      AppConstants.spaceUnitsFilterListing.keys.first.obs;
  RxString selectedCurrencyTypeKey = AppConstants.currenciesType.keys.first.obs;
  RxString selectedCurrencyTypeKeyFilterListing =
      AppConstants.currenciesTypeFilterListing.keys.first.obs;
  RxString selectedPropertyType =
      AppConstants.propertiesType.entries.first.value.obs;
  RxString selectedPropertyTypeFilterListing =
      AppConstants.propertiesTypeFilterListing.entries.first.value.obs;

  RxString sortByKey = AppConstants.propertiesSortBy.keys.first.obs;

  void resetFilters() {
    propertySearchTypeTab.index = 0;
    sortByKey.value = AppConstants.propertiesSortBy.keys.first;
    upperPropertySize = (1000.0);
    lowerPropertySize = (0.0);
    upperPropertyPrice = (1000.0);
    lowerPropertyPrice = (0.0);
    selectedBath.value = 'Any';
    selectedBed.value = 'Any';
    selectedStores.value = 'Any';
    selectedAmenties.clear();
    selectedCountry.value = '';
    selectedPredictionCity.value = '';
    selectedPredictionArea.value = '';
    selectedSpaceUnitKey.value = AppConstants.spaceUnits.keys.first;
    selectedCurrencyTypeKey.value = AppConstants.currenciesType.keys.first;
    selectedPropertyType.value =
        AppConstants.propertiesType.entries.first.value;
  }

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    googleMapController?.setMapStyle(AppConstants.googleMapStyle);
    updateLatLngBoundsMarkers();
  }

  bool hasSearchedByTyping = false;

  @override
  void onInit() {
    propertySearchTypeTab = TabController(length: tabs.length, vsync: this);
    resetListResults();
    loadListings(
        onComplete: (PropertyListingResponseModel propertyListingModel) {},
        onlyOnce: true);

    searchController.addListener(() {
      if (searchController.text.isEmpty && hasSearchedByTyping) {
        hasSearchedByTyping = false;
        resetListResults();
        loadListings(
            onComplete: (PropertyListingResponseModel propertyListingModel) {});
      }
    });
    initialPosition = const CameraPosition(
      ///if not found then showing office address
      target: AppConstants.officeLatLng,
      zoom: 14.4746,
    );
    super.onInit();
  }

  void addRemoveAmenities(String feature) {
    if (selectedAmenties.contains(feature)) {
      selectedAmenties.remove(feature);
    } else {
      selectedAmenties.add(feature);
    }
  }

  bool checkIfAnyFilter() {
    if (propertySearchTypeTab.index != 0 ||
        selectedPropertyTypeFilterListing.value != 'All' ||
        selectedCurrencyTypeKeyFilterListing.value != 'None' ||
        sortByKey.value != 'None' ||
        upperPropertyPrice - lowerPropertyPrice > 1000 ||
        selectedSpaceUnitKeyFilterListing.value != 'None' ||
        upperPropertySize - lowerPropertySize > 1 ||
        selectedBed.value != 'Any' ||
        selectedBath.value != 'Any' ||
        searchController.text.isNotEmpty ||
        selectedAmenties.isNotEmpty) {
      return true;
    }
    return false;
  }

  void loadListings({required onComplete, bool onlyOnce = false}) {
    isLoading.value = true;

    Map<String, dynamic> body = {};

    // if (onlyOnce) {
    //   body = {
    //     'search_place': 'pakistan',
    //     'order_by': 'recent',
    //     'page': pageToLoadIndex
    //   };
    // } else {
    if (checkIfAnyFilter()) {
      body['page'] = pageToLoadIndex;
      if (searchController.text.isNotEmpty) {
        body['search'] = searchController.text.trim();
      }
      if (propertySearchTypeTab.index != 0) {
        body['purpose'] = propertySearchTypeTab.index == 1
            ? 'sell'
            : propertySearchTypeTab.index == 2
                ? 'rent'
                : 'lease';
      }
      if (selectedPropertyTypeFilterListing.value != 'All') {
        body['type'] = selectedPropertyTypeFilterListing.value;
      }
      if (selectedCurrencyTypeKeyFilterListing.value != 'None') {
        body['currency'] = selectedCurrencyTypeKeyFilterListing.value;
      }
      if (sortByKey.value != 'None') {
        body['order_by'] = sortByKey.value;
      }
      if (upperPropertyPrice - lowerPropertyPrice > 1000) {
        body['price_min'] = lowerPropertyPrice;
        body['price_max'] = upperPropertyPrice;
      }
      if (selectedSpaceUnitKeyFilterListing.value != 'None') {
        body['unit'] = selectedSpaceUnitKeyFilterListing.value;
      }
      if (upperPropertySize - lowerPropertySize > 1) {
        body['size_min'] = lowerPropertySize;
        body['size_max'] = upperPropertySize;
      }
      if (selectedBed.value != 'Any') {
        body['bedrooms'] = selectedBed.value;
      }
      if (selectedBath.value != 'Any') {
        body['bathrooms'] = selectedBed.value;
      }
      if (selectedAmenties.isNotEmpty) {
        if (selectedAmenties.contains('tv_lounge')) {
          body['tv_lounge'] = 'True';
        }
        if (selectedAmenties.contains('laundry_room')) {
          body['laundry_room'] = 'True';
        }
        if (selectedAmenties.contains('kitchen')) {
          body['kitchen'] = 'True';
        }
        if (selectedAmenties.contains('balcony')) {
          body['balcony'] = 'True';
        }
        if (selectedAmenties.contains('garden')) {
          body['garden'] = 'True';
        }
        //selectedAmenties.contains(element)
      }
    } else {
      body = {
        'search_place': 'pakistan',
        'order_by': 'recent',
        'page': pageToLoadIndex
      };
    }

    // if (selectedPropertyType.value != 'All') {
    //   body["type"] = selectedPropertyType.value;
    // }

    // if (sortByKey.value != 'Select') {
    //   body['order_by'] = AppConstants.propertiesSortBy[sortByKey.value];
    // }
    // if (!((selectedBed.value == 'Any') || selectedBed.value == '5+')) {
    //   body["bedrooms"] = selectedBed.value;
    // }
    // if (!((selectedBath.value == 'Any') || selectedBath.value == '5+')) {
    //   body["bathrooms"] = selectedBath.value;
    // }

    // if (selectedSpaceUnitKey.value.isNotEmpty) {
    //   body['unit'] = AppConstants.spaceUnits[selectedSpaceUnitKey];
    // }

    // if (selectedCurrencyTypeKey.value.isNotEmpty) {
    //   body["currency"] =
    //       AppConstants.currenciesType[selectedCurrencyTypeKey.value];
    // }

    // final purpose = tabs.elementAt(propertySearchTypeTab.index).text.toString();
    // if (purpose != 'All') {
    //   body["purpose"] = purpose;
    // }

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.loadProperties,
              body: body,
            ),
            create: () => APIResponse<PropertyListingResponseModel>(
                create: () => PropertyListingResponseModel()),
            apiFunction: loadListings)
        .then((response) {
      isLoading.value = false;
      final PropertyListingResponseModel? responseModel =
          response.response?.data;
      totalProperties.value = responseModel!.count ?? 0;
      if ((responseModel?.count ?? 0) > 0) {
        if ((responseModel?.next ?? '').isNotEmpty) {
          pageToLoadIndex++;
          hasNextPage = true;
        } else {
          hasNextPage = false;
        }
        isSearchingResultFound.value = true;
        propertiesList.addAll(responseModel?.results ?? []);
        updateLatLngBoundsMarkers();
        onComplete(responseModel);
      } else {
        AppPopUps.showDialogContent(
            title: 'Alert',
            description: 'No result found',
            dialogType: DialogType.info);
      }
    }).catchError((error) {
      isLoading.value = false;
      PrintError(
          'propertySearchTabController', 'loadListings', error.toString());
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.error);
      return Future.value(null);
    });
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;

      if (before == max) {
        printWrapped("end of the page");

        if (hasNextPage) {
          loadListings(onComplete: (propertyListingModel) {});
        }
        // load next page
        // code here will be called only if scrolled to the very bottom
      }
    }
    return false;
  }

  ////google maps......
  Future<void> addMarker(
      {required int id,
      required LatLng mLatLng,
      required String mTitle,
      required String mDescription}) async {
    markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(id.toString()),
      position: mLatLng,
      infoWindow: InfoWindow(title: mTitle, snippet: mDescription),
      onTap: () {
        print("value $id");
        selectedIndex.value = id;
        itemScrollController.scrollTo(
            index: id, duration: const Duration(microseconds: 300));

        print(propertiesList.elementAt(id).id);
      },
      icon: BitmapDescriptor.fromBytes(
        await AppUtils.getBytesFromAsset(Assets.imagesNewMarkerHomePng, 78),
      ),
    ));
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > (x1 ?? 0)) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > (y1 ?? 0)) y1 = latLng.longitude;
        if (latLng.longitude < (y0 ?? double.infinity)) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1 ?? 0, y1 ?? 0),
      southwest: LatLng(x0 ?? 0, y0 ?? 0),
    );
  }

  Future<void> checkCameraLocation(
      CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }

  void resetListResults() {
    pageToLoadIndex = 1;
    hasNextPage = false;
    propertiesList.clear();
    latLngLists.clear();
    markers.value.clear();
  }

  Future<void> updateLatLngBoundsMarkers() async {
    //isLoading.value = true;
    int index = 0;
    await Future.forEach<PropertyModel>(propertiesList, (element) async {
      if ((element.lat != null) && (element.lng != null)) {
        LatLng latLng = LatLng(element.lat!, element.lng!);
        latLngLists.add(latLng);

        await addMarker(
            id: index,
            mLatLng: latLng,
            mTitle: element.title ?? '',
            mDescription: element.description ?? '');
        index++;
      }
    });
    // isLoading.value = false;

    try {
      if (latLngLists.length > 1 && googleMapController != null) {
        LatLngBounds bounds = _boundsFromLatLngList(latLngLists);
        CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);
        await checkCameraLocation(cameraUpdate, googleMapController!);
      }
    } catch (e) {
      print(
          'error adding bounds for location property search tab controller....');
      print(e.toString());
    }
  }

  Future<String> toggleFavorite(propertyId) async {
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
}
