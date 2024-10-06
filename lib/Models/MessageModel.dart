class MessageModel {
  /// Provides id
  String? id;

  /// Provides actual message it will be text or image/audio file path.
  String? message;

  /// Provides message created date time.
  DateTime? createdAt;

  /// Provides id of sender of message.
  String? sendBy;

  MessageModel({
    this.id = '',
    required this.message,
    required this.createdAt,
    required this.sendBy,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json["id"],
          message: json["message"],
          createdAt: json["createdAt"],
          sendBy: json["sendBy"],
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'createdAt': createdAt,
        'sendBy': sendBy,
      };
}
