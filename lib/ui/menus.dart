import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:process_run/cmd_run.dart';
import 'package:process_run/shell.dart';
import 'package:utilities/utilities.dart';

import '../providers.dart';

class MenuState {}


class MenuManager extends StateNotifier<MenuState> {
  final ProviderRef ref;

  MenuManager(this.ref) : super(MenuState());

  List<MenuItem> createMenus() {
    return [
      createNotesMenu(),
      createFileMenu(),
    ];
  }

  LogicalKeyboardKey getMetaKey() =>
      isMac()  ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control;

  PlatformMenu createNotesMenu() {
    return PlatformMenu(label: 'App Updater', menus: [
      PlatformMenuItem(
          label: 'Quit',
          onSelected: () => handleQuit(),
          shortcut: const SingleActivator(LogicalKeyboardKey.keyQ, meta: true)
      ),
    ]);
  }

 PlatformMenu createFileMenu() {
    return PlatformMenu(label: 'File', menus: [
        PlatformMenuItem(label: 'Log Out', onSelected: () => handleLogout()),
    ]);
  }

  void handleLogout() {
    getProviderSupaAuthManager(ref).logout();
  }

 void handleCopy() async {
   final arguments = <String>[];
   arguments.add('cp');
   arguments.add('-f');
   arguments.add(
       '\'/Users/kevin/Projects/FlutterApps/note_master/macos/Runner 2022-12-31 15-42-46/Master Note Taker.app/Contents/MacOS/Master Note Taker\'');
   arguments.add('\'/Applications/Master Note Taker.app/Contents/MacOS\'');
   final controller = ShellLinesController();
   controller.stream.listen((event) {
     logMessage(event);
   });
   final shell =
   Shell(throwOnError: false, stdout: controller.sink, verbose: false);
   try {
// Run the command
     final cmd = ProcessCmd('cp', ['-f', '/Users/kevin/Projects/FlutterApps/note_master/macos/Runner 2022-12-31 15-42-46/Master Note Taker.app/Contents/MacOS/Master Note Taker',
       '/Applications/Master Note Taker.app/Contents/MacOS']);
     await runCmd(cmd, verbose: true);
     // await shell.run(shellArguments(arguments));
   } on ShellException catch (exception) {
     logError(exception);
     // We might get a shell exception
   }
 }

  void handleQuit() {
    SystemNavigator.pop();
  }
}
