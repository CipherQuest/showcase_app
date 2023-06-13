import 'package:zeerac_flutter/dio_networking/decodable.dart';

class UserModel implements Decodeable {
  int? id;
  String? username;
  String? token;
  String? email;
  String? firstName;
  String? lastName;
  String? address;
  String? personalDescription;
  String? country;
  String? dateOfBirth;
  String? verificationStatus;
  String? verificationStatusByAdmin;
  String? photo;
  int? userType;
  String? cnic;
  String? phoneNumber;
  String? fullName;
  String? city;
  String? area;
  bool? isInvited;
  bool? isPasswordChanged;
  String? nationality;
  String? languages;
  String? createdAt;
  //TODO change type to num?
  num? balance;
  String? currency;
  double? lat;
  double? lng;

//  List<Null>? experience;
  num? rating;
  num? totalRatings;
  String? company;
  int? activeListingCount;
  int? totalListings;
  bool? isActive;

  UserModel(
      {this.id,
      this.username,
      this.token,
      this.email,
      this.firstName,
      this.lastName,
      this.address,
      this.personalDescription,
      this.country,
      this.dateOfBirth,
      this.verificationStatus,
      this.verificationStatusByAdmin,
      this.photo,
      this.userType,
      this.cnic,
      this.phoneNumber,
      this.fullName,
      this.city,
      this.area,
      this.isInvited,
      this.isPasswordChanged,
      this.nationality,
      this.languages,
      this.createdAt,
      this.balance,
      this.currency,
      this.lat,
      this.lng,
      // this.experience,
      this.rating,
      this.totalRatings,
      this.company,
      this.activeListingCount,
      this.totalListings,
      this.isActive});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    username = json['username'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    address = json['address'];
    personalDescription = json['personal_description'];
    country = json['country'];
    dateOfBirth = json['date_of_birth'];
    verificationStatus = json['verification_status'];
    verificationStatusByAdmin = json['verification_status_by_admin'];
    photo = json['photo'];
    userType = json['user_type'];
    cnic = json['cnic'];
    phoneNumber = json['phone_number'];
    fullName = json['full_name'];
    city = json['city'];
    area = json['area'];
    isInvited = json['is_invited'];
    isPasswordChanged = json['is_password_changed'];
    nationality = json['nationality'];
    languages = json['languages'];
    createdAt = json['created_at'];
    balance = json['balance'] ?? 0;
    currency = json['currency'];
    lat = json['lat'];
    lng = json['lng'];
    // if (json['experience'] != null) {
    //   experience = <Null>[];
    //   json['experience'].forEach((v) {
    //     experience!.add(new Null.fromJson(v));
    //   });
    // }
    rating = json['rating'];
    totalRatings = json['total_ratings'];
    company = json['company'];
    activeListingCount = json['active_listing_count'];
    totalListings = json['total_listings'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['token'] = this.token;

    data['username'] = this.username;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['address'] = this.address;
    data['personal_description'] = this.personalDescription;
    data['country'] = this.country;
    data['date_of_birth'] = this.dateOfBirth;
    data['verification_status'] = this.verificationStatus;
    data['verification_status_by_admin'] = this.verificationStatusByAdmin;
    data['photo'] = this.photo;
    data['user_type'] = this.userType;
    data['cnic'] = this.cnic;
    data['phone_number'] = this.phoneNumber;
    data['full_name'] = this.fullName;
    data['city'] = this.city;
    data['area'] = this.area;
    data['is_invited'] = this.isInvited;
    data['is_password_changed'] = this.isPasswordChanged;
    data['nationality'] = this.nationality;
    data['languages'] = this.languages;
    data['created_at'] = this.createdAt;
    data['balance'] = this.balance;
    data['currency'] = this.currency;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    // if (this.experience != null) {
    //   data['experience'] = this.experience!.map((v) => v.toJson()).toList();
    // }
    data['rating'] = this.rating;
    data['total_ratings'] = this.totalRatings;
    data['company'] = this.company;
    data['active_listing_count'] = this.activeListingCount;
    data['total_listings'] = this.totalListings;
    data['is_active'] = this.isActive;
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    token = json['token'];
    username = json['username'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    address = json['address'];
    personalDescription = json['personal_description'];
    country = json['country'];
    dateOfBirth = json['date_of_birth'];
    verificationStatus = json['verification_status'];
    verificationStatusByAdmin = json['verification_status_by_admin'];
    photo = json['photo'];
    userType = json['user_type'];
    cnic = json['cnic'];
    phoneNumber = json['phone_number'];
    fullName = json['full_name'];
    city = json['city'];
    area = json['area'];
    isInvited = json['is_invited'];
    isPasswordChanged = json['is_password_changed'];
    nationality = json['nationality'];
    languages = json['languages'];
    createdAt = json['created_at'];
    balance = json['balance'];
    currency = json['currency'];
    lat = json['lat'];
    lng = json['lng'];
    // if (json['experience'] != null) {
    //   experience = <Null>[];
    //   json['experience'].forEach((v) {
    //     experience!.add(new Null.fromJson(v));
    //   });
    // }
    rating = json['rating'];
    totalRatings = json['total_ratings'];
    company = json['company'];
    activeListingCount = json['active_listing_count'];
    totalListings = json['total_listings'];
    isActive = json['is_active'];
    return this;
  }
}
