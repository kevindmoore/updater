import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supa_manager/supa_manager.dart';

part 'apps.freezed.dart';
part 'apps.g.dart';


@Freezed(makeCollectionsUnmodifiable: false)
@With<HasId>()
class Apps with _$Apps, HasId {
  const Apps._();
  @override
  int? get tableId => id;
  @JsonSerializable(explicitToJson: true)
  const factory Apps({
    required String appName,
    @JsonKey(includeIfNull: false) int? id,
    @JsonKey(includeIfNull: false) String? macAppPath,
    @JsonKey(includeIfNull: false) String? windowsAppPath,
  }) = _Apps;

  factory Apps.fromJson(Map<String, dynamic> json) =>
      _$AppsFromJson(json);

}