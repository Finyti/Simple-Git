import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as path;
import 'package:simple_git/src/Objects/Blob.dart';
import 'package:simple_git/src/Objects/BlobData.dart';
import 'package:simple_git/src/Objects/IndexData.dart';

import 'filesystem.dart';
import 'formatting.dart';

/// Acts as an intermediate layer between actual filesystem and logic of the app
class Storage {
  Storage({
    Filesystem? filesystem,
    Formatting? formatting,
    String? rootDirectory,
  }) : filesystem = filesystem ?? Filesystem(),
       formatting = formatting ?? Formatting(),
       rootDirectory = rootDirectory ?? Directory.current.path;

  final Filesystem filesystem;
  final Formatting formatting;
  final String rootDirectory;

  /// Returns true if a path is a Repo.
  ///
  /// Optional Input:
  ///   targetPath - specifies where to check
  ///
  /// If no targetPath was specified, assumes working directory
  bool isARepo({String targetPath = ''}) {
    if (targetPath == '') {
      targetPath = rootDirectory;
    }
    return filesystem.doesPathExist(path.join(targetPath, '.ssm')) &&
        filesystem.doesPathExist(path.join(targetPath, '.ssm', 'HEAD'));
  }

  /// Creates .ssm dir. and its file structure
  ///
  /// Optional Input:
  ///   setupLocation - specifies where to setup
  ///
  /// If no setupLocation was specifies, assumes working directory
  void setupRepository({String setupLocation = ''}) {
    if (setupLocation == '') {
      setupLocation = rootDirectory;
    }
    filesystem.createFile(
      path.join(setupLocation, '.ssm'),
      'HEAD',
      content: path.join('refs', 'heads', 'main'),
    );
    filesystem.createFile(
      path.join(setupLocation, '.ssm', 'refs', 'heads'),
      'main',
    );
    filesystem.createFolder(path.join(setupLocation, '.ssm', 'refs'), 'tags');
    filesystem.createFolder(path.join(setupLocation, '.ssm'), 'objects');
    createEmptyIndexFile();
  }

  /// Returns string with the type of a specified path
  ///
  /// Required Input:
  ///   targetPath - path to check
  ///
  /// Returns: either: "file", "directory", or empty string if neither
  String typeOfPathTarget(String targetPath) {
    if (filesystem.isAFile(targetPath)) {
      return 'file';
    } else if (filesystem.isADirectory(targetPath)) {
      return 'directory';
    }
    return '';
  }

  /// Creates blob object in filesystem and returns its representation in Blob class
  ///
  /// Required Input:
  ///   targetPath - path to the file that needs to be recorded as blob
  ///
  /// Returns: new Blob class object
  Blob createABlob(String targetPath) {
    int fileSize = filesystem.getFileSize(targetPath);
    Uint8List fileData = filesystem.readFile(targetPath);
    BlobData newBlobData = BlobData(fileSize);

    Uint8List rawBytes = formatting.encodeBlob(newBlobData, fileData);
    Uint8List hashId = formatting.hashBytes(rawBytes);

    Blob newBlob = Blob(hashId, newBlobData);

    String newBlobIdString = formatting.objectIdToHashString(
      newBlob.getIdBytes,
    );

    filesystem.createFile(
      path.join(
        rootDirectory,
        '.ssm',
        'objects',
        newBlobIdString.substring(0, 2),
      ),
      newBlobIdString.substring(2),
      content: rawBytes,
    );

    return newBlob;
  }

  /// Creates or rewrites Index file in repo with empty structure. Called during setup of repo or after commit
  ///
  void createEmptyIndexFile() {
    final emptyIndexBytes = formatting.encodeIndex(IndexData([]));
    filesystem.createFile(
      path.join(rootDirectory, '.ssm'),
      'index',
      content: emptyIndexBytes,
    );
  }

  /// Returns relative (to repos root) path to the current branch
  ///
  /// Optional input:
  ///   onlyBranchName - flag for a function to return only the name of the branch
  String readHead({bool onlyBranchName = false}) {
    String head = filesystem.readFileString(
      path.join(rootDirectory, '.ssm', 'HEAD'),
    );
    if (onlyBranchName) {
      String branch = head.split(Platform.pathSeparator).last;
      return branch;
    }
    return head;
  }

  /// Returns List of global paths to all files inside all provided paths
  ///
  /// Required Input:
  ///   potentialPaths - List of global paths to files and directories
  ///
  /// Special char "." is supported. If "." is included withing potentialPaths, it will treat it as path to repos root
  ///
  /// Returns: List of global paths to all collected files
  List<String> collectAddableFiles(List<String> potentialPaths) {
    List<String> collectedFiles = [];
    for (String targetPath in potentialPaths) {
      if (typeOfPathTarget(targetPath) == '') {
        print('Skipping invalid path ${targetPath}');
        continue;
      }
      if (targetPath == '.') {
        collectedFiles += filesystem.collectFiles(rootDirectory);
        continue;
      }
      if (typeOfPathTarget(targetPath) == 'directory') {
        if (targetPath.startsWith(rootDirectory)) {
          collectedFiles += filesystem.collectFiles(targetPath);
        }
        continue;
      }
      if (typeOfPathTarget(targetPath) == 'file') {
        if (targetPath.startsWith(rootDirectory)) {
          collectedFiles.add(targetPath);
        }
        continue;
      }
    }

    return collectedFiles;
  }
}
