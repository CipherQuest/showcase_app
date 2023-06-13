import 'package:zeerac_flutter/dio_networking/decodable.dart';
import 'package:zeerac_flutter/modules/users/models/user_model.dart';

import 'bid_model.dart';

class BidingListResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<BidModel>? results;

  BidingListResponseModel({this.count, this.next, this.previous, this.results});

  BidingListResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <BidModel>[];
      json['results'].forEach((v) {
        results!.add(new BidModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  decode(json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <BidModel>[];
      json['results'].forEach((v) {
        results!.add(new BidModel.fromJson(v));
      });
    }
    return this;
  }
}


