enum ContactOptions {
  TITLE("title", 0),
  FIRSTNAME("firstname", 1),
  SECONDNAME("secondName", 2),
  LASTNAME("lastname", 3),
  NICKNAME("nickname", 4),
  GENDER("gender", 5),
  PRONOUNS("pronouns", 6),
  RELATIONSHIP_STATUS("relationshipStatus", 7),
  IMAGE_URLS("imageUrls", 8),
  PHONE_NUMBERS("phoneNumbers", 9),
  EMAILS("emails", 10),
  DESCRIPTIONS("descriptions", 11),
  WEBSITES("websites", 12),
  SOCIALS("socials", 13),
  BIRTH_YEAR("birthYear", 14),
  BIRTH_MONTH("birthMonth", 15),
  BIRTH_DAY("birthDay", 16),
  ADDRESS_COUNTRY("addressCountry", 17),
  ADDRESS_POSTAL_CODE("addressPostalCode", 18),
  ADDRESS_CITY("addressCity", 19),
  ADDRESS_STREET("addressStreet", 20),
  ADDRESS_HOUSE_NUMBER("addressHouseNumber", 21),
  ADDRESS_ADDITION("addressAddition", 22),
  WORK_TITLE("workTitle", 23),
  WORK_DESCRIPTION("workDescription", 24),
  WORK_COMPANY("workCompany", 25);

  final String displayName;
  final int number;

  const ContactOptions(this.displayName, this.number);

  static ContactOptions fromNumber(int number) {
    return ContactOptions.values.firstWhere(
          (e) => e.number == number,
      orElse: () => throw ArgumentError('Invalid number: $number'),
    );
  }
}
