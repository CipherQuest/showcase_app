import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/styles.dart';

import '../pages/auctions/view_auctions/auctionfile_trading_tab.dart';
import '../pages/auctions/view_auctions/bulkfile_trading_tab.dart';
import '../pages/auctions/view_auctions/subunit_trading_tab.dart';

class AuctionsListingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool isLoading = false.obs;

  late TabController tabController;

  RxBool filterVisible = false.obs;

  @override
  void onInit() {
    tabController = TabController(length: tabs.length, vsync: this);

    super.onInit();
  }

  final tabs = [
    const Tab(text: 'Subunit Trading'),
    const Tab(text: 'Auction File'),
    const Tab(text: 'Bulk File'),
  ];

  final tabsPages = [
    //  const SubunitTradingTab(),
    //Center(child: Text("Coming soon",style: AppTextStyles.textStyleBoldTitleLarge)),
    const SubunitTradingTab(),
    const AuctionFileTradingTab(),
    const BulkFileTradingTab(),
  ];
}
