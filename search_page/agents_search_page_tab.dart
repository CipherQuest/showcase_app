import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/agent_search_tab_controller.dart';
import 'package:zeerac_flutter/modules/users/pages/agents_listing/agents_listing_widgets.dart';
import 'package:zeerac_flutter/utils/recording_widget.dart';

import '../../../../common/loading_widget.dart';
import '../../../../generated/assets.dart';

class AgentSearchPageTab extends GetView<AgentSearchTabController> {
  const AgentSearchPageTab({Key? key}) : super(key: key);
  static const id = '/AgentSearchPageTab';

  @override
  Widget build(BuildContext context) {
    return GetX<AgentSearchTabController>(
      initState: (state) {
        print('agents loaded');
        if (controller.onlyOnce == true) {
          controller.agentsList.clear();
          controller.loadAgentsModified();
        }
        //controller.loadAgentsWithOutPagination();
        //controller.getFavoritedAgents();

        // if (controller.agentsList.isEmpty) {
        //   // controller.loadAgents();

        //   controller.searchController.addListener(() {
        //     controller.searchFromList();
        //   });
        // }
      },
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                    child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: MyTextField(
                                  controller: controller.searchController,
                                  hintText: 'Search by Name',
                                  borderRadius: 80,
                                  leftPadding: 0,
                                  rightPadding: 0,
                                  textColor: AppColor.blackColor,
                                  focusBorderColor: AppColor.blackColor,
                                  unfocusBorderColor: AppColor.blackColor,
                                  onFieldSubmit: (val) {
                                    controller.reset();
                                    controller.hasSearchedByTyping = true;
                                    controller.loadAgentsModified();
                                  },
                                  suffixIconWidet: RecordingWidget(
                                      iconColor: AppColor.blackColor,
                                      onStop: () {
                                        print("stopped");
                                        if (controller
                                            .searchController.text.isNotEmpty) {
                                          print("doing searching......");
                                        }
                                      },
                                      onListenComplete: (String? s) {
                                        print(s?.toString());
                                        if (s != null) {
                                          controller.searchController.text =
                                              s.toString();
                                        }
                                      }),
                                ),
                              ),
                            ),

                            ///not being used for now....
                            hSpace,
                            InkWell(
                              onTap: () {
                                controller.filterVisible.toggle();
                                controller.clearFilters();
                              },
                              child: SvgViewer(
                                color: controller.filterVisible.value == true
                                    ? AppColor.primaryBlueColor
                                    : Colors.black,
                                svgPath: Assets.iconsNewFilterIcBlck,
                                height: 55.h,
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: controller.filterVisible.value,
                          child: Card(
                            elevation: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 4),
                              height: 190.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  //color: Colors.red,
                                  borderRadius: BorderRadius.circular(1)),
                              child: Column(children: [
                                Align(
                                    alignment: Alignment.topRight,
                                    //TODO change the icon as per figma design
                                    child: InkWell(
                                        onTap: () {
                                          controller.clearFilters();
                                          // FocusScope.of(context)
                                          //     .requestFocus(FocusNode());
                                        },
                                        child: Icon(Icons.close))),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: MyTextField(
                                      controller:
                                          controller.cityFilterController,
                                      hintText: 'City',
                                      focusBorderColor:
                                          AppColor.primaryBlueColor,
                                      unfocusBorderColor: Colors.grey,
                                    )),
                                    Expanded(
                                        child: MyTextField(
                                      controller:
                                          controller.areaFilterController,
                                      hintText: 'Area',
                                      focusBorderColor:
                                          AppColor.primaryBlueColor,
                                      unfocusBorderColor: Colors.grey,
                                    ))
                                  ],
                                ),
                                vSpace,
                                InkWell(
                                  onTap: () {
                                    if (controller.cityFilterController.text
                                            .isNotEmpty ||
                                        controller.areaFilterController.text
                                            .isNotEmpty) {
                                      controller.reset();
                                      controller.loadAgentsModified();
                                    }
                                  },
                                  child: Container(
                                    height: 50.h,
                                    width: 600.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                      color: AppColor.primaryBlueColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Apply',
                                        style: AppTextStyles
                                            .textStyleNormalBodyMedium
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ),
                        ),
                        vSpace,
                        Text(
                          "Displaying ${controller.agentsList.length} Agents",
                          style: AppTextStyles.textStyleBoldBodyMedium
                              .copyWith(color: AppColor.greyColor),
                        ),
                        // ListView.builder(
                        //     shrinkWrap: true,
                        //     itemCount: controller.agentsList.length,
                        //     physics: const NeverScrollableScrollPhysics(),
                        //     itemBuilder: (context, index) {
                        //       return agentsListingWidget(
                        //           controller.agentsList.elementAt(index)!);
                        //     }),
                        vSpace,
                        controller.isLoading.value == false &&
                                controller.agentsList.isEmpty
                            ? Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("No Agents Found",
                                      style: AppTextStyles
                                          .textStyleBoldBodyMedium),
                                  InkWell(
                                    onTap: () {
                                      controller.reset();
                                      controller.loadAgentsModified();
                                    },
                                    child: Text(
                                      "Refresh",
                                      style: AppTextStyles
                                          .textStyleBoldBodyMedium
                                          .copyWith(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: AppColor.primaryBlueColor),
                                    ),
                                  ),
                                ],
                              ))
                            : Container(
                                height: controller.filterVisible.value == true
                                    ? context.height * 0.34
                                    : context.height * 0.55,
                                child: NotificationListener(
                                  onNotification:
                                      controller.onScrollNotification,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: controller.agentsList.length,
                                      // physics:
                                      //     const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return agentsListingWidget(
                                          controller.agentsList
                                              .elementAt(index)!,
                                          index,
                                        );
                                      }),
                                ),
                              ),
                        vSpace,
                        vSpace,
                        vSpace,
                        vSpace,
                        vSpace,
                        vSpace,
                      ],
                    ),
                  ),
                )),
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
}
