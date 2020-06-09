library epubreadertest;

import 'dart:io' as io;

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'package:epub/epub.dart';

void main() async {
  group('Hittel on Gold Mines', () {
    var targetFile;
    var bytes;

    setUpAll(() async {
      var fileName = "hittelOnGoldMines.epub";
      var fullPath =
          path.join(io.Directory.current.path, "test", "res", fileName);

      targetFile = new io.File(fullPath);

      if (!(targetFile.existsSync())) {
        throw new Exception("Specified epub file not found: ${fullPath}");
      }

      bytes = targetFile.readAsBytesSync();
    });

    test("Test Epub Ref", () async {
      var epubRef = await EpubReader.openBook(bytes);

      expect(epubRef.Author, equals("John S. Hittell"));
      expect(epubRef.Title, equals("Hittel on Gold Mines and Mining"));
    });

    test("Test Epub Read", () async {
      var epubRef = await EpubReader.readBook(bytes);

      expect(epubRef.Author, equals("John S. Hittell"));
      expect(epubRef.Title, equals("Hittel on Gold Mines and Mining"));
    });
  });

  group('All files', () async {
    var baseDir;

    setUpAll(() async {
      var baseName =
          path.join(io.Directory.current.path, "test", "res", "std");

      baseDir = new io.Directory(baseName);

      if (!(await baseDir.exists())) {
        throw new Exception("Base path does not exist: ${baseName}");
      }
    });

    test("Test can read", () async {
      await baseDir
          .list(recursive: false, followLinks: false)
          .forEach((io.FileSystemEntity fe) async {
        try {
          var tf = new io.File(fe.path);
          List<int> bytes = await tf.readAsBytes();
          var book = await EpubReader.readBook(bytes);
          expect(book, isNotNull);
        } catch (e) {
          print("File: ${fe.path}, Exception: ${e}");
          fail("Caught error...");
        }
      });
    });

    test("Test can open", () async {
      await baseDir
          .list(recursive: false, followLinks: false)
          .forEach((io.FileSystemEntity fe) async {
        try {
          var tf = new io.File(fe.path);
          var bytes = await tf.readAsBytes();
          var ref = await EpubReader.openBook(bytes);
          expect(ref, isNotNull);
        } catch (e) {
          print("File: ${fe.path}, Exception: ${e}");
          fail("Caught error...");
        }
      });
    });
  });
}
