// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Tag _$$_TagFromJson(Map<String, dynamic> json) => _$_Tag(
      name: json['name'] as String,
      parent: json['parent'] as String?,
      children:
          (json['children'] as List<dynamic>).map((e) => e as String).toSet(),
      files: (json['files'] as List<dynamic>).map((e) => e as String).toSet(),
    );

Map<String, dynamic> _$$_TagToJson(_$_Tag instance) => <String, dynamic>{
      'name': instance.name,
      'parent': instance.parent,
      'children': instance.children.toList(),
      'files': instance.files.toList(),
    };
