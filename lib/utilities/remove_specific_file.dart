import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

Future<void> removeAssetFile(String filePath) async {
  // Delete the file from the assets folder
  final File fileToDelete = File(filePath);
  if (await fileToDelete.exists()) {
    await fileToDelete.delete();
  }

  // Update pubspec.yaml
  final pubspecFile = File('pubspec.yaml');
  List<String> lines = await pubspecFile.readAsLines();
  bool isAssetsSection = false;
  int assetsSectionStartIndex = 0;
  int assetsSectionEndIndex = 0;

  // Find the start and end index of the assets section in pubspec.yaml
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.contains('assets:')) {
      isAssetsSection = true;
      assetsSectionStartIndex = i;
      continue;
    }
    if (isAssetsSection && line.trim().isEmpty) {
      assetsSectionEndIndex = i;
      break;
    }
  }

  // Remove the file path from the assets section
  for (int i = assetsSectionStartIndex + 1; i < assetsSectionEndIndex; i++) {
    if (lines[i].trim() == '- $filePath') {
      lines.removeAt(i);
      break;
    }
  }

  // Write the modified lines back to pubspec.yaml
  await pubspecFile.writeAsString(lines.join('\n'));

  print('File $filePath removed from assets and pubspec.yaml updated.');
}

// Usage:
// removeAssetFile('/path/to/file.txt');

removeSpecificFile() async {
  try {
    await removeAssetFile('assets/db/advice.json');
        await removeAssetFile('assets/db/brand.json');
        await removeAssetFile('assets/db/cc.json');
        await removeAssetFile('assets/db/company.json');
        await removeAssetFile('assets/db/diagnosis.json');
        await removeAssetFile('assets/db/dose.json');
        await removeAssetFile('assets/db/duration.json');
        await removeAssetFile('assets/db/generic.json');
        await removeAssetFile('assets/db/handout.json');
        await removeAssetFile('assets/db/history.json');
        await removeAssetFile('assets/db/instruction.json');
        await removeAssetFile('assets/db/investigationAdvice.json');
        await removeAssetFile('assets/db/investigationReport.json');
        await removeAssetFile('assets/db/onExamination.json');
        await removeAssetFile('assets/db/onExaminationCategory.json');
        await removeAssetFile('assets/db/procedure.json');
  }catch (e) {
    print(e);
  }
}