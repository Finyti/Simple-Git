import 'dart:io';

import 'package:simple_git/src/Objects/IndexData.dart';
import 'package:simple_git/src/Objects/Status.dart';
import 'package:simple_git/src/domain.dart';

import 'storage.dart';

/// Orchestrates requested behavior, using provided data
class Service {
  Service({Storage? storage, Domain? domain, String? rootDirectory})
    : storage = storage ?? Storage(),
      domain = domain ?? Domain(),
      rootDirectory = rootDirectory ?? Directory.current.path;

  final Storage storage;
  final Domain domain;
  final String rootDirectory;

  /// Orchestrates initialization of a repo.
  ///
  /// Required Input: 
  ///   initLocation - path to initialization location
  ///
  /// If repository already exist at path, does nothing.
  void initializeARepo(String initLocation) {
    if (storage.isARepo(targetPath: initLocation)) {
      print('Path ${initLocation} is already a repository');
      return;
    }

    storage.setupRepository(setupLocation: initLocation);
  }

  /// Orchestrates addition of paths to the index.
  ///
  /// Required Input: 
  ///   pathsToAdd - list of paths to files or directories inside of repo
  void addToIndex(List<String> pathsToAdd) {
    if (repositoryStatus().isARepo == false) {
      print('Cannot add to Index. ${rootDirectory} is not a repository');
      return;
    }

    List<String> filesToAdd = storage.collectAddableFiles(pathsToAdd);
    // TODO: figure out what paths are inside of a working dir, and refuse them
    // TODO Get an index file.

    // filesToAdd = domain.validateAdditionToIndex(rootDirectory, filesToAdd, TODO put here an index file);
  }

  // Collects and returns basic data about repository wrapped in Status object
  Status repositoryStatus() {
    Status currentStatus = Status(storage.isARepo());
    if (currentStatus.isARepo) {
      currentStatus.branch = storage.readHead(
        onlyBranchName: true,
      );
    }
    return currentStatus;
  }
}
