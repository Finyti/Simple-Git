import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as path;
import 'package:simple_git/src/Objects/BlobData.dart';

import '../lib/src/storage.dart';

import '../lib/src/filesystem.dart';

import '../lib/src/formatting.dart';

void main() {
  // print(
  //   Storage().readHead(
  //     path.join(Directory.current.path, 'snapshot_test'),
  //     onlyBranchName: true,
  //   ),
  // );

  // Uint8List objectIdBytes = objectHashStringToId(hash);
  BlobData newBlob = new BlobData(5);
  Uint8List payload = utf8.encode("Hello");
  Uint8List rawBytes = Formatting().encodeBlob(newBlob, payload);
  BytesBuilder bytesBuilder = BytesBuilder()..add(rawBytes);
  print(bytesBuilder.toBytes());

  // print(utf8.decode(bytesBuilder.toBytes().toList()));

  print(
    Formatting()
        .decodeBlob(bytesBuilder.toBytes().toList(), Uint8List(4))
        .getIdBytes,
  );
}
