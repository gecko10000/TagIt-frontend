// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FileInfo _$FileInfoFromJson(Map<String, dynamic> json) {
  return _FileInfo.fromJson(json);
}

/// @nodoc
mixin _$FileInfo {
  String get name => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;
  int get modificationTimeMillis => throw _privateConstructorUsedError;
  int get fileSizeBytes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FileInfoCopyWith<FileInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileInfoCopyWith<$Res> {
  factory $FileInfoCopyWith(FileInfo value, $Res Function(FileInfo) then) =
      _$FileInfoCopyWithImpl<$Res, FileInfo>;
  @useResult
  $Res call(
      {String name,
      String mimeType,
      int modificationTimeMillis,
      int fileSizeBytes});
}

/// @nodoc
class _$FileInfoCopyWithImpl<$Res, $Val extends FileInfo>
    implements $FileInfoCopyWith<$Res> {
  _$FileInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? mimeType = null,
    Object? modificationTimeMillis = null,
    Object? fileSizeBytes = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      modificationTimeMillis: null == modificationTimeMillis
          ? _value.modificationTimeMillis
          : modificationTimeMillis // ignore: cast_nullable_to_non_nullable
              as int,
      fileSizeBytes: null == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FileInfoCopyWith<$Res> implements $FileInfoCopyWith<$Res> {
  factory _$$_FileInfoCopyWith(
          _$_FileInfo value, $Res Function(_$_FileInfo) then) =
      __$$_FileInfoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String mimeType,
      int modificationTimeMillis,
      int fileSizeBytes});
}

/// @nodoc
class __$$_FileInfoCopyWithImpl<$Res>
    extends _$FileInfoCopyWithImpl<$Res, _$_FileInfo>
    implements _$$_FileInfoCopyWith<$Res> {
  __$$_FileInfoCopyWithImpl(
      _$_FileInfo _value, $Res Function(_$_FileInfo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? mimeType = null,
    Object? modificationTimeMillis = null,
    Object? fileSizeBytes = null,
  }) {
    return _then(_$_FileInfo(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      modificationTimeMillis: null == modificationTimeMillis
          ? _value.modificationTimeMillis
          : modificationTimeMillis // ignore: cast_nullable_to_non_nullable
              as int,
      fileSizeBytes: null == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FileInfo implements _FileInfo {
  const _$_FileInfo(
      {required this.name,
      required this.mimeType,
      required this.modificationTimeMillis,
      required this.fileSizeBytes});

  factory _$_FileInfo.fromJson(Map<String, dynamic> json) =>
      _$$_FileInfoFromJson(json);

  @override
  final String name;
  @override
  final String mimeType;
  @override
  final int modificationTimeMillis;
  @override
  final int fileSizeBytes;

  @override
  String toString() {
    return 'FileInfo(name: $name, mimeType: $mimeType, modificationTimeMillis: $modificationTimeMillis, fileSizeBytes: $fileSizeBytes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FileInfo &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.modificationTimeMillis, modificationTimeMillis) ||
                other.modificationTimeMillis == modificationTimeMillis) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, mimeType, modificationTimeMillis, fileSizeBytes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FileInfoCopyWith<_$_FileInfo> get copyWith =>
      __$$_FileInfoCopyWithImpl<_$_FileInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FileInfoToJson(
      this,
    );
  }
}

abstract class _FileInfo implements FileInfo {
  const factory _FileInfo(
      {required final String name,
      required final String mimeType,
      required final int modificationTimeMillis,
      required final int fileSizeBytes}) = _$_FileInfo;

  factory _FileInfo.fromJson(Map<String, dynamic> json) = _$_FileInfo.fromJson;

  @override
  String get name;
  @override
  String get mimeType;
  @override
  int get modificationTimeMillis;
  @override
  int get fileSizeBytes;
  @override
  @JsonKey(ignore: true)
  _$$_FileInfoCopyWith<_$_FileInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
