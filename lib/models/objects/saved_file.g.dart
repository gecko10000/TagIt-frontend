// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SavedFile _$$_SavedFileFromJson(Map<String, dynamic> json) => _$_SavedFile(
      info: FileInfo.fromJson(json['fileInfo'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toSet(),
    );

Map<String, dynamic> _$$_SavedFileToJson(_$_SavedFile instance) =>
    <String, dynamic>{
      'fileInfo': instance.info,
      'tags': instance.tags.toList(),
    };
