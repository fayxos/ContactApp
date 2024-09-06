import 'package:json_annotation/json_annotation.dart';

import '../../authentication/models/user.dart';
import 'config_type.dart';
import 'contact_options.dart';

part 'contact_config.g.dart';

@JsonSerializable()
class ContactConfig {
  int? id;
  User? user;
  ConfigType? configType;
  String? configName;
  List<ContactOptions>? contactOptions;
  List<int>? images;
  List<int>? phoneNumbers;
  List<int>? emails;
  List<int>? descriptions;
  List<int>? websites;
  List<int>? socials;

  ContactConfig({
    this.id,
    this.user,
    this.configType,
    this.configName,
    this.contactOptions,
    this.images,
    this.phoneNumbers,
    this.emails,
    this.descriptions,
    this.websites,
    this.socials,
  });

  factory ContactConfig.fromJson(Map<String, dynamic> json) => _$ContactConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ContactConfigToJson(this);
}
