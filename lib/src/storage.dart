import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:simple_git/src/Objects/BlobData.dart';
import 'filesystem.dart' as fs;
import 'formatting.dart' as formatting;

/// Checks if a specified path is a repo.
///
/// If no path was specified, uses working directory path
bool isARepo({String targetPath = ""}) {
  if (targetPath == "") {
    targetPath = Directory.current.path;
  }
  return fs.doesPathExist(path.join(targetPath, ".ssm"));
}

void setupRepository(String setupLocation) {
  fs.createFile(
    path.join(setupLocation, ".ssm"),
    "HEAD",
    content: path.join("refs", "heads", "main"),
  );
  fs.createFile(path.join(setupLocation, ".ssm", "refs", "heads"), "main");
  fs.createFolder(path.join(setupLocation, ".ssm", "refs"), "tags");
  fs.createFolder(path.join(setupLocation, ".ssm"), "objects");
}

String typeOfPathTarget(String targetPath) {
  if (fs.isAFile(targetPath)) {
    return 'file';
  } else if (fs.isADirectory(targetPath)) {
    return 'directory';
  }
  return '';
}

// BlobData createABlob(targetPath) {

// }
