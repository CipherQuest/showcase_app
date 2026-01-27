import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/controllers/property_listing_page_controller.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/modules/users/pages/home/widgets/most_popular_widget.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_listing_widgets.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

import '../../../../common/loading_widget.dart';

class PropertyListingPage extends GetView<PropertyListingPageController>
    with PropertyListingWidgets {
  PropertyListingPage({Key? key}) : super(key: key);
  static const id = '/PropertyListingPage';
  final PropertyListingResponseModel? _propertyListingModel = Get.arguments[0];
  final String? activeFilter = Get.arguments[1];

  @override
  Widget build(BuildContext context) {
    return GetX<PropertyListingPageController>(initState: (state) {
      print(_propertyListingModel?.results.length);
      controller.initialiseValue(_propertyListingModel, filter: activeFilter);
    }, builder: (_) {
      return Scaffold(
          appBar: myAppBar(
              title: 'Properties ${controller.propertiesList.length.toString()}'
                  .toUpperCase()),
          body: Stack(
            children: [
              if (controller.propertiesList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: NotificationListener(
                    onNotification: controller.onScrollNotification,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.propertiesList.length ?? 0,
                      itemBuilder: (context, index) {
                        PropertyModel propertyModel =
                            controller.propertiesList.elementAt(index);
                        String imageUrl = (propertyModel.image.isNotEmpty)
                            ? (ApiConstants.baseUrl +
                                (propertyModel.image.first.image!.toString()))
                            : ApiConstants.imageNetworkPlaceHolder;
                        return MostPopularWidget(
                          imageUrl: imageUrl,
                          propertyModel: propertyModel,
                        );
                      },
                    ),
                  ),
                ),
              if (controller.isLoading.isTrue)
                LoadingWidget(
                  onCancel: () {
                    controller.isLoading.value = false;
                  },
                ),
            ],
          ));
    });
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
