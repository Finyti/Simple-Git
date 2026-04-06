import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

import 'package:simple_git/src/Objects/BlobData.dart';
import 'package:test/test.dart';
import '../lib/src/formatting.dart' as formatting;

void main() {
  group('blob', () {
    test("check byte conversion", () {
      BlobData testData = new BlobData(5);
      Uint8List testPayload = new Uint8List.fromList([97, 32, 98, 32, 99]);
      Uint8List result = new Uint8List.fromList([
        98,
        108,
        111,
        98,
        32,
        53,
        0,
        97,
        32,
        98,
        32,
        99,
      ]);
      expect(formatting.formatBlob(testData, testPayload), equals(result));
    });
    test("check sha1", () {
      BlobData testData = new BlobData(3);
      Uint8List testPayload = new Uint8List.fromList(utf8.encode("Hi!"));
      Uint8List sha1Result = formatting.hashBytes(
        formatting.formatBlob(testData, testPayload),
      );
      expect(
        sha1Result,
        equals(
          Uint8List.fromList(
            sha1
                .convert(utf8.encode("blob 3") + [0] + utf8.encode("Hi!"))
                .bytes,
          ),
        ),
      );
    });
  });
}
