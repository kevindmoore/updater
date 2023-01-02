import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supa_manager/supa_manager.dart';

part 'versions.freezed.dart';

part 'versions.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
@With<HasId>()
class Versions with _$Versions, HasId {
  const Versions._();

  @override
  int? get tableId => id;

  @JsonSerializable(explicitToJson: true)
  const factory Versions({
    @JsonKey(includeIfNull: false) int? id,
    required int appId,
    required String versionName,
    @JsonKey(includeIfNull: false) String? bucketId,
  }) = _Versions;

  factory Versions.fromJson(Map<String, dynamic> json) =>
      _$VersionsFromJson(json);
}
