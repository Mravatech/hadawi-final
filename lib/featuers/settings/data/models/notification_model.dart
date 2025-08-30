class NotificationModel {
  final String date;
  final String id;
  final String message;
  final String body;
  final String userId;

  NotificationModel({
    required this.date,
    required this.id,
    required this.message,
    required this.body,
    required this.userId,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> json) => NotificationModel(
    date: json["date"]??'',
    id: json["id"]??'',
    message: json["message"]??'',
    body: json["body"]??'',
    userId: json["userId"]??'',
  );

  Map<String, dynamic> toMap() => {
    "date": date??'',
    "id": id??'',
    "message": message??'',
    "body": body??'',
    "userId": userId??'',
  };
}