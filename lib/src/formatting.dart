import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

import 'package:simple_git/src/Objects/BlobData.dart';

Uint8List formatBlob(BlobData blobData, Uint8List payloadBytes) {
  List<int> rawBytes =
      utf8.encode("blob ") +
      ascii.encode(blobData.payloadSize.toString()) +
      [0] +
      payloadBytes;
  return Uint8List.fromList(rawBytes);
}

Uint8List hashBytes(Uint8List rawBytes) {
  return Uint8List.fromList(sha1.convert(rawBytes.toList()).bytes);
}
