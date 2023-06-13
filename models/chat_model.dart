import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? conversation;
  Timestamp? createdAt;
  String? message;
  bool? read;
  String? receiver;
  String? sender;

  ChatModel(
      {this.conversation,
        this.createdAt,
        this.message,
        this.read,
        this.receiver,
        this.sender});

  ChatModel.fromJson(Map<String, dynamic> json) {
    conversation = json['conversation'];
    createdAt = json['createdAt'];
    message = json['message'];
    read = json['read'];
    receiver = json['receiver'];
    sender = json['sender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conversation'] = this.conversation;
    data['createdAt'] = this.createdAt;
    data['message'] = this.message;
    data['read'] = this.read;
    data['receiver'] = this.receiver;
    data['sender'] = this.sender;
    return data;
  }
}
