import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import 'src/make_command.dart';
import 'src/make_factory_command.dart';
import 'src/make_feature_command.dart';

Future<void> main(List<String> arguments) async {
  final runner = CommandRunner('Dart cli', 'Dart cli');
  runner.addCommand(MakeCommand());
  runner.addCommand(MakeFeatureCommand());
  runner.addCommand(MakeFactoryCommand());

  try {
    runner.run(arguments);
  } catch (error) {
    print(red('error $error'));
  }
}
