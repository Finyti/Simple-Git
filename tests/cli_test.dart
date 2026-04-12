import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../lib/src/cli.dart';

void main() {
  group('formulateGlobalPath', () {
    final cli = Cli();
    test('check unix formulation with LOCAL segment', () {
      var notGlobalSegement = 'newproject/1';
      expect(
        cli.formulateGlobalPath(
          notGlobalSegement,
          '/home/lev/work',
          operatingSystem: 'linux',
        ),
        equals('/home/lev/work/newproject/1'),
      );
    });
    test('check windows formulation with LOCAL segment', () {
      var notGlobalSegement = r'newproject\1';
      expect(
        cli.formulateGlobalPath(
          notGlobalSegement,
          r'C:\work',
          operatingSystem: 'windows',
        ),
        equals(r'C:\work\newproject\1'),
      );
    });
    test('check unix formulation with GLOBAL segment', () {
      var notGlobalSegement = '/newproject/1/';
      expect(
        cli.formulateGlobalPath(
          notGlobalSegement,
          '/home/lev/work',
          operatingSystem: 'linux',
        ),
        equals('/newproject/1/'),
      );
    });
    test('check windows formulation with GLOBAL segment', () {
      var notGlobalSegement = r'j:\newproject\1\';
      expect(
        cli.formulateGlobalPath(
          notGlobalSegement,
          r'C:\work',
          operatingSystem: 'windows',
        ),
        equals(r'j:\newproject\1\'),
      );
    });
  });
}
