import 'package:zeerac_flutter/dio_networking/decodable.dart';
import 'package:zeerac_flutter/modules/users/models/projects_response_model.dart';

class CompanyDetailsModel implements Decodeable {
  int? id;
  String? companyName;
  String? companyDescription;
  String? noOfEmployees;
  String? companyEmail;
  String? companyPhone;
  String? companyFax;
  String? companyAddress;
  bool? isActive;
  String? companyLogo;

  // List<User>? user;
  // User? admin;
  int? soldListings;
  int? activeListings;
  String? companyAreas;
  String? companyCity;
  String? companyVerificationStatus;
  String? interests;
  List<ProjectModel>? projects;

  CompanyDetailsModel(
      {this.id,
      this.companyName,
      this.companyDescription,
      this.noOfEmployees,
      this.companyEmail,
      this.companyPhone,
      this.companyFax,
      this.companyAddress,
      this.isActive,
      this.companyLogo,
      // this.user,
      // this.admin,
      this.soldListings,
      this.activeListings,
      this.companyAreas,
      this.companyCity,
      this.companyVerificationStatus,
      this.interests,
      this.projects});

  CompanyDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    companyDescription = json['company_description'];
    noOfEmployees = json['no_of_employees'];
    companyEmail = json['company_email'];
    companyPhone = json['company_phone'];
    companyFax = json['company_fax'];
    companyAddress = json['company_address'];
    isActive = json['is_active'];
    companyLogo = json['company_logo'];
    // if (json['user'] != null) {
    //   user = <User>[];
    //   json['user'].forEach((v) {
    //     user!.add(new User.fromJson(v));
    //   });
    // }
    // admin = json['admin'] != null ? new User.fromJson(json['admin']) : null;
    soldListings = json['sold_listings'];
    activeListings = json['active_listings'];
    companyAreas = json['company_areas'];
    companyCity = json['company_city'];
    companyVerificationStatus = json['company_verification_status'];
    interests = json['interests'];
    if (json['projects'] != null) {
      projects = <ProjectModel>[];
      json['projects'].forEach((v) {
        projects!.add(new ProjectModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_name'] = this.companyName;
    data['company_description'] = this.companyDescription;
    data['no_of_employees'] = this.noOfEmployees;
    data['company_email'] = this.companyEmail;
    data['company_phone'] = this.companyPhone;
    data['company_fax'] = this.companyFax;
    data['company_address'] = this.companyAddress;
    data['is_active'] = this.isActive;
    data['company_logo'] = this.companyLogo;
    // if (this.user != null) {
    //   data['user'] = this.user!.map((v) => v.toJson()).toList();
    // }
    // if (this.admin != null) {
    //   data['admin'] = this.admin!.toJson();
    // }
    data['sold_listings'] = this.soldListings;
    data['active_listings'] = this.activeListings;
    data['company_areas'] = this.companyAreas;
    data['company_city'] = this.companyCity;
    data['company_verification_status'] = this.companyVerificationStatus;
    data['interests'] = this.interests;
    if (this.projects != null) {
      data['projects'] = this.projects!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    companyName = json['company_name'];
    companyDescription = json['company_description'];
    noOfEmployees = json['no_of_employees'];
    companyEmail = json['company_email'];
    companyPhone = json['company_phone'];
    companyFax = json['company_fax'];
    companyAddress = json['company_address'];
    isActive = json['is_active'];
    companyLogo = json['company_logo'];
    // if (json['user'] != null) {
    //   user = <User>[];
    //   json['user'].forEach((v) {
    //     user!.add(new User.fromJson(v));
    //   });
    // }
    //admin = json['admin'] != null ? new User.fromJson(json['admin']) : null;
    soldListings = json['sold_listings'];
    activeListings = json['active_listings'];
    companyAreas = json['company_areas'];
    companyCity = json['company_city'];
    companyVerificationStatus = json['company_verification_status'];
    interests = json['interests'];
    if (json['projects'] != null) {
      projects = <ProjectModel>[];
      json['projects'].forEach((v) {
        projects!.add(new ProjectModel.fromJson(v));
      });
    }
    return this;
  }
}
