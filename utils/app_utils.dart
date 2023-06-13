import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeerac_flutter/common/app_constants.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/generated/assets.dart';
import 'package:zeerac_flutter/my_application.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

import '../dio_networking/api_client.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';
import '../modules/users/models/cities_model.dart';
import '../modules/users/models/notification_response_model.dart';
import 'app_pop_ups.dart';

class AppUtils {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = '${diff.inDays} DAY AGO';
      } else {
        time = '${diff.inDays} DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

  static void showMultiImagePicker(
      {required onComplete, required BuildContext context}) {
    _pickMultiImage(
        context: context,
        onCompletedd: (List<File?> fileList) {
          onComplete(fileList);
        });
  }

  static void showImagePicker({required BuildContext context, onComplete}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext x) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () async {
                      _pickImage(
                          source: 0,
                          onCompletedd: (File? file) {
                            print(file!.path.toString());
                            onComplete(file);
                          });

                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    _pickImage(
                        source: 1,
                        onCompletedd: (File file) {
                          onComplete(file);
                        });

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  static void showVideoPicker({required BuildContext context, onComplete}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext x) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () async {
                      _pickVideo(
                          source: 0,
                          onCompletedd: (File? file) {
                            print(file!.path.toString());
                            onComplete(file);
                          });

                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    _pickVideo(
                        source: 1,
                        onCompletedd: (File file) {
                          onComplete(file);
                        });

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  static void _pickMultiImage(
      {required onCompletedd, required BuildContext context}) async {
    try {
      Get.log('picking images');
      //todo some image not picking not giving error
      final List<XFile>? pickedFileList = await ImagePicker().pickMultiImage();
      Get.log('picked images length= ${pickedFileList?.length}.');
      if ((pickedFileList ?? []).isNotEmpty) {
        bool validate = true;
        for (var pickedFile in pickedFileList!) {
          int fileSize = await pickedFile.length();
          if (fileSize > 4500000) {
            validate = false;
          }
        }
        Get.log('images file validate =$validate');
        if (validate) {
          onCompletedd(pickedFileList.map((e) => File(e.path)).toList());
        } else {
          AppPopUps.showSnackBar(
              message: 'All images File size should be less than 5 mb',
              context: context);
        }
      } else {
        Get.log('No File selected.');
        return null;
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  static void _pickImage({required int source, required onCompletedd}) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
          source: source == 1 ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 50);
      if (pickedFile != null) {
        int fileSize = await pickedFile.length();
        printWrapped('file size = ${fileSize}');
        if (fileSize > 4500000) {
          AppPopUps.showSnackBar(
              message: 'File size should be less than 5 mb',
              context: myContext!);
        } else {
          onCompletedd(File(pickedFile.path));
        }
      } else {
        Get.log('No File selected.');
        return null;
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  static void _pickVideo({required int source, required onCompletedd}) async {
    try {
      final pickedFile = await ImagePicker().pickVideo(
          source: source == 1 ? ImageSource.camera : ImageSource.gallery);
      if (pickedFile != null) {
        int fileSize = await pickedFile.length();
        printWrapped('file size = ${fileSize}');
        if (fileSize > 10000000) {
          AppPopUps.showSnackBar(
              message: 'File size should be less than 1 mb',
              context: myContext!);
        } else {
          onCompletedd(File(pickedFile.path));
        }
      } else {
        Get.log('No File selected.');
        return null;
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  static Future<void> dialNumber(
      {required String phoneNumber, required BuildContext context}) async {
    final url = "tel:$phoneNumber";
    launchUriUrl(url);
  }

  static launchUriUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      AppPopUps.showSnackBar(message: "Unable to launch", context: myContext!);
    }
  }

  static void pickWebImage({required onCompleteWebUnit8List}) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var f = await image.readAsBytes();
      onCompleteWebUnit8List(f);
    } else {
      Get.log('No image selected.');
    }
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);

    ui.FrameInfo fi = await codec.getNextFrame();

    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static DropdownSearch<Predictions> _getCountrySearch(
      {required onChange, Predictions? initialItem, bool withBorder = false}) {
    return DropdownSearch<Predictions>(
      selectedItem: initialItem,
      itemAsString: (item) {
        return item.description ?? '';
      },
      clearButtonProps: const ClearButtonProps(isVisible: true, iconSize: 8),
      validator: (prediction) {
        return prediction == null ? 'Required' : null;
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
              border: withBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColor.greyColor))
                  : InputBorder.none,
              labelText: 'Country',
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: AppTextStyles.textStyleNormalBodySmall,
              filled: true,
              fillColor: AppColor.whiteColor,
              isDense: true)),
      popupProps: PopupProps.bottomSheet(
        showSearchBox: true,
        isFilterOnline: true,
        searchFieldProps: TextFieldProps(
          decoration:
              const InputDecoration(labelText: 'search for the country'),
          controller: TextEditingController(),
        ),
      ),
      items: AppConstants.countriesMap.keys
          .map((e) => Predictions(description: e.toString()))
          .toList(),
      onChanged: onChange,
    );
  }

  static DropdownSearch<Predictions> _getCitySearch(
      {required onChange,
      required String title,
      bool withBorder = false,
      Predictions? initialItem,
      String? country}) {
    return DropdownSearch<Predictions>(
      itemAsString: (item) {
        return item.description ?? '';
      },
      validator: (prediction) {
        return prediction == null ? 'Required' : null;
      },
      selectedItem: initialItem,
      clearButtonProps: const ClearButtonProps(isVisible: true, iconSize: 8),
      dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
              border: withBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColor.greyColor))
                  : InputBorder.none,
              labelText: title,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: AppTextStyles.textStyleNormalBodySmall,
              filled: true,
              fillColor: AppColor.whiteColor,
              isDense: true)),
      popupProps: PopupProps.bottomSheet(
        showSearchBox: true,
        isFilterOnline: true,
        bottomSheetProps: const BottomSheetProps(elevation: 10),
        searchFieldProps: TextFieldProps(
          decoration: const InputDecoration(labelText: 'search for the city'),
          controller: TextEditingController(),
        ),
      ),
      asyncItems: (String filter) async {
        var response = await Dio().get(
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=(cities)&key=${ApiConstants.googleApiKey}&components=country:$country",
          queryParameters: {"input": filter},
        );
        var models = CitySuggestions.fromJson(response.data);
        return Future.value(models.predictions);
      },
      onChanged: onChange,
    );
  }

  static DropdownSearch<Predictions> _getSingleAreaSearchDropDown(
      {required String cityName,
      required String country,
      required String title,
      Predictions? initialItem,
      bool withBorder = false,
      required onChange}) {
    return DropdownSearch<Predictions>(
      itemAsString: (item) {
        return item.description ?? '';
      },
      validator: (prediction) {
        return prediction == null ? 'Required' : null;
      },
      selectedItem: initialItem,
      clearButtonProps: const ClearButtonProps(isVisible: true, iconSize: 8),
      dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
              border: withBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColor.greyColor))
                  : InputBorder.none,
              labelText: title,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: AppTextStyles.textStyleNormalBodySmall,
              filled: true,
              fillColor: AppColor.whiteColor,
              isDense: true)),
      popupProps: PopupProps.bottomSheet(
        showSearchBox: true,
        bottomSheetProps: const BottomSheetProps(elevation: 10),
        isFilterOnline: true,
        searchFieldProps: TextFieldProps(
          decoration: const InputDecoration(labelText: 'search here..'),
          controller: TextEditingController(),
        ),
      ),
      asyncItems: (String filter) async {
        var response = await Dio().get(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=(regions)&key=${ApiConstants.googleApiKey}&components=country:$country',
          queryParameters: {"input": " $cityName,$filter}"},
        );
        var models = CitySuggestions.fromJson(response.data);
        return Future.value(models.predictions);
      },
      onChanged: onChange,
    );
  }

  static DropdownSearch<Predictions> getAreaMultiSearchDropDown(
      {required String cityName, required onChange}) {
    return DropdownSearch<Predictions>.multiSelection(
      itemAsString: (item) {
        return item.description ?? '';
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'Area',
              labelStyle: AppTextStyles.textStyleNormalBodySmall,
              filled: true,
              fillColor: AppColor.whiteColor,
              isDense: true)),
      popupProps: PopupPropsMultiSelection.bottomSheet(
          showSearchBox: true,
          isFilterOnline: true,
          bottomSheetProps: const BottomSheetProps(elevation: 10),
          searchFieldProps: TextFieldProps(
              decoration:
                  const InputDecoration(labelText: 'search for the area'),
              controller: TextEditingController())),
      asyncItems: (String filter) async {
        var response = await Dio().get(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&types=(regions)&key=${ApiConstants.googleApiKey}&components=country:pk',
          queryParameters: {"input": " $cityName,$filter}"},
        );
        var models = CitySuggestions.fromJson(response.data);
        return Future.value(models.predictions);
      },
      onChanged: onChange,
    );
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static Future<GeoData> getMapLocationAddressFromCoordinates(
      {required LatLng latlng}) async {
    return await Geocoder2.getDataFromCoordinates(
        latitude: latlng.latitude,
        longitude: latlng.longitude,
        googleMapApiKey: ApiConstants.googleApiKey);
  }

  static Widget getCountryDropDown(
      {required String title,
      bool withBorder = true,
      required dynamic onChange,
      Predictions? initialItem,
      Color labelColor = AppColor.primaryBlueColor}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.textStyleNormalBodyMedium
              .copyWith(color: labelColor),
        ),
        const SizedBox(height: 6),
        AppUtils._getCountrySearch(
          withBorder: withBorder,
          initialItem: initialItem,
          onChange: onChange,
        ),
      ],
    );
  }

  static Widget getCitySelectDropDown(
      {required String title,
      bool withBorder = true,
      required dynamic onChange,
      Predictions? initialItem,
      Color labelColor = AppColor.primaryBlueColor,
      required String country}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.textStyleNormalBodyMedium
              .copyWith(color: labelColor),
        ),
        const SizedBox(height: 6),
        _getCitySearch(
            title: title,
            withBorder: withBorder,
            onChange: onChange,
            initialItem: initialItem,
            country: country),
      ],
    );
  }

  static Widget getAreaSelectDropDown(
      {required String title,
      required String country,
      Predictions? initialItem,
      bool withBorder = true,
      required dynamic onChange,
      Color labelColor = AppColor.primaryBlueColor,
      required String city}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.textStyleNormalBodyMedium
              .copyWith(color: labelColor),
        ),
        const SizedBox(height: 6),
        AppUtils._getSingleAreaSearchDropDown(
            title: title,
            withBorder: withBorder,
            onChange: onChange,
            initialItem: initialItem,
            country: country,
            cityName: city),
      ],
    );
  }

  static postNotificationToApi({required Map<String, dynamic> body}) {
    print("sending notification to api");
    APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
        .request(
            route: APIRoute(
              APIType.postNotification,
              body: body,
            ),
            create: () => NotificationModel(),
            apiFunction: postNotificationToApi)
        .then((response) async {
      /////////this shit response needs to be changed....
      if ((response.response?.id != null)) {
        print("success to post notification api");
      } else {
        print("failed to post notification api");
      }
    }).catchError((error) {
      print("failed to decode post notification api = ${error.toString()}");
      return Future.value(null);
    });
  }

