import 'dart:io';

import 'package:simple_git/src/Objects/Status.dart';

import 'storage.dart' as storage;

final String rootDirectory = Directory.current.path;
// TODO: But what if initLocation is a file? Find a way to find a repo root (if pwd is root, if not err)

/// Function that orchestrates initialization of a repo on a specified path.
///
/// Will do nothing in case of already existing repo on specified path.
///
/// Invalid path will result in Error.
void initializeARepo(String initLocation) {
  if (storage.isARepo(targetPath: initLocation)) {
    print("Path ${initLocation} is already a repository");
    return;
  }

  storage.setupRepository(initLocation);
}

void addToIndex(List<String> pathsToAdd) {
  if (repositoryStatus().isARepo == false) {
    print("Cannot add to Index. ${rootDirectory} is not a repository");
    return;
  }

  List<String> filesToAdd = collectAddableFiles(pathsToAdd);
  // for (String targetFilePath in filesToAdd) {
  //   if (targetPath == '.') {
  //     addAllToIndex(rootDirectory);
  //   }
  //   if (storage.typeOfPathTarget(targetPath) == 'directory') {
  //     addAllToIndex(targetPath);
  //   } else if (storage.typeOfPathTarget(targetPath) == 'file') {
  //     storage.createABlob(targetPath, rootDirectory);
  //   } else {
  //     print("Invalid path ${targetPath}");
  //     return;
  //   }
  // }
}

List<String> collectAddableFiles(potentialPaths) {
  List<String> collectedFiles = [];
  for (String targetPath in potentialPaths) {
    if (storage.typeOfPathTarget(targetPath) == '') {
      print("Skipping invalid path ${targetPath}");
      continue;
    }
    if (targetPath == '.') {
      // collectedFiles += storage.collectFiles(rootDirectory);
      continue;
    }
    if (storage.typeOfPathTarget(targetPath) == 'directory') {
      if (targetPath.startsWith(rootDirectory)) {
        // collectedFiles += storage.collectFiles(targetPath);
      }
      continue;
    }
    if (storage.typeOfPathTarget(targetPath) == 'file') {
      if (targetPath.startsWith(rootDirectory)) {
        collectedFiles.add(targetPath);
      }
      continue;
    }
  }

  return collectedFiles;
}

Status repositoryStatus() {
  Status currentStatus = new Status(storage.isARepo());
  if (currentStatus.isARepo) {
    currentStatus.branch = storage.readHead(
      rootDirectory,
      onlyBranchName: true,
    );
  }
  return currentStatus;
}
