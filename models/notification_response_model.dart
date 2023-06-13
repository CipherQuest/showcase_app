import 'package:zeerac_flutter/dio_networking/decodable.dart';
import 'package:zeerac_flutter/modules/users/models/bid_model.dart';
import 'package:zeerac_flutter/modules/users/models/projects_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/modules/users/models/user_model.dart';

//todo
/*this is shit response from the server , needs to be discussed and changed accordint to other apis*/
class NotificationsResponseModel implements Decodeable {
  int? count;
  String? next;
  String? previous;
  List<NotificationModel>? notificationsList;

  NotificationsResponseModel(
      {this.count, this.next, this.previous, this.notificationsList});

  NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      notificationsList = <NotificationModel>[];
      json['results'].forEach((v) {
        notificationsList!.add(NotificationModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.notificationsList != null) {
      data['results'] = this.notificationsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  decode(json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      notificationsList = <NotificationModel>[];
      json['results'].forEach((v) {
        notificationsList!.add(new NotificationModel.fromJson(v));
      });
    }

    return this;
  }

  @override
  String toString() {
    return 'NotificationsResponseModel{count: $count, next: $next, previous: $previous, results: $notificationsList}';
  }
}

class NotificationModel implements Decodeable {
  int? id;
  String? action;
  String? instanceType;
  bool? isRead;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  String? title;
  String? body;
  UserModel? sender;
  UserModel? receiver;
  int? listingId;

  PropertyModel? listing;
  // ProjectModel? project;
  // BidModel? bid;
  // Null? agent;
  // Null? agency;
  // Null? auction;
  // Null? ticket;

  NotificationModel(
      {this.id,
      this.action,
      this.instanceType,
      this.isRead,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.title,
      this.body,
      this.sender,
      this.receiver,
      this.listingId
      //this.listing,

      // this.project,
      // this.bid
      /*  this.listing,
        this.project,
        this.agent,
        this.agency,
        this.auction,
        this.ticket*/
      });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    action = json['action'];
    instanceType = json['instance_type'];
    isRead = json['is_read'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'];
    body = json['body'];
    sender = json['sender'] != null
        ? new UserModel.fromJson(json['sender'])
        : UserModel();
    receiver = json['receiver'] != null
        ? new UserModel.fromJson(json['receiver'])
        : null;
    listingId = json['listing'] != null ? json['listing']['id'] : 0;
    /*listing = json['instance_type'] == 'listing'
        ? PropertyModel.fromJson(json['listing'])
        : null;
    project = json['instance_type'] == 'project'
        ? ProjectModel.fromJson(json['project'])
        : null;
    bid =
        json['instance_type'] == 'bid' ? BidModel.fromJson(json['bid']) : null;*/

    // listing =
    // json['listing'] != null ? new Listing.fromJson(json['listing']) : null;
    // project =
    // json['project'] != null ? new Project.fromJson(json['project']) : null;
    // agent = json['agent'];
    // agency = json['agency'];
    // auction = json['auction'];
    // ticket = json['ticket'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['action'] = this.action;
    data['instance_type'] = this.instanceType;
    data['is_read'] = this.isRead;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['title'] = this.title;
    data['body'] = this.body;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    if (this.receiver != null) {
      data['receiver'] = this.receiver!.toJson();
    }
    // if (this.listing != null) {
    //   data['listing'] = this.listing!.toJson();
    // }
    // if (this.project != null) {
    //   data['project'] = this.project!.toJson();
    // }
    // data['agent'] = this.agent;
    // data['agency'] = this.agency;
    // data['auction'] = this.auction;
    // data['ticket'] = this.ticket;
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    action = json['action'];
    instanceType = json['instance_type'];
    isRead = json['is_read'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'];
    body = json['body'];
    sender =
        json['sender'] != null ? new UserModel.fromJson(json['sender']) : null;
    receiver = json['receiver'] != null
        ? new UserModel.fromJson(json['receiver'])
        : null;

    return this;
  }
}
