import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String? firstname;
  String? lastname;
  String? email;
  bool? emailVerified;

  User({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.emailVerified
  });

  String getFullName() {
    return "${firstname!} $lastname";
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

