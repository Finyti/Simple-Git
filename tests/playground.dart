import 'dart:convert';
import 'dart:io';
import '../lib/src/filesystem.dart' as fs;
import 'package:path/path.dart' as path;
import '../lib/src/storage.dart' as storage;

void main() {
  print(
    storage.readHead(
      path.join(Directory.current.path, "snapshot_test"),
      onlyBranchName: true,
    ),
  );
}
