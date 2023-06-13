import 'package:zeerac_flutter/dio_networking/decodable.dart';

class ProjectsResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<ProjectModel>? results;

  ProjectsResponseModel({this.count, this.next, this.previous, this.results});

  ProjectsResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <ProjectModel>[];
      json['results'].forEach((v) {
        results!.add(new ProjectModel.fromJson(v));
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
      results = <ProjectModel>[];
      json['results'].forEach((v) {
        results!.add(new ProjectModel.fromJson(v));
      });
    }
    return this;
  }
}

class ProjectModel {
  int? id;
  String? title;
  String? description;
  String? featurePhoto;
  String? logo;
  String? city;
  String? country;
  String? propertyUrl;
  double? lat;
  double? lng;
  String? currency;
  String? verificationStatus;
  Company? company;
  List<ProjectInstallment>? projectInstallment;
  List<ProjectPhoto>? projectPhoto;
  int? likesCount;
  String? price;
  List<Content>? contents;

  ProjectModel(
      {this.id,
      this.title,
      this.description,
      this.featurePhoto,
      this.logo,
      this.city,
      this.country,
      this.propertyUrl,
      this.lat,
      this.lng,
      this.currency,
      this.verificationStatus,
      this.company,
      this.projectInstallment,
      this.likesCount,
      this.price,
      this.contents});

  ProjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    featurePhoto = json['feature_photo'];
    logo = json['logo'];
    city = json['city'];
    country = json['country'];
    propertyUrl = json['property_url'];
    lat = json['lat'];
    lng = json['lng'];
    currency = json['currency'];
    verificationStatus = json['verification_status'];
    company =
        json['company'] != null ? new Company.fromJson(json['company']) : null;
    likesCount = json['likes_count'];
    price = json['price'];
    if (json['project_installment'] != null) {
      projectInstallment = <ProjectInstallment>[];
      json['project_installment'].forEach((v) {
        projectInstallment!.add(ProjectInstallment.fromJson(v));
      });
    }
    if (json['project_photo'] != null) {
      projectPhoto = <ProjectPhoto>[];
      json['project_photo'].forEach((v) {
        projectPhoto!.add(ProjectPhoto.fromJson(v));
      });
    }
    if (json['contents'] != null) {
      contents = <Content>[];
      json['contents'].forEach((v) {
        contents!.add(new Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['feature_photo'] = this.featurePhoto;
    data['logo'] = this.logo;
    data['city'] = this.city;
    data['country'] = this.country;
    data['property_url'] = this.propertyUrl;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['currency'] = this.currency;
    data['verification_status'] = this.verificationStatus;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    data['likes_count'] = this.likesCount;
    data['price'] = this.price;
    if (this.contents != null) {
      data['contents'] = this.contents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Company {
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
  Null? companyVerificationStatus;
  String? interests;

  Company(
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
      this.interests});

  Company.fromJson(Map<String, dynamic> json) {
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
    user = json['user'].cast<int>();
    admin = json['admin']['id'];
    companyAreas = json['company_areas'];
    companyCity = json['company_city'];
    //companyVerificationStatus = json['company_verification_status'];
    interests = json['interests'];
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
    return data;
  }
}

class ProjectPhoto {
  int? id;
  String? photo;
  String? createdAt;
  String? updatedAt;
  int? project;

  ProjectPhoto(
      {this.id, this.photo, this.createdAt, this.updatedAt, this.project});

  ProjectPhoto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photo = json['photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    project = json['project'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo'] = this.photo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['project'] = this.project;
    return data;
  }
}

class ProjectInstallment {
  int? id;
  String? description;
  int? duration;
  String? amount;
  String? downPayment;
  String? createdAt;
  String? updatedAt;
  int? project;

  ProjectInstallment(
      {this.id,
      this.description,
      this.duration,
      this.amount,
      this.downPayment,
      this.createdAt,
      this.updatedAt,
      this.project});

  ProjectInstallment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    duration = json['duration'];
    amount = json['amount'];
    downPayment = json['down_payment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    project = json['project'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['amount'] = this.amount;
    data['down_payment'] = this.downPayment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['project'] = this.project;
    return data;
  }
}

class Content {
  int? id;
  List<Files>? files;
  String? title;
  String? body;
  bool? containsFiles;

  Content({this.id, this.files, this.title, this.body, this.containsFiles});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(new Files.fromJson(v));
      });
    }
    title = json['title'];
    body = json['body'];
    containsFiles = json['contains_files'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.files != null) {
      data['files'] = this.files!.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    data['body'] = this.body;
    data['contains_files'] = this.containsFiles;
    return data;
  }
}

class Files {
  int? id;
  String? fileType;
  String? fileName;
  String? file;
  String? createdAt;
  String? updatedAt;

  Files(
      {this.id,
      this.fileType,
      this.fileName,
      this.file,
      this.createdAt,
      this.updatedAt});

  Files.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileType = json['file_type'];
    fileName = json['file_name'];
    file = json['file'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['file_type'] = this.fileType;
    data['file_name'] = this.fileName;
    data['file'] = this.file;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
