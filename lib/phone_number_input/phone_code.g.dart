// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneCode _$PhoneCodeFromJson(Map<String, dynamic> json) => PhoneCode(
      name: json['name'] as String? ?? "",
      dial: json['dial'] as String? ?? "",
      code: json['code'] as String? ?? "",
      flagUrl: json['flagUrl'] as String?,
    );

Map<String, dynamic> _$PhoneCodeToJson(PhoneCode instance) => <String, dynamic>{
      'name': instance.name,
      'dial': instance.dial,
      'code': instance.code,
      'flagUrl': instance.flagUrl,
    };
