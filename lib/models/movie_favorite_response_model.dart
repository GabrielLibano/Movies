import 'dart:convert';

class MovieFavoriteResponseModel {
  bool Success;
  int StatusCode;
  String StatusMessage;

  MovieFavoriteResponseModel({
    required this.Success,
    required this.StatusCode,
    required this.StatusMessage,
  });

  factory MovieFavoriteResponseModel.fromRawJson(String str) => MovieFavoriteResponseModel.fromJson(json.decode(str));

  factory MovieFavoriteResponseModel.fromJson(Map<String, dynamic> json) => MovieFavoriteResponseModel(
        Success: json["success"],
        StatusCode: json["status_code"],
        StatusMessage: json["status_message"],
      );
}