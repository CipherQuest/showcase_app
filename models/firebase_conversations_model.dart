import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseConversationModel {
  bool? lastMessageRead;
  List<String>? userIds;
  String? lastMessage;
  Timestamp? lastMessageTime;
  List<FirebaseConversationUserModel>? users;
  String? lastMessageSender;

  FirebaseConversationModel(
      {this.lastMessageRead,
      this.userIds,
      this.lastMessage,
      this.lastMessageTime,
      this.users,
      this.lastMessageSender});

  FirebaseConversationModel.fromJson(Map<String, dynamic> json) {
    lastMessageRead = json['lastMessageRead'];
    userIds = json['userIds'].cast<String>();
    lastMessage = json['lastMessage'];
    lastMessageTime = json['lastMessageTime'];
    if (json['users'] != null) {
      users = <FirebaseConversationUserModel>[];
      json['users'].forEach((v) {
        users!.add(new FirebaseConversationUserModel.fromJson(v));
      });
    }
    lastMessageSender = json['lastMessageSender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastMessageRead'] = this.lastMessageRead;
    data['userIds'] = this.userIds;
    data['lastMessage'] = this.lastMessage;
    data['lastMessageTime'] = this.lastMessageTime;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    data['lastMessageSender'] = this.lastMessageSender;
    return data;
  }
}

class FirebaseConversationUserModel {
  String? name;
  String? photo;
  String? id;
  String? email;

  FirebaseConversationUserModel({this.name, this.photo, this.id, this.email});

  FirebaseConversationUserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    photo = json['photo'];
    id = json['id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['id'] = this.id;
    data['email'] = this.email;
    return data;
  }
}

class FirebaseUserModelNew {
  String? name;
  String? photo;
  bool isOnline = false;
  List<String>? conversations;
  String? email;

  FirebaseUserModelNew(
      {this.name,
      this.photo,
      this.isOnline = false,
      this.conversations,
      this.email});

  FirebaseUserModelNew.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    photo = json['photo'];
    isOnline = json['isOnline'];
    conversations = json['conversations'].cast<String>();
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['isOnline'] = this.isOnline;
    data['conversations'] = this.conversations;
    data['email'] = this.email;
    return data;
  }
}
