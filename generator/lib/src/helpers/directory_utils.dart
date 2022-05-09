import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:yaml/yaml.dart';

extension DirectoryUtils on Directory {
  String relativeTo(File targetedFile) {
    return relative(targetedFile.path,
        from: Directory.current.getLibDirectory()?.path);
  }

  Future<String?> getProjectName() async {
    final contents = listSync(
      recursive: false,
    );
    File? pubspecFile;
    for (final file in contents) {
      String filename = basename(file.path);
      if (filename == 'pubspec.yaml') {
        pubspecFile = file as File;
      }
    }
    if (pubspecFile == null) return null;
    final pubspecFileContent = await pubspecFile.readAsString();
    final mapData = loadYaml(pubspecFileContent);
    return mapData['name'];
  }

  Directory? getLibDirectory() {
    return Directory(path + '/lib');
  }

  File? search(String fileName) {
    final contents = listSync(
      recursive: true,
    );
    for (final file in contents) {
      String filename = basename(file.path);
      if (filename == fileName && file is File) {
        return file;
      }
    }
    return null;
  }

  List<File> allModels() {
    final contents = listSync(
      recursive: true,
    );

    final results = <File>[];
    for (final file in contents) {
      if (file.parent.path.endsWith('models') && file is File) {
        results.add(file);
      }
    }
    return results;
  }

  Future<Directory> createDirectory(String path) async {
    Directory directory = Directory('${this.path}/$path');
    final exists = await directory.exists();
    if (exists) {
      return directory;
    } else {
      return await directory.create();
    }
  }
}
