import 'package:json_annotation/json_annotation.dart';

import '../../authentication/models/user.dart';
import '../../contact/models/contact_config.dart';

part 'connection.g.dart';

@JsonSerializable()
class Connection {
  int? id;
  User? user1;
  User? user2;
  ContactConfig? config1;
  ContactConfig? config2;

  Connection({
    this.id,
    this.user1,
    this.user2,
    this.config1,
    this.config2,
  });

  User getOtherUser(User currentUser) {
    if(user1!.id == currentUser.id) {
      return user2!;
    }

    return user1!;
  }

  factory Connection.fromJson(Map<String, dynamic> json) => _$ConnectionFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectionToJson(this);
}
