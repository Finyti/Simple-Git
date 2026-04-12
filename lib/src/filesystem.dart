import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as path;

/// Performs simple manipulations with filesystem
class Filesystem {
  /// Creates folder in specified path
  ///
  /// Required Input:
  ///   targetPath - path where folder should be created
  ///   name - name of folder to create
  ///
  /// If parent folders do not exist, creates them.
  void createFolder(String targetPath, String name) {
    try {
      Directory(path.join(targetPath, name)).create(recursive: true);
    } catch (err) {
      print('Cant create folder structure for $targetPath \n Error: $err');
    }
  }

  /// Creates file in specified path
  ///
  /// Required Input:
  ///   targetPath - path where file should be created
  ///   name - name of file to create
  ///
  /// Optional Input:
  ///   content - data to write inside file
  ///
  /// If parent folders do not exist, creates them.
  void createFile(String targetPath, String name, {var content = ''}) {
    try {
      File(path.join(targetPath, name)).createSync(recursive: true);
      if (content != '') {
        writeFile(targetPath, name, content);
      }
    } catch (err) {
      print('Cant create file for $targetPath \n Error: $err');
    }
  }

  /// Reads file as bytes
  ///
  /// Required Input:
  ///   targetPath - path to file that should be read
  ///
  /// Returns: file content as Uint8List
  Uint8List readFile(String targetPath) {
    return File(targetPath).readAsBytesSync();
  }

  /// Reads file as string
  ///
  /// Required Input:
  ///   targetPath - path to file that should be read
  ///
  /// Returns: file content as String
  String readFileString(String targetPath) {
    return File(targetPath).readAsStringSync();
  }

  /// Returns size of specified file
  ///
  /// Required Input:
  ///   targetPath - path to file
  ///
  /// Returns: size of file in bytes
  int getFileSize(String targetPath) {
    return File(targetPath).lengthSync();
  }

  /// Writes provided content into specified file
  ///
  /// Required Input:
  ///   targetPath - path to folder containing file
  ///   name - name of file to write into
  ///   newContent - data that should be written into file
  void writeFile(String targetPath, String name, var newContent) {
    if (newContent is String) {
      File(path.join(targetPath, name)).writeAsStringSync(newContent);
    } else if (newContent is Uint8List) {
      File(path.join(targetPath, name)).writeAsBytesSync(newContent.toList());
    } else {
      File(path.join(targetPath, name)).writeAsBytesSync(newContent);
    }
  }

  /// Returns true if specified path exists
  ///
  /// Required Input:
  ///   targetPath - path to check
  bool doesPathExist(String targetPath) {
    return isADirectory(targetPath) || isAFile(targetPath);
  }

  /// Returns true if specified path is a directory
  ///
  /// Required Input:
  ///   targetPath - path to check
  bool isADirectory(String targetPath) {
    return Directory(targetPath).existsSync();
  }

  /// Returns true if specified path is a file
  ///
  /// Required Input:
  ///   targetPath - path to check
  bool isAFile(String targetPath) {
    return File(targetPath).existsSync();
  }

  /// Collects all files inside specified folder
  ///
  /// Required Input:
  ///   startingFolder - path to folder where collection starts
  ///
  /// Returns: List of paths to all files inside startingFolder
  List<String> collectFiles(String startingFolder) {
    List<String> filePaths = [];
    List<FileSystemEntity> filesystemElements = Directory(
      startingFolder,
    ).listSync();
    for (FileSystemEntity element in filesystemElements) {
      if (element.runtimeType.toString() == "_Directory") {
        filePaths += collectFiles(element.path);
      } else {
        filePaths.add(element.path);
      }
    }

    return filePaths;
  }
}
