// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UtilsPhoneNumber.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UtilsPhoneNumber _$PhoneNumberFromJson(Map<String, dynamic> json) {
  return UtilsPhoneNumber(
    regionCode: json['regionCode'] as int? ?? 213,
    international: json['international'] as String? ?? '',
    national: json['national'] as String? ?? '',
    region: json['region'] as String? ?? '',
  );
}

Map<String, dynamic> _$PhoneNumberToJson(UtilsPhoneNumber instance) => <String, dynamic>{
      'region': instance.region,
      'regionCode': instance.regionCode,
      'national': instance.national,
      'international': instance.international,
    };
