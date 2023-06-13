import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zeerac_flutter/common/app_constants.dart';
import 'package:zeerac_flutter/generated/assets.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/my_application.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

import '../../../../utils/app_utils.dart';

class EditListingDetailController extends GetxController {
  RxBool isLoading = false.obs;

  List<String> featuresList = [];

  RxBool isAlreadyLiked = false.obs;
  RxBool isAlreadyInCompareList = false.obs;

  RxSet<Marker> markers = <Marker>{}.obs;
  late CameraPosition propertyPosition;
  late PropertyModel? property;
  GoogleMapController? googleMapController;

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    googleMapController?.setMapStyle(AppConstants.googleMapStyle);
    addMarker(
        id: property?.id ?? 0,
        mLatLng: LatLng(property?.lat ?? 0.0, property?.lng ?? 0.0),
        mTitle: property?.title ?? '',
        mDescription: property?.description ?? '');
  }

  void initValues(PropertyModel? property) {
    this.property = property;
    try {
      if (property != null) {
        checkIsCompared(isFirst: true);
        checkIsLikes(isFirst: true);
        Get.find<HomeController>().addProperyInRecent(property: property);
      }
    } catch (_) {}

    featuresList.clear();
    // if (property?.features?.internet ?? false) {
    //   featuresList.add('Internet');
    // }
    // if (property?.features?.electricity ?? false) {
    //   featuresList.add('Electricity');
    // }
    // if (property?.features?.furnished ?? false) {
    //   featuresList.add('Furnished');
    // }
    // if (property?.features?.landline ?? false) {
    //   featuresList.add('Landline');
    // }
    // if (property?.features?.parking ?? false) {
    //   featuresList.add('Parking');
    // }
    // if (property?.features?.sewerage ?? false) {
    //   featuresList.add('Sewerage');
    // }
    // if (property?.features?.suigas ?? false) {
    //   featuresList.add('Sui Gas');
    // }

    propertyPosition = CameraPosition(
      ///if not found then showing office address
      target: LatLng(property?.lat ?? 0.0, property?.lng ?? 0.0),
      zoom: 14.4746,
    );
  }

  checkIsLikes({required isFirst}) {
    if (property != null) {
      UserDefaults.checkIfIsInFavListOfProperties(property!, isFirst: isFirst)
          .then((value) {
        isAlreadyLiked.value = value;
        if (!isFirst) {
          AppPopUps.showSnackBar(
              message: value
                  ? 'Added to favourites list'
                  : 'Removed from favourites',
              context: myContext!);
        }
      });
    }
  }

  //check in compared

  checkIsCompared({required isFirst}) {
    if (property != null) {
      UserDefaults.checkIfIsInCompareList(property!, isFirst: isFirst)
          .then((value) {
        isAlreadyInCompareList.value = value;
        if (!isFirst) {
          AppPopUps.showSnackBar(
              message:
                  value ? 'Added to compared list' : 'Removed from compared',
              context: myContext!);
        }
      });
    }
  }

  Future<void> addMarker(
      {required int id,
      required LatLng mLatLng,
      required String mTitle,
      required String mDescription}) async {
    markers.clear();
    markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(id.toString()),
      position: mLatLng,
      infoWindow: InfoWindow(title: mTitle, snippet: mDescription),
      onTap: () {},
      icon: BitmapDescriptor.fromBytes(
        await AppUtils.getBytesFromAsset(Assets.imagesNewMarkerHomePng, 78),
      ),
    ));
  }
}
