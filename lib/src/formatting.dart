import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:simple_git/src/Objects/Blob.dart';
import 'package:simple_git/src/Objects/BlobData.dart';
import 'package:simple_git/src/Objects/IndexData.dart';
import 'package:simple_git/src/Objects/IndexEntry.dart';


/// Formats internal objects into byte representation and hashes
class Formatting {
  /// Encodes blob data and payload into raw blob bytes
  ///
  /// Required Input:
  ///   blobData - data describing blob
  ///   payloadBytes - actual file content bytes
  ///
  /// Returns: raw bytes representing encoded blob
  Uint8List encodeBlob(BlobData blobData, Uint8List payloadBytes) {
    final bytesBuilder = BytesBuilder();
    bytesBuilder.add(utf8.encode('blob'));
    bytesBuilder.add(utf8.encode(' '));
    bytesBuilder.add(utf8.encode(blobData.payloadSize.toString()));
    bytesBuilder.add([0]);
    bytesBuilder.add(payloadBytes);

    return bytesBuilder.toBytes();
  }

  /// Decodes raw object bytes into appropriate object
  ///
  /// Required Input:
  ///   rawBytes - bytes of encoded object
  ///   hash - string hash id of object
  ///
  /// Returns: object class matching encoded object type
  dynamic decodeObject(Uint8List rawBytes, String hash) {
    Uint8List objectIdBytes = objectHashStringToId(hash);
    BytesBuilder bytesBuilder = BytesBuilder()..add(rawBytes);
    List<int> individualBytes = bytesBuilder.toBytes().toList();
    String objectString = utf8.decode(individualBytes);

    if (objectString.startsWith("blob")) {
      return decodeBlob(individualBytes, objectIdBytes);
    }
  }

  /// Decodes raw blob bytes into Blob object
  ///
  /// Required Input:
  ///   rawBytes - bytes of encoded blob
  ///   objectIdBytes - id of decoded blob
  ///
  /// Returns: new Blob class object
  Blob decodeBlob(List<int> rawBytes, Uint8List objectIdBytes) {
    // Remove 'blob '
    rawBytes = rawBytes.getRange(5, rawBytes.length).toList();

    int splitIndex = rawBytes.indexOf(0);
    List<int> headBytes = rawBytes.getRange(0, splitIndex).toList();

    BlobData newBlobData = new BlobData(int.parse(utf8.decode(headBytes)));
    Blob newBlob = new Blob(objectIdBytes, newBlobData);

    return newBlob;
  }

  /// Encodes index data into raw index bytes
  ///
  /// Required Input:
  ///   indexData - index data that should be encoded
  ///
  /// Returns: raw bytes representing encoded index
  Uint8List encodeIndex(IndexData indexData) {
    final bytesBuilder = BytesBuilder();
    bytesBuilder.add(_uint32be(indexData.getEntryCount));

    for (final entry in indexData.getEntries) {
      bytesBuilder.add(_formatIndexEntry(entry));
    }

    return bytesBuilder.toBytes();
  }

  Uint8List _formatIndexEntry(IndexEntry entry) {
    final bytesBuilder = BytesBuilder();
    bytesBuilder.add(_uint32be(entry.mode));
    bytesBuilder.add(entry.objectIdBytes);
    bytesBuilder.add(_uint16be(entry.pathBytes.length));
    bytesBuilder.add(entry.pathBytes);
    return bytesBuilder.toBytes();
  }

  Uint8List _uint32be(int value) {
    final byteData = ByteData(4)..setUint32(0, value, Endian.big);
    return byteData.buffer.asUint8List();
  }

  Uint8List _uint16be(int value) {
    final byteData = ByteData(2)..setUint16(0, value, Endian.big);
    return byteData.buffer.asUint8List();
  }

  /// Hashes provided bytes
  ///
  /// Required Input:
  ///   rawBytes - bytes that should be hashed
  ///
  /// Returns: hash as Uint8List
  Uint8List hashBytes(Uint8List rawBytes) {
    return Uint8List.fromList(sha1.convert(rawBytes.toList()).bytes);
  }

  /// Converts object id bytes into hash string
  ///
  /// Required Input:
  ///   objectIdBytes - bytes of object id
  ///
  /// Returns: object id written as string
  String objectIdToHashString(Uint8List objectIdBytes) {
    String buffer = "";

    for (int byte in objectIdBytes) {
      buffer += byte.toRadixString(16).padLeft(2, '0');
    }

    return buffer;
  }

  /// Converts hash string into object id bytes
  ///
  /// Required Input:
  ///   hashString - string representation of object id
  ///
  /// Returns: object id as Uint8List
  Uint8List objectHashStringToId(String hashString) {
    final bytesBuilder = BytesBuilder();
    for (String hexChar in hashString.split('')) {
      bytesBuilder.add([int.parse(hexChar, radix: 2)]);
    }
    return bytesBuilder.toBytes();
  }
}
