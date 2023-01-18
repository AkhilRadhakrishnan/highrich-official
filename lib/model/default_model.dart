import 'dart:convert';

DefaultModel defaultModelFromJson(String str) => DefaultModel.fromJson(json.decode(str));

String defaultModelToJson(DefaultModel data) => json.encode(data.toJson());

class DefaultModel {
  DefaultModel({
    this.status,
    this.message,
  });


  factory DefaultModel.fromRawJson(String str) =>
      DefaultModel.fromJson(json.decode(str));
  String status;
  String message;

  factory DefaultModel.fromJson(Map<String, dynamic> json) => DefaultModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
