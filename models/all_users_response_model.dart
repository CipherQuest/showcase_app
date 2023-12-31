import 'package:zeerac_flutter/modules/users/models/user_model.dart';

import '../../../dio_networking/decodable.dart';


class AllUserResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<UserModel>? results;

  AllUserResponseModel({this.count, this.next, this.previous, this.results});

  AllUserResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <UserModel>[];
      json['results'].forEach((v) {
        results!.add(new UserModel.fromJson(v));
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
      results = <UserModel>[];
      json['results'].forEach((v) {
        results!.add(new UserModel.fromJson(v));
      });
    }
    return this;
  }
}
