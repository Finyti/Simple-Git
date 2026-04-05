import 'dart:io';

import 'storage.dart' as storage;

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
  for (String targetPath in pathsToAdd) {
    if (targetPath == '.') {
      addAllIn(Directory.current.path);
    }
    if (storage.typeOfPathTarget(targetPath) == 'directory') {
      addAllIn(targetPath);
    } else if (storage.typeOfPathTarget(targetPath) == 'file') {
      
    } else {
      print("Invalid path ${targetPath}.");
      return;
    }
  }
}

void addAllIn(directoryPath) {}
