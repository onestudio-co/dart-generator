import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:collection/collection.dart';

import '../helpers/helpers.dart';
import 'factory_code_builder.dart';
import 'factory_visitor.dart';

class FactoryGenerator {
  static Future<void> generateFactory({
    required String projectName,
    required String factoryName,
    required Directory dataDirectory,
    required File modelFile,
    required List<File> otherRelatedFiles,
  }) async {
    final mainAst = parseFile(
      path: modelFile.path,
      featureSet: FeatureSet.latestLanguageVersion(),
    ).unit;
    final mainVisitor = FactoryVisitor(
      getDartClass: _getInnerDartClass(
        projectName,
        otherRelatedFiles,
      ),
    );
    mainVisitor.dartClass.imports.add(
        'package:${projectName}/${Directory.current.relativeTo(modelFile)}');
    mainAst.visitChildren(mainVisitor);
    final factoriesDirectory = await dataDirectory.createDirectory('factories');

    if (!factoryName.endsWith('Factory')) {
      factoryName = factoryName + 'Factory';
    }
    final factoryClass =
        FactoryCodeBuilder.buildFactory(factoryName, mainVisitor.dartClass);
    final File file =
        File(factoriesDirectory.path + '/${factoryName.toSnakeCase()}.dart');
    await file.writeAsString(factoryClass);
  }

  static DartClassFinder _getInnerDartClass(
    String projectName,
    List<File> otherRelatedFiles,
  ) {
    return (FactoryVisitor mainVisitor, String type, bool ignoreImport) {
      if (type.isNonPreemptive) {
        final input = type.toSnakeCase() + '.dart';
        final targetedFile = otherRelatedFiles.firstWhereOrNull(
          (element) => element.path.endsWith(input),
        );
        if (targetedFile != null) {
          if (!ignoreImport) {
            mainVisitor.dartClass.imports.add(
                'package:${projectName}/${Directory.current.relativeTo(
                    targetedFile)}');
          }
          final innerAst = parseFile(
            path: targetedFile.path,
            featureSet: FeatureSet.latestLanguageVersion(),
          ).unit;
          final innerVisitor = FactoryVisitor();
          innerAst.visitChildren(innerVisitor);
          return innerVisitor.dartClass;
        }
      }
      return null;
    };
  }
}
