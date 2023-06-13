import 'package:zeerac_flutter/dio_networking/decodable.dart';
import 'package:zeerac_flutter/modules/users/models/user_model.dart';

class UserPreferencePostModel implements Decodeable {
  int? priceMin;
  int? priceMax;
  int? yearBuild;
  String? spaceMin;
  String? unit;
  bool? newlyConstructed;
  List<TagFks>? tagFks;
  String? spaceMax;
  String? area;
  String? city;
  String? country;
  String? createdAt;
  String? updatedAt;
  int? id;
  UserModel? userFk;

  UserPreferencePostModel(
      {this.priceMin,
      this.priceMax,
      this.yearBuild,
      this.spaceMin,
      this.unit,
      this.newlyConstructed,
      this.tagFks,
      this.spaceMax,
      this.area,
      this.city,
      this.country,
      this.createdAt,
      this.updatedAt,
      this.id,
      this.userFk});

  UserPreferencePostModel.fromJson(Map<String, dynamic> json) {
    priceMin = json['price_min'];
    priceMax = json['price_max'];
    yearBuild = json['year_build'];
    spaceMin = json['space_min'];
    unit = json['unit'];
    newlyConstructed = json['newly_constructed'];
    if (json['tag_fks'] != null) {
      tagFks = <TagFks>[];
      json['tag_fks'].forEach((v) {
        tagFks!.add(new TagFks.fromJson(v));
      });
    }
    spaceMax = json['space_max'];
    area = json['area'];
    city = json['city'];
    country = json['country'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    id = json['id'];
    userFk =
        json['user_fk'] != null ? new UserModel.fromJson(json['user_fk']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price_min'] = this.priceMin;
    data['price_max'] = this.priceMax;
    data['year_build'] = this.yearBuild;
    data['space_min'] = this.spaceMin;
    data['unit'] = this.unit;
    data['newly_constructed'] = this.newlyConstructed;
    if (this.tagFks != null) {
      data['tag_fks'] = this.tagFks!.map((v) => v.toJson()).toList();
    }
    data['space_max'] = this.spaceMax;
    data['area'] = this.area;
    data['city'] = this.city;
    data['country'] = this.country;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['id'] = this.id;
    if (this.userFk != null) {
      data['user_fk'] = this.userFk!.toJson();
    }
    return data;
  }

  @override
  decode(json) {
    priceMin = json['price_min'];
    priceMax = json['price_max'];
    yearBuild = json['year_build'];
    spaceMin = json['space_min'];
    unit = json['unit'];
    newlyConstructed = json['newly_constructed'];
    if (json['tag_fks'] != null) {
      tagFks = <TagFks>[];
      json['tag_fks'].forEach((v) {
        tagFks!.add(TagFks.fromJson(v));
      });
    }
    spaceMax = json['space_max'];
    area = json['area'];
    city = json['city'];
    country = json['country'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    id = json['id'];
    userFk = json['user_fk'] != null ? UserModel.fromJson(json['user_fk']) : null;
    return this;
  }
}

class TagFks {
  int? id;
  String? tag;
  String? category;

  TagFks({this.id, this.tag, this.category});

  TagFks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tag'] = this.tag;
    data['category'] = this.category;
    return data;
  }
}


