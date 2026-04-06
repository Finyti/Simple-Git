import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:simple_git/src/Objects/Blob.dart';
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
  return fs.doesPathExist(path.join(targetPath, ".ssm")) &&
      fs.doesPathExist(path.join(targetPath, ".ssm", "HEAD"));
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

/// Returns whether a path leads to directory, file, or nothing
///
/// Returns strings:
///
/// File -> 'file'
/// Directory -> 'directory'
/// None -> ''
String typeOfPathTarget(String targetPath) {
  if (fs.isAFile(targetPath)) {
    return 'file';
  } else if (fs.isADirectory(targetPath)) {
    return 'directory';
  }
  return '';
}

Blob createABlob(String targetPath, String directoryRoot) {
  int fileSize = fs.getFileSize(targetPath);
  Uint8List fileData = fs.readFile(targetPath);
  BlobData newBlobData = new BlobData(fileSize);

  Uint8List rawBytes = formatting.formatBlob(newBlobData, fileData);
  Uint8List hashId = formatting.hashBytes(rawBytes);

  Blob newBlob = new Blob(hashId, newBlobData);

  String newBlobIdString = newBlob.getIdHashString();

  // TODO: Make a function for determening the repo root

  fs.createFile(
    path.join(
      directoryRoot,
      ".ssm",
      "objects",
      newBlobIdString.substring(0, 2),
    ),
    newBlobIdString.substring(2),
    content: rawBytes,
  );

  return newBlob;
}

/// Helper function that reads contents of HEAD file in .ssm folder.
///
/// It assumes that repositoryRoot, is indeed a repository.
///
/// It returns String that is a path to a current branch, but can also just return it's name by using onlyBranchName flag.
String readHead(String repositoryRoot, {bool onlyBranchName = false}) {
  String head = fs.readFileString(path.join(repositoryRoot, ".ssm", "HEAD"));
  if (onlyBranchName) {
    String branch = head.split(Platform.pathSeparator).last;
    return branch;
  }
  return head;
}

/// Function that determines if a path is a directory, or any of the parent paths are.
///
/// Returns path to closest repository root of the specified path.
///
/// If path is not specified, working directory selected as starting point
///
/// If no root was found, empty string is returned
String getRepositoryRoot({String startLocation = ''}) {
  if (startLocation == '') {
    startLocation = Directory.current.path;
  }
  if (isARepo(targetPath: startLocation)) {
    return startLocation;
  }

  List<String> pathSegments = startLocation.split(Platform.pathSeparator);
  if (pathSegments.length <= 1) {
    return '';
  }

  int depthIndex = pathSegments.length - 1;
  while (depthIndex > 1) {
    String parentDirectory = pathSegments
        .getRange(0, pathSegments.length)
        .join(Platform.pathSeparator);
    if (isARepo(targetPath: parentDirectory)) {
      return parentDirectory;
    }
    depthIndex -= 1;
  }

  return '';
}

// List<String> collectFiles(String pathToDirectory) {}
