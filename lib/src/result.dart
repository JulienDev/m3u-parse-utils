import 'package:m3u/src/entries/generic_entry.dart';

class Result {
  String? epgUrl;
  List<M3uGenericEntry> entries= [];

  @override
  String toString() {
    return 'Result{epgUrl: $epgUrl, entries: $entries}';
  }
}