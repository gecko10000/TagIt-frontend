// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FileInfo _$$_FileInfoFromJson(Map<String, dynamic> json) => _$_FileInfo(
      name: json['name'] as String,
      mimeType: json['mimeType'] as String,
      modificationTimeMillis: json['modificationTimeMillis'] as int,
      fileSizeBytes: json['fileSizeBytes'] as int,
    );

Map<String, dynamic> _$$_FileInfoToJson(_$_FileInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'mimeType': instance.mimeType,
      'modificationTimeMillis': instance.modificationTimeMillis,
      'fileSizeBytes': instance.fileSizeBytes,
    };
