import 'package:test/test.dart';
import 'package:path/path.dart' as path;
import '../lib/src/cli.dart' as cli;

void main() {
  group('formulateGlobalPath', () {
    final posixContext = path.Context(
      style: path.Style.posix,
      current: '/home/lev/work',
    );
    final windowsContext = path.Context(
      style: path.Style.windows,
      current: r'C:\work',
    );
    // LOCAL SEGMENTS
    test("check unix formulation with LOCAL segment", () {
      var notGlobalSegement = "newproject/1";
      expect(
        cli.formulateGlobalPath(
          notGlobalSegement,
          "/home/lev/work",
          pathContext: posixContext,
          operatingSystem: 'linux',
        ),
        equals("/home/lev/work/newproject/1"),
      );
    });
    test("check windows formulation with LOCAL segment", () {
      var notGlobalSegement = r'newproject\1';
      expect(
        cli.formulateGlobalPath(
          notGlobalSegement,
          r'C:\work',
          pathContext: windowsContext,
          operatingSystem: 'windows',
        ),
        equals(r'C:\work\newproject\1'),
      );
    });
    // GLOBAL SEGMENTS
    test("check unix formulation with GLOBAL segment", () {
      var notGlobalSegement = "/newproject/1/";
      expect(
        cli.formulateGlobalPath(
          notGlobalSegement,
          "/home/lev/work",
          pathContext: posixContext,
          operatingSystem: 'linux',
        ),
        equals("/newproject/1/"),
      );
    });
    test("check windows formulation with GLOBAL segment", () {
      var notGlobalSegement = r'j:\newproject\1\';
      expect(
        cli.formulateGlobalPath(
          notGlobalSegement,
          r'C:\work',
          pathContext: windowsContext,
          operatingSystem: 'windows',
        ),
        equals(r'j:\newproject\1\'),
      );
    });
  });
}
