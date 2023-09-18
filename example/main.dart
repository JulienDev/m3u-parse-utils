import 'dart:io';

import 'package:m3u/m3u.dart';

Future<void> main(List<String> arguments) async {
  final fileContent = await File('resources/example.m3u').readAsString();
  final result = await parseFile(fileContent);
  print(result);

  // Organized categories
  final categories =
      sortedCategories(entries: result.entries, attributeName: 'group-title');
  print(categories);
}
