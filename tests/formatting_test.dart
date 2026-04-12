import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:simple_git/src/Objects/BlobData.dart';
import 'package:simple_git/src/Objects/IndexData.dart';
import 'package:simple_git/src/Objects/IndexEntry.dart';
import 'package:simple_git/src/storage.dart';
import 'package:test/test.dart';

import '../lib/src/formatting.dart';

void main() {
  final formatting = Formatting();

  group('blob', () {
    test('check byte conversion', () {
      BlobData testData = BlobData(5);
      Uint8List testPayload = Uint8List.fromList([97, 32, 98, 32, 99]);
      Uint8List result = Uint8List.fromList([
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
      expect(formatting.encodeBlob(testData, testPayload), equals(result));
    });
    test('check sha1', () {
      BlobData testData = BlobData(3);
      Uint8List testPayload = Uint8List.fromList(utf8.encode('Hi!'));
      Uint8List sha1Result = formatting.hashBytes(
        formatting.encodeBlob(testData, testPayload),
      );
      expect(
        sha1Result,
        equals(
          Uint8List.fromList(
            sha1
                .convert(utf8.encode('blob 3') + [0] + utf8.encode('Hi!'))
                .bytes,
          ),
        ),
      );
    });
  });

  group('index', () {
    test('formats an empty index as a header-only file', () {
      expect(formatting.encodeIndex(IndexData([])), equals([0, 0, 0, 0]));
    });

    test('formats a single entry using big-endian fields', () {
      final indexData = IndexData([
        IndexEntry(
          Uint8List.fromList([0xde, 0xad, 0xbe, 0xef]),
          0x000081A4,
          Uint8List.fromList([0xff, 0xff]),
          Uint8List.fromList(utf8.encode('README.md')),
        ),
      ]);

      expect(
        formatting.encodeIndex(indexData),
        equals([
          0,
          0,
          0,
          1,
          0,
          0,
          129,
          164,
          222,
          173,
          190,
          239,
          0,
          9,
          82,
          69,
          65,
          68,
          77,
          69,
          46,
          109,
          100,
        ]),
      );
    });

    test('formats multiple entries in order', () {
      final indexData = IndexData([
        IndexEntry(
          Uint8List.fromList([1, 2]),
          0x000081A4,
          Uint8List.fromList([0x00, 0x01]),
          Uint8List.fromList([97]),
        ),
        IndexEntry(
          Uint8List.fromList([3, 4, 5]),
          0x00004000,
          Uint8List.fromList([0x00, 0x03]),
          Uint8List.fromList([98, 99]),
        ),
      ]);

      expect(
        formatting.encodeIndex(indexData),
        equals([
          0,
          0,
          0,
          2,
          0,
          0,
          129,
          164,
          1,
          2,
          0,
          1,
          97,
          0,
          0,
          64,
          0,
          3,
          4,
          5,
          0,
          2,
          98,
          99,
        ]),
      );
    });
  });

  group('storage index setup', () {
    late Directory tempDirectory;
    late Storage storage;

    setUp(() {
      tempDirectory = Directory.systemTemp.createTempSync('simple_git_test_');
      storage = Storage(rootDirectory: tempDirectory.path);
    });

    tearDown(() {
      if (tempDirectory.existsSync()) {
        tempDirectory.deleteSync(recursive: true);
      }
    });

    test('createEmptyIndexFile writes a zero-entry index header', () {
      Directory(
        '${tempDirectory.path}${Platform.pathSeparator}.ssm',
      ).createSync(recursive: true);

      storage.createEmptyIndexFile();

      final indexBytes = File(
        '${tempDirectory.path}${Platform.pathSeparator}.ssm${Platform.pathSeparator}index',
      ).readAsBytesSync();

      expect(indexBytes, equals([0, 0, 0, 0]));
    });

    test('setupRepository creates an empty index file', () {
      storage.setupRepository(setupLocation: tempDirectory.path);

      final indexFile = File(
        '${tempDirectory.path}${Platform.pathSeparator}.ssm${Platform.pathSeparator}index',
      );

      expect(indexFile.existsSync(), isTrue);
      expect(indexFile.readAsBytesSync(), equals([0, 0, 0, 0]));
    });
  });
}
