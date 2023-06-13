import 'dart:convert';

import 'package:zeerac_flutter/dio_networking/decodable.dart';
import 'package:zeerac_flutter/modules/users/models/bid_model.dart';
import 'package:zeerac_flutter/modules/users/models/user_model.dart';
import 'package:zeerac_flutter/modules/users/models/user_preference_post_response_model.dart';

class AuctionsListingResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<AuctionFileModel>? results;

  AuctionsListingResponseModel(
      {this.count, this.next, this.previous, this.results});

  AuctionsListingResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <AuctionFileModel>[];
      json['results'].forEach((v) {
        results!.add(new AuctionFileModel.fromJson(v));
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
      results = <AuctionFileModel>[];
      json['results'].forEach((v) {
        results!.add(AuctionFileModel.fromJson(v));
      });
    }
    return this;
  }
}

class AuctionFileModel implements Decodeable {
  int? id;
  String? auctionType;
  UserModel? userFk;
  String? companyFk;
  String? purpose;
  String? type;
  String? categories;
  String? price;
  String? size;
  String? unit;
  String? description;
  String? neighborhood;
  String? currency;
  String? address;
  String? country;
  String? city;
  String? area;
  bool? isSold;
  bool? isActiveListing;

  // List<Null>? tagFks;
  String? updatedAt;
  int? minFiles;
  int? maxFiles;
  String? verificationStatus;
  String? createdAt;
  int? soldFiles;
  int? availableFiles;
  int? totalFiles;
  String? subUnitValue;
  String? subUnitSharePercentage;
  String? startDate;
  String? endDate;
  List<Photos> photos = [];
  List<BidModel> bids=[];
  List<BidModel>? closingBid;
  BidModel? highestBid;




  AuctionFileModel(
      {this.id,
      this.auctionType,
      this.userFk,
      this.companyFk,
      this.highestBid,
      this.purpose,
      this.type,
      this.categories,
      this.price,
      this.size,
      this.unit,
      this.description,
      this.neighborhood,
      this.currency,
      this.address,
      this.country,
      this.city,
      this.area,
      this.isSold,
      this.isActiveListing,
      // this.tagFks,
      this.updatedAt,
      this.minFiles,
      this.maxFiles,
      this.verificationStatus,
      this.createdAt,
      this.soldFiles,
      this.availableFiles,
      this.totalFiles,
      this.subUnitValue,
      this.subUnitSharePercentage,
      this.startDate,
      this.endDate,
      this.photos = const [],
      this.bids=const [],
      this.closingBid});

  AuctionFileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    auctionType = json['auction_type'];
    userFk = json['user_fk'] != null
        ? new UserModel.fromJson(json['user_fk'])
        : null;
    companyFk = json['company_fk'];
    purpose = json['purpose'];
    type = json['type'];
    categories = json['categories'];
    price = json['price'];
    size = json['size'];
    unit = json['unit'];
    description = json['description'];
    neighborhood = json['neighborhood'];
    currency = json['currency'];
    address = json['address'];
    country = json['country'];
    city = json['city'];
    area = json['area'];
    isSold = json['is_sold'];

