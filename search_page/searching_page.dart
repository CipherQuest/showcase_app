import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/agent_search_tab_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/search_filter_listing_controller.dart';

import '../../../../common/loading_widget.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({Key? key}) : super(key: key);
  static const id = '/SearchingPage';

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage>
    with AutomaticKeepAliveClientMixin<SearchingPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetX<SearchFilterListingController>(
      initState: (state) {},
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.whiteColor,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    ///tab bars....
                    Container(
                      height: 45.h,
                      margin: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 10),
                      decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(18)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: TabBar(
                          isScrollable: true,
                          controller: controller.tabController,
                          labelColor: AppColor.whiteColor,
                          unselectedLabelColor: AppColor.greyColor,
                          onTap: (i) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          indicator: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              color: AppColor.primaryBlueColor),
                          tabs: controller.tabs,
                        ),
                      ),
                    ),
                    const Divider(color: AppColor.blackColor),
                    Expanded(
                      child: TabBarView(
                          controller: controller.tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: controller.tabsPages),
                    ),
                  ],
                ),
                if (controller.isLoading.isTrue)
                  LoadingWidget(
                    onCancel: () {
                      controller.isLoading.value = false;
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => false;
}
