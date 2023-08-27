// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'displayable.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Displayable {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Tag tag) tag,
    required TResult Function(SavedFile savedFile) file,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Tag tag)? tag,
    TResult? Function(SavedFile savedFile)? file,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Tag tag)? tag,
    TResult Function(SavedFile savedFile)? file,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Tag value) tag,
    required TResult Function(_SavedFile value) file,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Tag value)? tag,
    TResult? Function(_SavedFile value)? file,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Tag value)? tag,
    TResult Function(_SavedFile value)? file,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DisplayableCopyWith<$Res> {
  factory $DisplayableCopyWith(
          Displayable value, $Res Function(Displayable) then) =
      _$DisplayableCopyWithImpl<$Res, Displayable>;
}

/// @nodoc
class _$DisplayableCopyWithImpl<$Res, $Val extends Displayable>
    implements $DisplayableCopyWith<$Res> {
  _$DisplayableCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_TagCopyWith<$Res> {
  factory _$$_TagCopyWith(_$_Tag value, $Res Function(_$_Tag) then) =
      __$$_TagCopyWithImpl<$Res>;
  @useResult
  $Res call({Tag tag});

  $TagCopyWith<$Res> get tag;
}

/// @nodoc
class __$$_TagCopyWithImpl<$Res> extends _$DisplayableCopyWithImpl<$Res, _$_Tag>
    implements _$$_TagCopyWith<$Res> {
  __$$_TagCopyWithImpl(_$_Tag _value, $Res Function(_$_Tag) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tag = null,
  }) {
    return _then(_$_Tag(
      null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as Tag,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $TagCopyWith<$Res> get tag {
    return $TagCopyWith<$Res>(_value.tag, (value) {
      return _then(_value.copyWith(tag: value));
    });
  }
}

/// @nodoc

class _$_Tag implements _Tag {
  const _$_Tag(this.tag);

  @override
  final Tag tag;

  @override
  String toString() {
    return 'Displayable.tag(tag: $tag)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Tag &&
            (identical(other.tag, tag) || other.tag == tag));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tag);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TagCopyWith<_$_Tag> get copyWith =>
      __$$_TagCopyWithImpl<_$_Tag>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Tag tag) tag,
    required TResult Function(SavedFile savedFile) file,
  }) {
    return tag(this.tag);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Tag tag)? tag,
    TResult? Function(SavedFile savedFile)? file,
  }) {
    return tag?.call(this.tag);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Tag tag)? tag,
    TResult Function(SavedFile savedFile)? file,
    required TResult orElse(),
  }) {
    if (tag != null) {
      return tag(this.tag);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Tag value) tag,
    required TResult Function(_SavedFile value) file,
  }) {
    return tag(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Tag value)? tag,
    TResult? Function(_SavedFile value)? file,
  }) {
    return tag?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Tag value)? tag,
    TResult Function(_SavedFile value)? file,
    required TResult orElse(),
  }) {
    if (tag != null) {
      return tag(this);
    }
    return orElse();
  }
}

abstract class _Tag implements Displayable {
  const factory _Tag(final Tag tag) = _$_Tag;

  Tag get tag;
  @JsonKey(ignore: true)
  _$$_TagCopyWith<_$_Tag> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_SavedFileCopyWith<$Res> {
  factory _$$_SavedFileCopyWith(
          _$_SavedFile value, $Res Function(_$_SavedFile) then) =
      __$$_SavedFileCopyWithImpl<$Res>;
  @useResult
  $Res call({SavedFile savedFile});

  $SavedFileCopyWith<$Res> get savedFile;
}

/// @nodoc
class __$$_SavedFileCopyWithImpl<$Res>
    extends _$DisplayableCopyWithImpl<$Res, _$_SavedFile>
    implements _$$_SavedFileCopyWith<$Res> {
  __$$_SavedFileCopyWithImpl(
      _$_SavedFile _value, $Res Function(_$_SavedFile) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? savedFile = null,
  }) {
    return _then(_$_SavedFile(
      null == savedFile
          ? _value.savedFile
          : savedFile // ignore: cast_nullable_to_non_nullable
              as SavedFile,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $SavedFileCopyWith<$Res> get savedFile {
    return $SavedFileCopyWith<$Res>(_value.savedFile, (value) {
      return _then(_value.copyWith(savedFile: value));
    });
  }
}

/// @nodoc

class _$_SavedFile implements _SavedFile {
  const _$_SavedFile(this.savedFile);

  @override
  final SavedFile savedFile;

  @override
  String toString() {
    return 'Displayable.file(savedFile: $savedFile)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SavedFile &&
            (identical(other.savedFile, savedFile) ||
                other.savedFile == savedFile));
  }

  @override
  int get hashCode => Object.hash(runtimeType, savedFile);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SavedFileCopyWith<_$_SavedFile> get copyWith =>
      __$$_SavedFileCopyWithImpl<_$_SavedFile>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Tag tag) tag,
    required TResult Function(SavedFile savedFile) file,
  }) {
    return file(savedFile);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Tag tag)? tag,
    TResult? Function(SavedFile savedFile)? file,
  }) {
    return file?.call(savedFile);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Tag tag)? tag,
    TResult Function(SavedFile savedFile)? file,
    required TResult orElse(),
  }) {
    if (file != null) {
      return file(savedFile);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Tag value) tag,
    required TResult Function(_SavedFile value) file,
  }) {
    return file(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Tag value)? tag,
    TResult? Function(_SavedFile value)? file,
  }) {
    return file?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Tag value)? tag,
    TResult Function(_SavedFile value)? file,
    required TResult orElse(),
  }) {
    if (file != null) {
      return file(this);
    }
    return orElse();
  }
}

abstract class _SavedFile implements Displayable {
  const factory _SavedFile(final SavedFile savedFile) = _$_SavedFile;

  SavedFile get savedFile;
  @JsonKey(ignore: true)
  _$$_SavedFileCopyWith<_$_SavedFile> get copyWith =>
      throw _privateConstructorUsedError;
}
