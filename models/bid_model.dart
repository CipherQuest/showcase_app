import 'package:zeerac_flutter/dio_networking/decodable.dart';
import 'package:zeerac_flutter/modules/users/models/user_model.dart';

class BidListingResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<BidModel>? results;

  BidListingResponseModel({this.count, this.next, this.previous, this.results});

  BidListingResponseModel.fromJson(Map<String, dynamic> json) {
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
        results!.add(BidModel.fromJson(v));
      });
    }
    return this;
  }
}

class BidModel implements Decodeable {
  int? id;
  num? price;
  int? fileCount;
  bool? isClosed;
  String? createdAt;
  bool? isInvalid;
  String? updatedAt;
  UserModel? userFk;
  int? userFKInt;
  int? propertyFilesFk;
  String? subUnitSharePercentage;
  String? status;

  BidModel(
      {this.id,
      this.price,
      this.fileCount,
      this.isClosed,
      this.createdAt,
      this.isInvalid,
      this.updatedAt,
      this.userFk,
      this.userFKInt,
      this.propertyFilesFk,
      this.subUnitSharePercentage,
      this.status});

  BidModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? -1;
    price = num.tryParse(json['price'].toString()) != null
        ? num.parse(json['price'].toString())
        : 0;
    fileCount = json['file_count'] ?? 0;
    isClosed = json['is_closed'] ?? false;
    createdAt = json['created_at'] ?? '-';
    isInvalid = json['is_invalid'] ?? false;
    updatedAt = json['updated_at'] ?? '-';

    //check if user_fk is int or Map and handle accordingly
    dynamic userFkVal = json['user_fk'];
    if (userFkVal is int) {
      userFKInt = json['user_fk'];
    } else {
      userFk =
          json['user_fk'] != null ? UserModel.fromJson(json['user_fk']) : null;
    }
    // userFk = json['user_fk'] != null
    //     ? new UserModel.fromJson(json['user_fk'])
    //     : null;
    propertyFilesFk = json['property_files_fk'];
    subUnitSharePercentage = json['sub_unit_share_percentage'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['file_count'] = this.fileCount;
    data['is_closed'] = this.isClosed;
    data['created_at'] = this.createdAt;
    data['is_invalid'] = this.isInvalid;
    data['updated_at'] = this.updatedAt;
    if (this.userFk != null) {
      data['user_fk'] = this.userFk!.toJson();
    }
    data['property_files_fk'] = this.propertyFilesFk;
    data['sub_unit_share_percentage'] = this.subUnitSharePercentage;
    data['status'] = this.status;
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    price = num.tryParse(json['price'].toString()) != null
        ? num.parse(json['price'].toString())
        : -1;
    fileCount = json['file_count'];
    isClosed = json['is_closed'];
    createdAt = json['created_at'];
    isInvalid = json['is_invalid'];
    updatedAt = json['updated_at'];
    userFk =
        json['user_fk'] != null ? UserModel.fromJson(json['user_fk']) : null;
    propertyFilesFk = json['property_files_fk'];
    subUnitSharePercentage = json['sub_unit_share_percentage'];
    status = json['status'];
    return this;
  }

  @override
  String toString() {
    return 'BidModel{id: $id, price: $price, fileCount: $fileCount, isClosed: $isClosed, createdAt: $createdAt, isInvalid: $isInvalid, updatedAt: $updatedAt, userFk: $userFk, propertyFilesFk: $propertyFilesFk, subUnitSharePercentage: $subUnitSharePercentage}';
  }
}
