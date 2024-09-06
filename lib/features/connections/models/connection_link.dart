import 'package:json_annotation/json_annotation.dart';

import '../../authentication/models/user.dart';
import '../../contact/models/contact_config.dart';
import 'expiration_type.dart';

part 'connection_link.g.dart';

@JsonSerializable()
class ConnectionLink {
  int? id;
  User? user;
  ContactConfig? config;
  String? link;
  ExpirationType? expirationType;
  DateTime? expirationDate;

  ConnectionLink({
    this.id,
    this.user,
    this.config,
    this.link,
    this.expirationType,
    this.expirationDate,
  });

  factory ConnectionLink.fromJson(Map<String, dynamic> json) => _$ConnectionLinkFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectionLinkToJson(this);
}
