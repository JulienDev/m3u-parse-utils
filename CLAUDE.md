# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Dart library for parsing M3U and M3U+ playlist files. It supports parsing playlist strings into structured data with metadata extraction.

## Common Commands

### Testing
```bash
# Run all tests
dart test

# Run specific test file
dart test test/simple/parser_test.dart
dart test test/plus/parser_test.dart
dart test test/generic/invalid_formats_test.dart
```

### Development
```bash
# Get dependencies
dart pub get

# Analyze code
dart analyze

# Format code
dart format .
```

## Architecture

### Parser Flow (Stateful Line-by-Line)

The parser (`M3uParser`) uses a **state machine** pattern with context-aware variables that track parsing state across lines:

1. **State Variables**:
   - `_nextLineExpected`: Controls which type of line should be parsed next (header → headerExtra → info → source → info → ...)
   - `_currentInfoEntry`: Holds metadata for the current track being parsed (populated on info line, consumed on source line)
   - `_fileType`: Stores the detected format (M3U or M3U+)

2. **Parsing States** (`LineParsedType` enum in lib/src/line_parsed_type.dart:2-14):
   - `header`: Initial state, expects file type header (`#EXTM3U` or `#M3U`)
   - `headerExtra`: After header, allows extra headers before first entry
   - `info`: Expects metadata line (starts with `#EXTINF`)
   - `source`: Expects the URL line that follows metadata

3. **State Transitions** (lib/src/m3u_parser.dart:50-101):
   - Empty header lines are skipped, state remains `header`
   - Header can contain EPG URL (`url-tvg="..."`) extracted via regex
   - Info lines populate `_currentInfoEntry` via `_regexParse()`
   - Source lines combine with `_currentInfoEntry` to create `M3uGenericEntry`, then reset state to `info`
   - `#EXTGRP` lines in source position are skipped (state stays `source`)

### Data Model

- **Result** (lib/src/result.dart:3-11): Container for parsed data
  - `epgUrl`: Optional EPG (Electronic Program Guide) URL from header
  - `entries`: List of all parsed playlist entries

- **M3uGenericEntry** (lib/src/entries/generic_entry.dart:5-40): Represents a single playlist entry
  - `title`: Track/stream name
  - `attributes`: Key-value pairs (e.g., `tvg-id`, `group-title`)
  - `link`: Source URL

- **EntryInformation** (lib/src/entry_information.dart): Intermediate structure holding parsed metadata before URL is known

### Metadata Parsing

Regex pattern in `_regexParse()` (lib/src/m3u_parser.dart:118):
- Matches key-value pairs: `attribute="value"`
- Matches title after comma: `,Title Here`
- Example: `#EXTINF:-1 tvg-id="ch1" group-title="News",Channel Name`

### Helper Functions

- **sortedCategories()** (lib/src/playlist_helper.dart:11-24): Groups entries by any attribute name
  - Uses fold to accumulate entries into Map<String, List<M3uGenericEntry>>
  - Default category "other" for missing attributes

## Test Structure

Tests are organized by format type:
- `test/simple/`: Basic M3U format tests
- `test/plus/`: M3U+ format with metadata/categories
- `test/generic/`: Invalid format handling
- `test_resources/`: Sample playlist files used by tests

Tests use `FileUtils.loadFile()` to load fixtures from `test_resources/`.