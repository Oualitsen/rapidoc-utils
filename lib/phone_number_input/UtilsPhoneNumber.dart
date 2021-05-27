part 'UtilsPhoneNumber.g.dart';

class UtilsPhoneNumber {
  String region = "";
  int regionCode = 213;
  String national = "";
  String international = "";
  UtilsPhoneNumber({
    this.regionCode: 213,
    this.international: "",
    this.national: "",
    this.region: "DZ",
  });

  factory UtilsPhoneNumber.fromJson(Map<String, dynamic> json) => _$PhoneNumberFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneNumberToJson(this);
}
