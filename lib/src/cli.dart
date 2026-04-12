import 'dart:io';

import 'package:path/path.dart' as path;

import 'service.dart';

/// Parses user input, and forwards formatted data to appropriate method
class Cli {
  Cli({Service? service}) : service = service ?? Service();

  final Service service;

  // Map of  possible user requests
  late final Map<String, void Function(List<String>)> functionsMap = {
    'init': init,
    'add': add,
  };

  /// Entrypoint of CLI, figures out what command user called
  ///
  /// Input:
  ///   input - list of command + parameters user submitted
  void runCommand(List<String> input) {
    if (!isCommandInInput(input)) {
      return;
    }

    String command = input[0];
    List<String> arguments = input.sublist(1);

    functionsMap[command]!(arguments);
  }

  /// Function that initializes a repo inside specified path
  ///
  /// Required Input:
  ///   arguments - list of paths
  ///
  /// Possible parameters: None
  ///
  /// If no path was specified in arguments, passes on current one.
  /// If multiple paths were specified, selects the last one
  void init(List<String> arguments) {
    String initLocation = Directory.current.path;
    if (!arguments.isEmpty) {
      initLocation = formulateGlobalPath(
        arguments.last,
        Directory.current.path,
      );
    }

    service.initializeARepo(initLocation);
  }

  /// Function that adds provided paths to index
  ///
  /// Required Input:
  ///   arguments - list of paths
  ///
  /// Possible parameters: None
  ///
  /// If no paths was specified in arguments, function aborts.
  void add(List<String> arguments) {
    List<String> pathsToAdd = [];
    for (String arg in arguments) {
      if (arg[0] != '-') {
        pathsToAdd.add(formulateGlobalPath(arg, Directory.current.path));
      }
    }
    if (pathsToAdd.isEmpty) {
      print("No paths were specified to add.");
      return;
    }
    service.addToIndex(pathsToAdd);
  }

  /// Returns true if input contains valid command
  bool isCommandInInput(List<String> input) {
    if (input.isEmpty) {
      print(
        'No command provided. Try providing a valid command or type *ssm help*.',
      );
      return false;
    }
    if (!functionsMap.keys.contains(input[0])) {
      print('Unknown command ${input[0]}');
      return false;
    }
    return true;
  }

  /// Makes relative path into global ones in the format of user system
  ///
  /// Required Input:
  ///   userPath - path to be converted; currentDirectory - the base
  ///   that will be used for making path global
  ///
  /// Optional Input:
  ///   operatingSystem - string ['linux', 'macos', 'windows']
  /// Can be used to manually select the format of the path.
  /// If empty user system is selected
  String formulateGlobalPath(
    String userPath,
    String currentDirectory, {
    var operatingSystem = '',
  }) {
    var pathContext = path.context;

    if (operatingSystem == '') {
      operatingSystem = Platform.operatingSystem;
    }

    if (operatingSystem == 'linux' || operatingSystem == 'macos') {
      pathContext = path.Context(
        style: path.Style.posix,
        current: path.context.current,
      );

      if (userPath[0] == '/') {
        return userPath;
      }
    } else if (operatingSystem == 'windows') {
      pathContext = path.Context(
        style: path.Style.windows,
        current: path.context.current,
      );

      RegExpMatch? match = RegExp(r'^[A-Za-z]:\\.*').firstMatch(userPath);
      if (match != null) {
        return userPath;
      }
    }
    return pathContext.join(currentDirectory, userPath);
  }
}
