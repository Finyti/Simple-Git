import 'dart:typed_data';

import 'package:simple_git/src/Objects/Blob.dart';
import 'package:simple_git/src/Objects/BlobData.dart';
import 'package:simple_git/src/Objects/Commit.dart';
import 'package:simple_git/src/Objects/CommitData.dart';
import 'package:simple_git/src/Objects/IndexEntry.dart';
import 'package:simple_git/src/Objects/Tree.dart';
import 'package:simple_git/src/Objects/TreeData.dart';
import 'package:simple_git/src/Objects/TreeEntry.dart';
import 'package:test/test.dart';
import '../lib/src/formatting.dart';

void main() {
  group('persisted object wrappers', () {
    test('Blob stores id, data, and type name', () {
      final blob = Blob(Uint8List.fromList([0x0a, 0xff]), BlobData(123));

      expect(blob.typeName, equals('blob'));
      expect(blob.getIdBytes, equals(Uint8List.fromList([0x0a, 0xff])));
      expect(Formatting().objectIdToHashString(blob.getIdBytes), equals('0aff'));
      expect(blob.data.payloadSize, equals(123));
    });

    test('Commit stores id, data, and type name', () {
      final commitData = CommitData(55, [
        Uint8List.fromList([0x01, 0x02]),
      ], 'author', 'committer', 'message');
      final commit = Commit(Uint8List.fromList([0xab, 0xcd]), commitData);

      expect(commit.typeName, equals('commit'));
      expect(commit.getIdBytes, equals(Uint8List.fromList([0xab, 0xcd])));
      expect(Formatting().objectIdToHashString(commit.getIdBytes), equals('abcd'));
      expect(commit.data, same(commitData));
    });

    test('Tree stores id, data, and type name', () {
      final treeData = TreeData(7, []);
      final tree = Tree(Uint8List.fromList([0x12, 0x34]), treeData);

      expect(tree.typeName, equals('tree'));
      expect(tree.getIdBytes, equals(Uint8List.fromList([0x12, 0x34])));
      expect(Formatting().objectIdToHashString(tree.getIdBytes), equals('1234'));
      expect(tree.data, same(treeData));
    });
  });

  group('entry objects', () {
    test('TreeEntry keeps object id access and hash conversion', () {
      final entry = TreeEntry(
        Uint8List.fromList([0xde, 0xad, 0xbe, 0xef]),
        0100644,
        'README.md',
      );

      expect(entry.typeName, equals('treeentry'));
      expect(
        entry.getIdBytes,
        equals(Uint8List.fromList([0xde, 0xad, 0xbe, 0xef])),
      );
      expect(Formatting().objectIdToHashString(entry.getIdBytes), equals('deadbeef'));
    });

    test('IndexEntry keeps object id access and hash conversion', () {
      final entry = IndexEntry(
        Uint8List.fromList([0xca, 0xfe]),
        0100644,
        Uint8List.fromList([0x00, 0x09]),
        Uint8List.fromList([1, 2, 3]),
      );

      expect(entry.typeName, equals('indexentry'));
      expect(entry.getIdBytes, equals(Uint8List.fromList([0xca, 0xfe])));
      expect(Formatting().objectIdToHashString(entry.getIdBytes), equals('cafe'));
    });
  });

  group('payload data objects', () {
    test('BlobData is creatable without id', () {
      final blobData = BlobData(44);

      expect(blobData.payloadSize, equals(44));
    });

    test('CommitData is creatable without id', () {
      final commitData = CommitData(88, [], 'author', 'committer', 'message');

      expect(commitData.payloadSize, equals(88));
      expect(commitData.parentsCommitId, isEmpty);
      expect(commitData.author, equals('author'));
      expect(commitData.commiter, equals('committer'));
      expect(commitData.message, equals('message'));
    });

    test('TreeData remains mutable payload container', () {
      final treeData = TreeData(12, []);
      final entry = TreeEntry(Uint8List.fromList([0x01]), 0100644, 'file.txt');

      treeData.addEntries([entry]);

      expect(treeData.payloadSize, equals(12));
      expect(treeData.getEntry(0), same(entry));

      treeData.deleteEntry(0);

      expect(treeData.entries, isEmpty);
    });
  });
}
