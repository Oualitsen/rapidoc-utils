part 'phone_number.g.dart';

class PhoneNumber {
  String region = "";
  int regionCode = 213;
  String national = "";
  String international = "";
  PhoneNumber({
    this.regionCode: 213,
    this.international: "",
    this.national: "",
    this.region: "DZ",
  });

  factory PhoneNumber.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneNumberToJson(this);
}
