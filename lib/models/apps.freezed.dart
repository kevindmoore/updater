// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'apps.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Apps _$AppsFromJson(Map<String, dynamic> json) {
  return _Apps.fromJson(json);
}

/// @nodoc
mixin _$Apps {
  String get appName => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get macAppPath => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get windowsAppPath => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppsCopyWith<Apps> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppsCopyWith<$Res> {
  factory $AppsCopyWith(Apps value, $Res Function(Apps) then) =
      _$AppsCopyWithImpl<$Res, Apps>;
  @useResult
  $Res call(
      {String appName,
      @JsonKey(includeIfNull: false) int? id,
      @JsonKey(includeIfNull: false) String? macAppPath,
      @JsonKey(includeIfNull: false) String? windowsAppPath});
}

/// @nodoc
class _$AppsCopyWithImpl<$Res, $Val extends Apps>
    implements $AppsCopyWith<$Res> {
  _$AppsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appName = null,
    Object? id = freezed,
    Object? macAppPath = freezed,
    Object? windowsAppPath = freezed,
  }) {
    return _then(_value.copyWith(
      appName: null == appName
          ? _value.appName
          : appName // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      macAppPath: freezed == macAppPath
          ? _value.macAppPath
          : macAppPath // ignore: cast_nullable_to_non_nullable
              as String?,
      windowsAppPath: freezed == windowsAppPath
          ? _value.windowsAppPath
          : windowsAppPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AppsCopyWith<$Res> implements $AppsCopyWith<$Res> {
  factory _$$_AppsCopyWith(_$_Apps value, $Res Function(_$_Apps) then) =
      __$$_AppsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String appName,
      @JsonKey(includeIfNull: false) int? id,
      @JsonKey(includeIfNull: false) String? macAppPath,
      @JsonKey(includeIfNull: false) String? windowsAppPath});
}

/// @nodoc
class __$$_AppsCopyWithImpl<$Res> extends _$AppsCopyWithImpl<$Res, _$_Apps>
    implements _$$_AppsCopyWith<$Res> {
  __$$_AppsCopyWithImpl(_$_Apps _value, $Res Function(_$_Apps) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appName = null,
    Object? id = freezed,
    Object? macAppPath = freezed,
    Object? windowsAppPath = freezed,
  }) {
    return _then(_$_Apps(
      appName: null == appName
          ? _value.appName
          : appName // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      macAppPath: freezed == macAppPath
          ? _value.macAppPath
          : macAppPath // ignore: cast_nullable_to_non_nullable
              as String?,
      windowsAppPath: freezed == windowsAppPath
          ? _value.windowsAppPath
          : windowsAppPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_Apps extends _Apps {
  const _$_Apps(
      {required this.appName,
      @JsonKey(includeIfNull: false) this.id,
      @JsonKey(includeIfNull: false) this.macAppPath,
      @JsonKey(includeIfNull: false) this.windowsAppPath})
      : super._();

  factory _$_Apps.fromJson(Map<String, dynamic> json) => _$$_AppsFromJson(json);

  @override
  final String appName;
  @override
  @JsonKey(includeIfNull: false)
  final int? id;
  @override
  @JsonKey(includeIfNull: false)
  final String? macAppPath;
  @override
  @JsonKey(includeIfNull: false)
  final String? windowsAppPath;

  @override
  String toString() {
    return 'Apps(appName: $appName, id: $id, macAppPath: $macAppPath, windowsAppPath: $windowsAppPath)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Apps &&
            (identical(other.appName, appName) || other.appName == appName) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.macAppPath, macAppPath) ||
                other.macAppPath == macAppPath) &&
            (identical(other.windowsAppPath, windowsAppPath) ||
                other.windowsAppPath == windowsAppPath));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, appName, id, macAppPath, windowsAppPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AppsCopyWith<_$_Apps> get copyWith =>
      __$$_AppsCopyWithImpl<_$_Apps>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AppsToJson(
      this,
    );
  }
}

abstract class _Apps extends Apps {
  const factory _Apps(
      {required final String appName,
      @JsonKey(includeIfNull: false) final int? id,
      @JsonKey(includeIfNull: false) final String? macAppPath,
      @JsonKey(includeIfNull: false) final String? windowsAppPath}) = _$_Apps;
  const _Apps._() : super._();

  factory _Apps.fromJson(Map<String, dynamic> json) = _$_Apps.fromJson;

  @override
  String get appName;
  @override
  @JsonKey(includeIfNull: false)
  int? get id;
  @override
  @JsonKey(includeIfNull: false)
  String? get macAppPath;
  @override
  @JsonKey(includeIfNull: false)
  String? get windowsAppPath;
  @override
  @JsonKey(ignore: true)
  _$$_AppsCopyWith<_$_Apps> get copyWith => throw _privateConstructorUsedError;
}
