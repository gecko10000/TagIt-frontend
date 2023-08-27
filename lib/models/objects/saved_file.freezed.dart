// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SavedFile _$SavedFileFromJson(Map<String, dynamic> json) {
  return _SavedFile.fromJson(json);
}

/// @nodoc
mixin _$SavedFile {
  @JsonKey(name: "fileInfo")
  FileInfo get info => throw _privateConstructorUsedError;
  Set<String> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SavedFileCopyWith<SavedFile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedFileCopyWith<$Res> {
  factory $SavedFileCopyWith(SavedFile value, $Res Function(SavedFile) then) =
      _$SavedFileCopyWithImpl<$Res, SavedFile>;
  @useResult
  $Res call({@JsonKey(name: "fileInfo") FileInfo info, Set<String> tags});

  $FileInfoCopyWith<$Res> get info;
}

/// @nodoc
class _$SavedFileCopyWithImpl<$Res, $Val extends SavedFile>
    implements $SavedFileCopyWith<$Res> {
  _$SavedFileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? info = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      info: null == info
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as FileInfo,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FileInfoCopyWith<$Res> get info {
    return $FileInfoCopyWith<$Res>(_value.info, (value) {
      return _then(_value.copyWith(info: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_SavedFileCopyWith<$Res> implements $SavedFileCopyWith<$Res> {
  factory _$$_SavedFileCopyWith(
          _$_SavedFile value, $Res Function(_$_SavedFile) then) =
      __$$_SavedFileCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: "fileInfo") FileInfo info, Set<String> tags});

  @override
  $FileInfoCopyWith<$Res> get info;
}

/// @nodoc
class __$$_SavedFileCopyWithImpl<$Res>
    extends _$SavedFileCopyWithImpl<$Res, _$_SavedFile>
    implements _$$_SavedFileCopyWith<$Res> {
  __$$_SavedFileCopyWithImpl(
      _$_SavedFile _value, $Res Function(_$_SavedFile) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? info = null,
    Object? tags = null,
  }) {
    return _then(_$_SavedFile(
      info: null == info
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as FileInfo,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SavedFile implements _SavedFile {
  const _$_SavedFile(
      {@JsonKey(name: "fileInfo") required this.info,
      required final Set<String> tags})
      : _tags = tags;

  factory _$_SavedFile.fromJson(Map<String, dynamic> json) =>
      _$$_SavedFileFromJson(json);

  @override
  @JsonKey(name: "fileInfo")
  final FileInfo info;
  final Set<String> _tags;
  @override
  Set<String> get tags {
    if (_tags is EqualUnmodifiableSetView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_tags);
  }

  @override
  String toString() {
    return 'SavedFile(info: $info, tags: $tags)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SavedFile &&
            (identical(other.info, info) || other.info == info) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, info, const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SavedFileCopyWith<_$_SavedFile> get copyWith =>
      __$$_SavedFileCopyWithImpl<_$_SavedFile>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SavedFileToJson(
      this,
    );
  }
}

abstract class _SavedFile implements SavedFile {
  const factory _SavedFile(
      {@JsonKey(name: "fileInfo") required final FileInfo info,
      required final Set<String> tags}) = _$_SavedFile;

  factory _SavedFile.fromJson(Map<String, dynamic> json) =
      _$_SavedFile.fromJson;

  @override
  @JsonKey(name: "fileInfo")
  FileInfo get info;
  @override
  Set<String> get tags;
  @override
  @JsonKey(ignore: true)
  _$$_SavedFileCopyWith<_$_SavedFile> get copyWith =>
      throw _privateConstructorUsedError;
}
