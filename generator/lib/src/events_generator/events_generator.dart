import 'dart:io';

import 'package:dcli/dcli.dart';

import '../feature_generator/models/data/event.dart';
import '../helpers/helpers.dart';
import 'event_code_builder.dart';

class EventsGenerator {
  final List<Event> events;
  final Directory dataDirectory;

  EventsGenerator({
    required this.events,
    required this.dataDirectory,
  });

  Future<void> generate() async {
    final eventsDirectory = await dataDirectory.createDirectory('events');
    for (final event in events) {
      final eventFileName = event.name.snakeCase + 'event.dart';
      final directory = Directory.current;
      final eventFile = directory.search(eventFileName);
      if (eventFile == null) {
        print(yellow(
            'Start Generating File $eventFileName For ${event.name} 👀'));
        final repositoryClass = EventCodeBuilder.generateEvent(
            eventFileName.replaceAll('.dart', '').fromSnakeCaseToPascalCase,
            event);
        final File file = File(eventsDirectory.path + '/$eventFileName');
        await file.writeAsString(repositoryClass);
        print(green('File $eventFileName For ${event.name} Generated 🚀🥳'));
      } else {
        print(grey('File $eventFileName For ${event.name} Found'
            ' So No Need To Generate It 💪🏽'));
      }
    }
  }
}