////changed to full screen widget......
  // static void placeBid(
  //     {required BuildContext context,
  //     required Map<String, dynamic> map,
  //     required Null Function(bool isSuccess) onComplete}) {
  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     barrierLabel: 'Dialog',
  //     barrierColor: Colors.transparent,
  //     transitionDuration: const Duration(milliseconds: 400),
  //     pageBuilder: (_, __, ___) {
  //       return Scaffold(
  //           backgroundColor: AppColor.blackColor.withAlpha(100),
  //           body: Container(
  //             child: Center(
  //               child: Container(
  //                   height: context.height * 0.6,
  //                   width: context.width * 0.8,
  //                   color: Colors.white,
  //                   child: Stack(
  //                     children: [
  //                       Stack(
  //                         clipBehavior: Clip.none,
  //                         children: [
  //                           Positioned(
  //                             top: -18,
  //                             right: -20,
  //                             child: IconButton(
  //                                 icon: const CircleAvatar(
  //                                   radius: 12,
  //                                   child: Icon(
  //                                     Icons.clear,
  //                                     color: AppColor.whiteColor,
  //                                     size: 18,
  //                                   ),
  //                                 ),
  //                                 onPressed: () {
  //                                   Get.back();
  //                                 }),
  //                           ),
  //                           Positioned.fill(
  //                             child: SvgViewer(
  //                               svgPath: Assets.iconsNewVerticalLines,
  //                               height: context.height * 6,
  //                               width: context.width,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [],
  //                       ),
  //                     ],
  //                   )),
  //             ),
  //           ));
  //     },
  //   );
  // }
// static void showAddressSearchDialog(
//     {required BuildContext context,
//     required dynamic onDone,
//     String city = '',
//     String country = '',
//     required TextEditingController controller}) {
//   showDialog(
//       builder: (BuildContext context) => AddressSearchDialog(
//             geoMethods: GeoMethods(
//               googleApiKey: ApiConstants.googleApiKey,
//               language: 'en',
//               city: city,
//               country: country,
//             ),
//             controller: controller,
//             onDone: onDone,
//           ),
//       context: context);
// }
}
