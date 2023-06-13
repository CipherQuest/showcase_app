class FirebaseNotificationModel {
  String? id;
  String? fromId;
  String? toId;
  String? title;
  String? body;
  String? time;
  bool? isRead;

//<editor-fold desc="Data Methods">

  FirebaseNotificationModel(
      {required this.id,
      required this.fromId,
      required this.toId,
      required this.title,
      required this.body,
      required this.time,
      required this.isRead});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FirebaseNotificationModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fromId == other.fromId &&
          toId == other.toId &&
          title == other.title &&
          body == other.body &&
          time == other.time &&
          isRead == other.isRead);

  @override
  int get hashCode =>
      id.hashCode ^
      fromId.hashCode ^
      toId.hashCode ^
      title.hashCode ^
      body.hashCode ^
      time.hashCode ^
      isRead.hashCode;

  @override
  String toString() {
    return 'NotificationModel{' +
        ' id: $id,' +
        ' fromId: $fromId,' +
        ' toId: $toId,' +
        ' title: $title,' +
        ' body: $body,' +
        ' time: $time,' +
        ' isRead: $isRead,' +
        '}';
  }

  FirebaseNotificationModel copyWith({
    String? id,
    String? fromId,
    String? toId,
    String? title,
    String? body,
    String? time,
    bool? isRead,
  }) {
    return FirebaseNotificationModel(
      id: id ?? this.id,
      fromId: fromId ?? this.fromId,
      toId: toId ?? this.toId,
      title: title ?? this.title,
      body: body ?? this.body,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'fromId': this.fromId,
      'toId': this.toId,
      'title': this.title,
      'body': this.body,
      'time': this.time,
      'isRead': this.isRead,
    };
  }

  factory FirebaseNotificationModel.fromMap(Map<String, dynamic> map) {
    return FirebaseNotificationModel(
      id: map['id'] as String,
      fromId: map['fromId'] as String,
      toId: map['toId'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      time: map['time'] as String,
      isRead: map['isRead'] as bool,
    );
  }

//</editor-fold>
}
