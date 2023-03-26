import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class FileUtils {
  static void openSavedDirectory(BuildContext context, String directory) {
    if (Platform.isMacOS) {
      Process.run('open', [directory]);
    }

    if (Platform.isWindows) {
      final snackBar = SnackBar(content: Text('file://$directory'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      OpenFile.open(directory);
    }
  }

  static Future<Directory?> createNewDirectory(String directory) async {
    Directory newDir = Directory(directory);
    try {
      Directory directory = await newDir.create(recursive: true);
      print('Directory created: ${directory.path}');
      return directory;
    } catch (e) {
      print('Error creating directory: $e');
    }
    return null;
  }
}
