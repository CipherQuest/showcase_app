import 'package:zeerac_flutter/dio_networking/decodable.dart';

class AgentsListingResponseModel implements Decodeable {
  // bool? status;
  String? next;
  String? previous;
  int? count;
  List<AgentsModel>? result;

  AgentsListingResponseModel(
      {this.count, this.next, this.previous, this.result});

  AgentsListingResponseModel.fromJson(Map<String, dynamic> json) {
    // status = json['status'];
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      result = <AgentsModel>[];
      json['results'].forEach((v) {
        result!.add(new AgentsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['status'] = this.status;
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.result != null) {
      data['results'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  decode(json) {
    //status = json['status'];
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['result'] != null) {
      result = <AgentsModel>[];
      json['result'].forEach((v) {
        result!.add(new AgentsModel.fromJson(v));
      });
    }
    return this;
  }
}

class AgentsModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? cnic;
  String? username;
  String? dateOfBirth;
  String? photo;
  String? personalDescription;
  String? address;
  String? country;
  String? city;
  String? area;
  String? fullName;
  String? company;
  List<Experience>? experience;
  int? totalListings;
  int? totalRatings;
  int? rating;
  String? verificationStatus;
  double? lat;
  double? lng;
  List<int>? favouritedBy;

  AgentsModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.cnic,
      this.username,
      this.dateOfBirth,
      this.photo,
      this.personalDescription,
      this.address,
      this.country,
      this.city,
      this.area,
      this.fullName,
      this.company,
      this.experience,
      this.totalListings,
      this.totalRatings,
      this.rating,
      this.verificationStatus,
      this.lat,
      this.lng,
      this.favouritedBy});

  AgentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    cnic = json['cnic'];
    username = json['username'];
    dateOfBirth = json['date_of_birth'];
    photo = json['photo'];
    personalDescription = json['personal_description'];
    address = json['address'];
    country = json['country'];
    city = json['city'];
    area = json['area'];
    fullName = json['full_name'];
    company = json['company'];
    if (json['experience'] != null) {
      experience = <Experience>[];
      json['experience'].forEach((v) {
        experience!.add(new Experience.fromJson(v));
      });
    }
    if (json['favourited_by'] != null) {
      favouritedBy = <int>[];
      json['favourited_by'].forEach((v) {
        favouritedBy!.add(v);
      });
    }
    totalListings = json['total_listings'];
    totalRatings = json['total_ratings'];
    rating = json['rating'];
    verificationStatus = json['verification_status'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['cnic'] = this.cnic;
    data['username'] = this.username;
    data['date_of_birth'] = this.dateOfBirth;
    data['photo'] = this.photo;
    data['personal_description'] = this.personalDescription;
    data['address'] = this.address;
    data['country'] = this.country;
    data['city'] = this.city;
    data['area'] = this.area;
    data['full_name'] = this.fullName;
    data['company'] = this.company;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    if (this.experience != null) {
      data['experience'] = this.experience!.map((v) => v.toJson()).toList();
    }
    if (this.favouritedBy != null) {
      data['favourited_by'] = this.favouritedBy!.map((v) => v).toList();
    }
    data['total_listings'] = this.totalListings;
    data['total_ratings'] = this.totalRatings;
    if (this.rating != null) {
      data['rating'] = this.rating!;
    }
    data['verification_status'] = this.verificationStatus;
    return data;
  }

  void fromJson(e) {}
}

class Experience {
  int? id;
  String? companyName;
  String? designation;
  String? city;
  String? country;
  String? startDate;
  String? endDate;
  bool? currentlyWorking;
  String? createdAt;
  String? updatedAt;

  Experience(
      {this.id,
      this.companyName,
      this.designation,
      this.city,
      this.country,
      this.startDate,
      this.endDate,
      this.currentlyWorking,
      this.createdAt,
      this.updatedAt});

  Experience.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    designation = json['designation'];
    city = json['city'];
    country = json['country'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    currentlyWorking = json['currently_working'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_name'] = this.companyName;
    data['designation'] = this.designation;
    data['city'] = this.city;
    data['country'] = this.country;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['currently_working'] = this.currentlyWorking;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Rating {
  double? averageRating;

  Rating({this.averageRating});

  Rating.fromJson(Map<String, dynamic> json) {
    averageRating = json['average_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average_rating'] = this.averageRating;
    return data;
  }
}
