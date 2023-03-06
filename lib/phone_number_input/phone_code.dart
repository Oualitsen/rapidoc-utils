part 'phone_code.g.dart';

//@JsonSerializable()
class PhoneCode {
  String name = "";
  String dial = "";
  String code = "";

  String? flagUrl;

  PhoneCode({this.name: "", this.dial: "", this.code: "", this.flagUrl});

  factory PhoneCode.fromJson(Map<String, dynamic> json) =>
      _$PhoneCodeFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneCodeToJson(this);
}
