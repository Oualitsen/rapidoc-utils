// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_number.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneNumber _$PhoneNumberFromJson(Map<String, dynamic> json) => PhoneNumber(
      regionCode: json['regionCode'] as int? ?? 213,
      international: json['international'] as String? ?? "",
      national: json['national'] as String? ?? "",
      region: json['region'] as String? ?? "DZ",
    );

Map<String, dynamic> _$PhoneNumberToJson(PhoneNumber instance) =>
    <String, dynamic>{
      'region': instance.region,
      'regionCode': instance.regionCode,
      'national': instance.national,
      'international': instance.international,
    };
