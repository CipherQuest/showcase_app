import '../../../dio_networking/decodable.dart';

class AgencyResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<AgencyModel>? results;

  AgencyResponseModel({this.count, this.next, this.previous, this.results});

  AgencyResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <AgencyModel>[];
      json['results'].forEach((v) {
        results!.add(new AgencyModel.fromJson(v));
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
      results = <AgencyModel>[];
      json['results'].forEach((v) {
        results!.add(new AgencyModel.fromJson(v));
      });
    }
    return this;
  }
}

class AgencyModel implements Decodeable {
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
  List<int>? user;
  int? admin;
  String? companyAreas;
  String? companyCity;
  String? companyVerificationStatus;
  String? interests;
  List<int>? favouritedBy;
  int? totalListings;

  AgencyModel(
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
      this.user,
      this.admin,
      this.companyAreas,
      this.companyCity,
      this.companyVerificationStatus,
      this.interests,
      this.favouritedBy,
      this.totalListings});

  AgencyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    companyDescription = json['company_description'];
    noOfEmployees = json['user'].length.toString();
    companyEmail = json['company_email'];
    companyPhone = json['company_phone'];
    companyFax = json['company_fax'];
    companyAddress = json['company_address'];
    isActive = json['is_active'];
    companyLogo = json['company_logo'];
    user = json['user'].cast<int>();
    admin = json['admin']['id'];
    companyAreas = json['company_areas'];
    companyCity = json['company_city'];
    companyVerificationStatus = json['company_verification_status'];
    interests = json['interests'];
    if (json['favourited_by'] != null) {
      favouritedBy = <int>[];
      json['favourited_by'].forEach((v) {
        favouritedBy!.add(v);
      });
    }
    totalListings = json['total_listings'];
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
    data['user'] = this.user;
    data['admin'] = this.admin;
    data['company_areas'] = this.companyAreas;
    data['company_city'] = this.companyCity;
    data['company_verification_status'] = this.companyVerificationStatus;
    data['interests'] = this.interests;
    if (this.favouritedBy != null) {
      data['favourited_by'] = this.favouritedBy!.map((v) => v).toList();
    }
    data['total_listings'] = this.totalListings;
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
    if (json['user'] != null) {
      favouritedBy = [];
      json['user'].forEach((v) {
        user!.add(v);
      });
    }
    //user = json['user'].cast<int>();
    admin = json['admin'];
    companyAreas = json['company_areas'];
    companyCity = json['company_city'];
    companyVerificationStatus = json['verification_status'];
    interests = json['interests'];
    if (json['favourited_by'] != null) {
      favouritedBy = [];
      json['favourited_by'].forEach((v) {
        favouritedBy!.add(v);
      });
    }
    totalListings = json['total_listings'];
  }
}
