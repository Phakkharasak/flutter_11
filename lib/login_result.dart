import 'dart:convert';

List<LoginResult> loginResultFromJson(String str) => List<LoginResult>.from(
    json.decode(str).map((x) => LoginResult.fromJson(x)));

String loginResultToJson(List<LoginResult> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginResult {
  int? id;
  String? email;
  String? password;

  LoginResult({
    this.id,
    this.email,
    this.password,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
        id: json["id"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
      };
}
