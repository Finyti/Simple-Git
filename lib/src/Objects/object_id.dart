import 'dart:typed_data';

String objectIdToHashString(Uint8List objectIdBytes) {
  String buffer = "";

  for (int byte in objectIdBytes) {
    buffer += byte.toRadixString(16).padLeft(2, '0');
  }

  return buffer;
}
