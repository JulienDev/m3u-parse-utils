import 'package:m3u/m3u.dart';
import 'package:test/test.dart';

import '../utils/file_loader.dart';

void main() {
  test('M3U single line - parsing title', () async {
    final result = await parseFile(
        await FileUtils.loadFile(fileName: 'simple/single_line'));
    expect(result.epgUrl, null);

    final testSubject = result.entries[0];
    expect(testSubject.title, 'A TV channel');
    expect(testSubject.link, 'https://vimeo.com/63031638');
  });

  test('M3U multi line file', () async {
    final result = await parseFile(
        await FileUtils.loadFile(fileName: 'simple/multi_line'));
    expect(result.epgUrl, null);
    expect(result.entries.length, 5);
  });
}
