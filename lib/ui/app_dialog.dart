import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/repository.dart';
import '../models/apps.dart';

void updateApp(BuildContext context, WidgetRef ref, Apps? app, bool update) {
  final appNameController = TextEditingController(text: app?.appName);
  final macLocationController = TextEditingController(text: app?.macAppPath);
  final windowsLocationController = TextEditingController(text: app?.windowsAppPath);
  final nameHintText = (update ? 'Update the App Name' : 'App Name');
  showDialog(
    context: context,
    builder: (BuildContext alertContext) {
      return AlertDialog(
          title: Text(update ? 'Rename App' : 'Add App'),
          content: Column(
            children: [
              TextField(
                controller: appNameController,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: nameHintText),
              ),
              TextField(
                controller: macLocationController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Mac App Path'),
              ),
              TextField(
                controller: windowsLocationController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Windows App Path'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  appNameController.dispose();
                  Navigator.of(alertContext).pop();
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () async {
                  final repository = ref.read(repositoryProvider);
                  if (update) {
                    final updatedApp = app ?? Apps(appName: appNameController.text.trim());
                    await repository.updateApp(
                        updatedApp.copyWith(
                            appName: appNameController.text.trim(),
                            macAppPath: macLocationController.text.trim(),
                            windowsAppPath: macLocationController.text.trim(),
                        ));
                  } else {
                    await repository.addApp(
                        Apps(
                            appName: appNameController.text.trim(),
                            macAppPath: macLocationController.text.trim(),
                            windowsAppPath: macLocationController.text.trim(),
                        ));

                  }
                  appNameController.dispose();
//                  if (!mounted) return;
                  Navigator.of(alertContext).pop();
                },
                child: Text(update ? 'Rename' : 'Add')),
          ]);
    },
  );
}