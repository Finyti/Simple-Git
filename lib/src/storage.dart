import 'dart:io';
import 'package:path/path.dart' as path;
import 'filesystem.dart' as fs;

bool isARepo({String targetPath = ""}) {
  if (targetPath == "") {
    targetPath = Directory.current.path;
  }
  return fs.doesPathExist(path.join(targetPath, ".ssm"));
}

void setupRepository(String setupLocation) {
  fs.createFile(path.join(setupLocation, ".ssm"), "HEAD");
}
