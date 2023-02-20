import 'package:m3u/m3u.dart';
import 'package:test/test.dart';

import '../utils/file_loader.dart';

void main() {
  test('M3U_Plus single line - parsing all attribues', () async {
    final playlist =
        await parseFile(await FileUtils.loadFile(fileName: 'plus/single_line'));
    final testSubject = playlist[0];

    expect(testSubject.attributes['tvg-id'], 'identifier');
    expect(testSubject.attributes['tvg-name'], 'a random name');
    expect(testSubject.attributes['tvg-logo'],
        'https://cdn.instructables.com/FGO/LD7W/HF23T3BP/FGOLD7WHF23T3BP.LARGE.jpg');
    expect(testSubject.attributes['group-title'], 'The Only one');
    expect(testSubject.title, 'A TV channel');
    expect(testSubject.link, 'https://vimeo.com/63031638');

    // Missing
    //#EXTINF:-1
  });

  test('M3U_Plus multi line file', () async {
    final playlist =
        await parseFile(await FileUtils.loadFile(fileName: 'plus/multi_line'));

    expect(playlist.length, 5);
  });

  test('M3U_Plus multi line file more headers', () async {
    final playlist =
    await parseFile(await FileUtils.loadFile(fileName: 'plus/multi_line_more_headers'));

    expect(playlist.length, 5);
    expect(playlist[0].title, "Первый канал");
  });

  test('M3U_Plus multi line file no header', () async {
    final playlist =
    await parseFile(await FileUtils.loadFile(fileName: 'plus/multi_line_no_header'));

    expect(playlist.length, 5);
    expect(playlist[0].title, "Первый канал");
  });

  test('M3U_Plus single line file first line empty', () async {
    final playlist =
    await parseFile(await FileUtils.loadFile(fileName: 'plus/single_line_first_line_empty'));
    final testSubject = playlist[0];
      expect(testSubject.title, 'A TV channel');
      expect(testSubject.link, 'https://vimeo.com/63031638');
  });


  test('M3U_Plus single line file empty lines', () async {
    final playlist =
    await parseFile(await FileUtils.loadFile(fileName: 'plus/single_line_empty_lines'));
    final video1 = playlist[0];
    expect(video1.title, ' M.Liga De Campeones 1080 Multi');
    expect(video1.link, 'acestream://045718bad2ddb4f03b1a420754a97a23ad8b493b');

    final video2 = playlist[1];
    expect(video2.title, ' M.Liga De Campeones 1080');
    expect(video2.link, 'acestream://2bac25f323be1de8208d6554337c2c8256bc32bc');
  });


  test('M3U_Plus single line file with extgrp', () async {
    final playlist =
    await parseFile(await FileUtils.loadFile(fileName: 'plus/single_line_extgrp'));
    final video1 = playlist[0];
    expect(video1.title, 'Первый канал HD');
    expect(video1.attributes["group-title"], 'Россия (RU)');
    expect(video1.link, 'https://link1.su:30455/PERVIY/video.m3u8?token=bXVsdDY5fHxiak50Ym1GMU9XdHpOQT09');

    final video2 = playlist[1];
    expect(video2.title, 'НТВ HD');
    expect(video2.attributes["group-title"], 'Россия (RU)');
    expect(video2.link, 'https://link1.su:4399/ntvhd/video.m3u8?token=bXVsdDY5fHxiak50Ym1GMU9XdHpOQT09');

    final video3 = playlist[2];
    expect(video3.title, 'НТВ +2');
    expect(video3.attributes["group-title"], 'Плюсовые (RU)');
    expect(video3.link, 'https://link1.su:9304/NTVPLUS2/video.m3u8?token=bXVsdDY5fHxiak50Ym1GMU9XdHpOQT09');
  });
}
