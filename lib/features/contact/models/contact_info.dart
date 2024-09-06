import 'package:json_annotation/json_annotation.dart';

import '../../authentication/models/user.dart';

part 'contact_info.g.dart';

@JsonSerializable()
class ContactInfo {
  int? id;
  User? user;
  String? title;
  String? firstname;
  String? secondName;
  String? lastname;
  String? nickname;
  String? gender;
  String? pronouns;
  String? relationshipStatus;
  Map<String, List<String>>? imageUrls;
  Map<String, List<String>>? phoneNumbers;
  Map<String, List<String>>? emails;
  Map<String, List<String>>? descriptions;
  Map<String, List<String>>? websites;
  Map<String, List<String>>? socials;
  int? birthYear;
  int? birthMonth;
  int? birthDay;
  String? addressCountry;
  String? addressPostalCode;
  String? addressCity;
  String? addressStreet;
  String? addressHouseNumber;
  String? addressAddition;
  String? workTitle;
  String? workDescription;
  String? workCompany;

  ContactInfo({
    this.id,
    this.user,
    this.title,
    this.firstname,
    this.secondName,
    this.lastname,
    this.nickname,
    this.gender,
    this.pronouns,
    this.relationshipStatus,
    this.imageUrls,
    this.phoneNumbers,
    this.emails,
    this.descriptions,
    this.websites,
    this.socials,
    this.birthYear,
    this.birthMonth,
    this.birthDay,
    this.addressCountry,
    this.addressPostalCode,
    this.addressCity,
    this.addressStreet,
    this.addressHouseNumber,
    this.addressAddition,
    this.workTitle,
    this.workDescription,
    this.workCompany,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) => _$ContactInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ContactInfoToJson(this);
}