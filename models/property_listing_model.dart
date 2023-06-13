import 'dart:convert';

import 'package:zeerac_flutter/dio_networking/decodable.dart';
import 'package:zeerac_flutter/modules/users/models/user_model.dart';

class PropertyListingResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<PropertyModel> results = [];

  PropertyListingResponseModel(
      {this.count, this.next, this.previous, this.results = const []});

  PropertyListingResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <PropertyModel>[];
      json['results'].forEach((v) {
        results!.add(new PropertyModel.fromJson(v));
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
      results = <PropertyModel>[];
      json['results'].forEach((v) {
        results!.add(new PropertyModel.fromJson(v));
      });
    }
    return this;
  }

  @override
  String toString() {
    return 'PropertyListingModel{count: $count, next: $next, previous: $previous, results: $results}';
  }
}

class PropertyModel implements Decodeable {
  int? id;
  String? purpose;
  String? type;
  String? categories;
  String? title;
  String? size;
  String? unit;
  String? price;
  String? currency;
  String? yearBuilt;
  String? description;
  int? bedrooms;
  int? bathrooms;
  int? carsParking;
  String? country;
  String? address;
  String? city;
  String? area;
  String? street;
  String? block;
  double? lat;
  double? lng;
  String? video;
  Features? features;
  Services? services;
  int? searchCount;
  String? company;
  UserModel? user;
  bool? isActiveListing;
  bool? isSold;
  String? verificationStatus;
  String? createdAt;
  String? predictedPercentage;
  List<int>? favoritesCount;
  ConstructionDetails? constructionDetails;
  List<Image> image = const [];
  List<FloorImage> floorImage = const [];

  PropertyModel(
      {this.id,
      this.purpose,
      this.type,
      this.categories,
      this.title,
      this.size,
      this.unit,
      this.price,
      this.currency,
      this.yearBuilt,
      this.description,
      this.bedrooms,
      this.bathrooms,
      this.carsParking,
      this.country,
      this.address,
      this.city,
      this.area,
      this.street,
      this.block,
      this.lat,
      this.lng,
      this.video,
      this.features,
      this.services,
      this.searchCount,
      this.company,
      this.user,
      this.isActiveListing,
      this.isSold,
      this.verificationStatus,
      this.createdAt,
      this.predictedPercentage,
      this.favoritesCount,
      this.constructionDetails,
      this.image = const [],
      this.floorImage = const []});

  PropertyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    purpose = json['purpose'];
    type = json['type'];
    categories = json['categories'];
    title = json['title'];
    size = json['size'];
    unit = json['unit'];
    price = json['price'];
    currency = json['currency'];
    yearBuilt = json['year_built'].toString();
    description = json['description'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    carsParking = json['cars_parking'];
    country = json['country'];
    address = json['address'];
    city = json['city'];
    area = json['area'];
    street = json['street'];
    block = json['block'];
    lat = json['lat'];
    lng = json['lng'];
    video = json['video'];
    features = json['features'] != null
        ? new Features.fromJson(json['features'])
        : null;
    services = json['services'] != null
        ? new Services.fromJson(json['services'])
        : null;
    searchCount = json['search_count'];
    company = json['company'];
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
    isActiveListing = json['is_active_listing'];
    isSold = json['is_sold'];
    verificationStatus = json['verification_status'];
    createdAt = json['created_at'];
    predictedPercentage = json['predicted_percentage'];
    if (json['favorites_count'] != null) {
      favoritesCount = [];
      json['favorites_count'].forEach((v) {
        favoritesCount!.add(v);
      });
    }
    constructionDetails = json['construction_details'] != null
        ? new ConstructionDetails.fromJson(json['construction_details'])
        : null;
    if (json['image'] != null) {
      image = <Image>[];
      json['image'].forEach((v) {
        image!.add(new Image.fromJson(v));
      });
    }
    if (json['floor_image'] != null) {
      floorImage = <FloorImage>[];
      json['floor_image'].forEach((v) {
        floorImage!.add(new FloorImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['purpose'] = this.purpose;
    data['type'] = this.type;
    data['categories'] = this.categories;
    data['title'] = this.title;
    data['size'] = this.size;
    data['unit'] = this.unit;
    data['price'] = this.price;
    data['currency'] = this.currency;
    data['year_built'] = this.yearBuilt.toString();
    data['description'] = this.description;
    data['bedrooms'] = this.bedrooms;
    data['bathrooms'] = this.bathrooms;
    data['cars_parking'] = this.carsParking;
    data['country'] = this.country;
    data['address'] = this.address;
    data['city'] = this.city;
    data['area'] = this.area;
    data['street'] = this.street;
    data['block'] = this.block;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['video'] = this.video;
    if (this.features != null) {
      data['features'] = this.features!.toJson();
    }
    if (this.services != null) {
      data['services'] = this.services!.toJson();
    }
    data['search_count'] = this.searchCount;
    data['company'] = this.company;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['is_active_listing'] = this.isActiveListing;
    data['is_sold'] = this.isSold;
    data['verification_status'] = this.verificationStatus;
    data['created_at'] = this.createdAt;
    data['predicted_percentage'] = this.predictedPercentage;
    data['favorites_count'] = this.favoritesCount;
    if (this.constructionDetails != null) {
      data['construction_details'] = this.constructionDetails!.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image!.map((v) => v.toJson()).toList();
    }
    if (this.floorImage != null) {
      data['floor_image'] = this.floorImage!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toComparisionJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['purpose'] = this.purpose;
    data['type'] = this.type;
    data['categories'] = this.categories;
    data['title'] = this.title;
    data['size'] = this.size;
    data['unit'] = this.unit;
    data['price'] = this.price;
    // data['currency'] = this.currency;
    data['year_built'] = this.yearBuilt.toString();
    // data['description'] = this.description;
    // data['bedrooms'] = this.bedrooms;
    //data['bathrooms'] = this.bathrooms;
    // data['cars_parking'] = this.carsParking;
    data['country'] = this.country;
    data['address'] = this.address;
    data['city'] = this.city;
    data['area'] = this.area;
    data['street'] = this.street;
    data['block'] = this.block;

    // // if (this.services != null) {
    // //   data['services'] = this.services!.toJson();
    // // }

    return data;
  }

  static List<String> encodeForList(List<PropertyModel> model) {
    return model.map((e) => json.encode(e)).toList();
  }

  static List<PropertyModel>? decodeFor(List<String> model) {
    if (model.isNotEmpty) {
      return model.map((e) => PropertyModel.fromJson(json.decode(e))).toList();
      // (json.decode(model) as List<dynamic>)
      //     .map<PropertyModel>((item) => PropertyModel.fromJson(item))
      //     .toList();
    }
    return null;
  }

  @override
  decode(json) {
    id = json['id'];
    purpose = json['purpose'];
    type = json['type'];
    categories = json['categories'];
    title = json['title'];
    size = json['size'];
    unit = json['unit'];
    price = json['price'];
    currency = json['currency'];
    yearBuilt = json['year_built'].toString();
    description = json['description'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    carsParking = json['cars_parking'];
    country = json['country'];
    address = json['address'];
    city = json['city'];
    area = json['area'];
    street = json['street'];
    block = json['block'];
    lat = json['lat'];
    lng = json['lng'];
    video = json['video'];
    features = json['features'] != null
        ? new Features.fromJson(json['features'])
        : null;
    services = json['services'] != null
        ? new Services.fromJson(json['services'])
        : null;
    searchCount = json['search_count'];
    company = json['company'];
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
    isActiveListing = json['is_active_listing'];
    isSold = json['is_sold'];
    verificationStatus = json['verification_status'];
    createdAt = json['created_at'];
    predictedPercentage = json['predicted_percentage'];
    //favoritesCount = json['favorites_count'];
    if (json['favorites_count'] != null) {
      favoritesCount = [];
      json['favorites_count'].forEach((v) {
        favoritesCount!.add(v);
      });
    }
    constructionDetails = json['construction_details'] != null
        ? new ConstructionDetails.fromJson(json['construction_details'])
        : null;
    if (json['image'] != null) {
      image = <Image>[];
      json['image'].forEach((v) {
        image.add(new Image.fromJson(v));
      });
    }
    if (json['floor_image'] != null) {
      floorImage = <FloorImage>[];
      json['floor_image'].forEach((v) {
        floorImage!.add(new FloorImage.fromJson(v));
      });
    }

    return this;
  }
}

class Features {
  int? id;
  bool? tvLounge;
  bool? storeRoom;
  bool? laundryRoom;
  bool? kitchen;
  bool? balcony;
  bool? garden;

  Features(
      {this.id,
      this.tvLounge,
      this.storeRoom,
      this.laundryRoom,
      this.kitchen,
      this.balcony,
      this.garden});

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tvLounge = json['tv_lounge'];
    storeRoom = json['store_room'];
    laundryRoom = json['laundry_room'];
    kitchen = json['kitchen'];
    balcony = json['balcony'];
    garden = json['garden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tv_lounge'] = this.tvLounge;
    data['store_room'] = this.storeRoom;
    data['laundry_room'] = this.laundryRoom;
    data['kitchen'] = this.kitchen;
    data['balcony'] = this.balcony;
    data['garden'] = this.garden;
    return data;
  }
}

class Services {
  int? id;
  bool? electricity;
  bool? gas;
  bool? water;
  bool? maintenance;
  bool? security;
  bool? sewerage;

  Services(
      {this.id,
      this.electricity,
      this.gas,
      this.water,
      this.maintenance,
      this.security,
      this.sewerage});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    electricity = json['electricity'];
    gas = json['gas'];
    water = json['water'];
    maintenance = json['maintenance'];
    security = json['security'];
    sewerage = json['sewerage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['electricity'] = this.electricity;
    data['gas'] = this.gas;
    data['water'] = this.water;
    data['maintenance'] = this.maintenance;
    data['security'] = this.security;
    data['sewerage'] = this.sewerage;
    return data;
  }
}

class ConstructionDetails {
  int? id;
  String? heating;
  String? cooling;
  String? furnished;
  String? flooring;
  String? appliances;
  String? pool;
  String? lawn;
  String? garage;
  String? homeType;
  String? propertySubtype;
  String? materials;
  String? propertyCondition;
  String? newConstruction;
  String? yearBuilt;

  ConstructionDetails(
      {this.id,
      this.heating,
      this.cooling,
      this.furnished,
      this.flooring,
      this.appliances,
      this.pool,
      this.lawn,
      this.garage,
      this.homeType,
      this.propertySubtype,
      this.materials,
      this.propertyCondition,
      this.newConstruction,
      this.yearBuilt});

  ConstructionDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    heating = json['heating'];
    cooling = json['cooling'];
    furnished = json['furnished'];
    flooring = json['flooring'];
    appliances = json['appliances'];
    pool = json['pool'];
    lawn = json['lawn'];
    garage = json['garage'];
    homeType = json['home_type'];
    propertySubtype = json['property_subtype'];
    materials = json['materials'];
    propertyCondition = json['property_condition'];
    newConstruction = json['new_construction'];
    yearBuilt = json['year_built'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['heating'] = this.heating;
    data['cooling'] = this.cooling;
    data['furnished'] = this.furnished;
    data['flooring'] = this.flooring;
    data['appliances'] = this.appliances;
    data['pool'] = this.pool;
    data['lawn'] = this.lawn;
    data['garage'] = this.garage;
    data['home_type'] = this.homeType;
    data['property_subtype'] = this.propertySubtype;
    data['materials'] = this.materials;
    data['property_condition'] = this.propertyCondition;
    data['new_construction'] = this.newConstruction;
    data['year_built'] = this.yearBuilt.toString();
    return data;
  }
}

class Image {
  String? image;
  int? id;

  Image({this.image, this.id});

  Image.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    return data;
  }
}

class FloorImage {
  String? floorImage;
  int? id;

  FloorImage({this.floorImage, this.id});

  FloorImage.fromJson(Map<String, dynamic> json) {
    floorImage = json['floor_image'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['floor_image'] = this.floorImage;
    data['id'] = this.id;
    return data;
  }
}
