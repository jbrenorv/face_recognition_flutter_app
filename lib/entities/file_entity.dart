import 'dart:typed_data';

class ImageFileEntity {
  const ImageFileEntity({
    required this.name,
    required this.bytes,
    this.isValid = true,
  });

  final String name;
  final Uint8List bytes;
  final bool isValid;

  factory ImageFileEntity.invalid() {
    return ImageFileEntity(
      name: '',
      bytes: Uint8List.fromList(const []),
      isValid: false,
    );
  }

  ImageFileEntity copyWith({String? name, Uint8List? bytes, bool? isValid}) {
    return ImageFileEntity(
      name: name ?? this.name,
      bytes: bytes ?? this.bytes,
      isValid: isValid ?? this.isValid,
    );
  }
}
