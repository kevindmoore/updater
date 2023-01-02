// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'versions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Versions _$$_VersionsFromJson(Map<String, dynamic> json) => _$_Versions(
      id: json['id'] as int?,
      appId: json['appId'] as int,
      versionName: json['versionName'] as String,
      bucketId: json['bucketId'] as String?,
    );

Map<String, dynamic> _$$_VersionsToJson(_$_Versions instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['appId'] = instance.appId;
  val['versionName'] = instance.versionName;
  writeNotNull('bucketId', instance.bucketId);
  return val;
}
