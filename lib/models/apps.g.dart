// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apps.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Apps _$$_AppsFromJson(Map<String, dynamic> json) => _$_Apps(
      appName: json['appName'] as String,
      id: json['id'] as int?,
      macAppPath: json['macAppPath'] as String?,
      windowsAppPath: json['windowsAppPath'] as String?,
    );

Map<String, dynamic> _$$_AppsToJson(_$_Apps instance) {
  final val = <String, dynamic>{
    'appName': instance.appName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('macAppPath', instance.macAppPath);
  writeNotNull('windowsAppPath', instance.windowsAppPath);
  return val;
}
