enum ExpirationType {
  ONETIME(0),
  DAY(1),
  WEEK(2),
  MONTH(3),
  NEVER(4);

  final int number;

  const ExpirationType(this.number);

  static ExpirationType fromNumber(int number) {
    return ExpirationType.values.firstWhere(
          (e) => e.number == number,
      orElse: () => throw ArgumentError('Invalid number: $number'),
    );
  }
}
