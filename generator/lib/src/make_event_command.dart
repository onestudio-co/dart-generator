import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:generator/src/events_generator/events_generator.dart';
import 'package:generator/src/feature_generator/models/data/event.dart';

import 'helpers/helpers.dart';

class MakeEventCommand extends Command<Future<void>> {
  @override
  String get name => 'event';

  @override
  String get description =>
      'create event with given key and params the new event will placed on "feature/data/events" folder';

  MakeEventCommand() {
    argParser.addOption(
      'featureName',
      abbr: 'f',
      mandatory: true,
    );

    argParser.addOption(
      'name',
      abbr: 'n',
      help: 'you must start the name of event with the verb of this event '
          'for example View Emotions History or Click diagnosis button',
      mandatory: true,
    );

    argParser.addOption(
      'params',
      abbr: 'p',
      help: 'Pass params as array of strings '
          'for example.. [Id,Emotion Id,Emotion Text,Created At]',
      mandatory: false,
    );
  }

  Future<void> run() async {
    final String featureName = argResults?['featureName'];
    final String eventName = argResults?['name'];
    final String params = argResults?['params'];

    print('....');
    final projectName = await Directory.current.getProjectName();
    if (projectName == null) {
      throw Exception('invalid dart project');
    }

    final directory = Directory.current.getLibDirectory();
    if (!directory.existsSync()) {
      throw Exception('invalid dart project');
    }

    final featureDirectory =
        Directory('${directory.path}/features/${featureName.toSnakeCase()}');

    if (!featureDirectory.existsSync()) {
      throw Exception('feature not found');
    }

    var dataDirectory = Directory('${featureDirectory.path}/data');

    if (!dataDirectory.existsSync()) {
      dataDirectory = await dataDirectory.create();
    }

    await EventsGenerator(dataDirectory: dataDirectory, events: [
      Event(
        name: eventName,
        params: params.split(','),
      )
    ]).generate();
    print(green('Done 🥳'));
  }
}
