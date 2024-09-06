enum ConfigType {
  profile(0),
  personal(1);

  final int number;

  const ConfigType(this.number);

  static ConfigType fromNumber(int number) {
    return ConfigType.values.firstWhere((e) => e.number == number);
  }
}