    highestBid = json['highest_bid'] != null
        ? BidModel.fromJson(json['highest_bid'])
        : null;
    isActiveListing = json['is_active_listing'];
    /*if (json['tag_fks'] != null) {
      tagFks = <Null>[];
      json['tag_fks'].forEach((v) {
        tagFks!.add(new Null.fromJson(v));
      });
    }*/
    updatedAt = json['updated_at'];
    minFiles = json['min_files'];
    maxFiles = json['max_files'];
    verificationStatus = json['verification_status'];
    createdAt = json['created_at'];
    soldFiles = json['sold_files'];
    availableFiles = json['available_files'];
    totalFiles = json['total_files'];
    subUnitValue = json['sub_unit_value'];
    subUnitSharePercentage = json['sub_unit_share_percentage'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(new Photos.fromJson(v));
      });
    }
    if (json['bids'] != null) {
      bids = <BidModel>[];
      json['bids'].forEach((v) {
        bids!.add(new BidModel.fromJson(v));
      });
    }
    if (json['closing_bid'] != null) {
      closingBid = <BidModel>[];
      json['closing_bid'].forEach((v) {
        closingBid!.add(new BidModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['auction_type'] = this.auctionType;
    if (this.userFk != null) {
      data['user_fk'] = this.userFk!.toJson();
    }
    data['company_fk'] = this.companyFk;
    data['purpose'] = this.purpose;
    data['type'] = this.type;
    data['categories'] = this.categories;
    data['price'] = this.price;
    data['size'] = this.size;

    if (highestBid != null) {
      data['highest_bid'] = highestBid!.toJson();
    }

    data['unit'] = this.unit;
    data['description'] = this.description;
    data['neighborhood'] = this.neighborhood;
    data['currency'] = this.currency;
    data['address'] = this.address;
    data['country'] = this.country;
    data['city'] = this.city;
    data['area'] = this.area;
    data['is_sold'] = this.isSold;
    data['is_active_listing'] = this.isActiveListing;
    /* if (this.tagFks != null) {
      data['tag_fks'] = this.tagFks!.map((v) => v.toJson()).toList();
    }*/
    data['updated_at'] = this.updatedAt;
    data['min_files'] = this.minFiles;
    data['max_files'] = this.maxFiles;
    data['verification_status'] = this.verificationStatus;
    data['created_at'] = this.createdAt;
    data['sold_files'] = this.soldFiles;
    data['available_files'] = this.availableFiles;
    data['total_files'] = this.totalFiles;
    data['sub_unit_value'] = this.subUnitValue;
    data['sub_unit_share_percentage'] = this.subUnitSharePercentage;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    if (this.photos != null) {
      data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    if (this.bids != null) {
      data['bids'] = this.bids!.map((v) => v.toJson()).toList();
    }
    if (this.closingBid != null) {
      data['closing_bid'] = this.closingBid!.map((v) => v.toJson()).toList();
    }
    return data;
  }




  @override
  decode(json) {
    id = json['id'];
    auctionType = json['auction_type'];
    userFk = json['user_fk'] != null
        ? new UserModel.fromJson(json['user_fk'])
        : null;
    companyFk = json['company_fk'];
    purpose = json['purpose'];
    highestBid = json['highest_bid'] != null
        ?  BidModel.fromJson(json['highest_bid'])
        : null;
    type = json['type'];
    categories = json['categories'];
    price = json['price'];
    size = json['size'];
    unit = json['unit'];
    description = json['description'];
    neighborhood = json['neighborhood'];
    currency = json['currency'];
    address = json['address'];
    country = json['country'];
    city = json['city'];
    area = json['area'];
    isSold = json['is_sold'];
    isActiveListing = json['is_active_listing'];
    /*if (json['tag_fks'] != null) {
      tagFks = <Null>[];
      json['tag_fks'].forEach((v) {
        tagFks!.add(new Null.fromJson(v));
      });
    }*/
    updatedAt = json['updated_at'];
    minFiles = json['min_files'];
    maxFiles = json['max_files'];
    verificationStatus = json['verification_status'];
    createdAt = json['created_at'];
    soldFiles = json['sold_files'];
    availableFiles = json['available_files'];
    totalFiles = json['total_files'];
    subUnitValue = json['sub_unit_value'];
    subUnitSharePercentage = json['sub_unit_share_percentage'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos.add(new Photos.fromJson(v));
      });
    }
    if (json['bids'] != null) {
      bids = <BidModel>[];
      json['bids'].forEach((v) {
        bids!.add(new BidModel.fromJson(v));
      });
    }
    if (json['closing_bid'] != null) {
      closingBid = <BidModel>[];
      json['closing_bid'].forEach((v) {
        closingBid!.add(new BidModel.fromJson(v));
      });
    }
    return this;
  }

  static List<String> encodeForList(List<AuctionFileModel> model) {
    return model.map((e) => json.encode(e)).toList();
  }

  static List<AuctionFileModel>? decodeFor(List<String> model) {
    if (model.isNotEmpty) {
      return model
          .map((e) => AuctionFileModel.fromJson(json.decode(e)))
          .toList();
    }
    return null;
  }
}

class Photos {
  int? id;
  String? filePhoto;
  int? propertyFilesFk;

  Photos({this.id, this.filePhoto, this.propertyFilesFk});

  Photos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    filePhoto = json['file_photo'];
    propertyFilesFk = json['property_files_fk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['file_photo'] = this.filePhoto;
    data['property_files_fk'] = this.propertyFilesFk;
    return data;
  }
}
