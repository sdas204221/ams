import 'dart:convert';
import 'dart:typed_data';

class FileEntity {
  final String data; // base64 string
  final String filename;

  FileEntity({required this.data, required this.filename});

  factory FileEntity.fromBytes(Uint8List bytes, String name) {
    return FileEntity(
      data: base64Encode(bytes),
      filename: name,
    );
  }

  factory FileEntity.fromJson(Map<String, dynamic> json) {
    return FileEntity(
      data: json['data'],
      filename: json['filename'],
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data,
        'filename': filename,
      };

  Uint8List get bytes => base64Decode(data);
}
