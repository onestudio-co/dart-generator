import 'package:args/command_runner.dart';

import 'make_event_command.dart';
import 'make_factory_command.dart';
import 'make_feature_command.dart';

class MakeCommand extends Command {
  @override
  String get name => 'make';

  @override
  String get description => 'generate files';

  MakeCommand() {
    addSubcommand(MakeFactoryCommand());
    addSubcommand(MakeFeatureCommand());
    addSubcommand(MakeEventCommand());
  }
}
