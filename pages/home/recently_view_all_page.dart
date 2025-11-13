import "package:flutter/material.dart";
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:zeerac_flutter/modules/users/controllers/recently_view_all_controller.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/modules/users/pages/home/widgets/most_popular_widget.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

class RecentlyViewAllPage extends GetView<RecentlyViewAllPageController> {
  final List<PropertyModel> propertiesList;
  const RecentlyViewAllPage({super.key, required this.propertiesList});
  static const id = "/RecentlyViewAllPage";

  @override
  Widget build(BuildContext context) {
    return GetX<RecentlyViewAllPageController>(
        init: RecentlyViewAllPageController(),
        builder: (_) {
          controller.isLoading.value;
          return Scaffold(
            appBar: myAppBar(goBack: true, title: 'Recently Viewed'),
            body: SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView.builder(
                    itemCount: propertiesList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: ((context, index) {
                      return MostPopularWidget(
                        propertyModel: propertiesList.elementAt(index),
                      );
                    })),
              ),
            ),
          );
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
