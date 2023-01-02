import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:updater/router/route_names.dart';

import '../database/repository.dart';
import '../models/apps.dart';

class AppList extends ConsumerStatefulWidget {
  const AppList({Key? key}) : super(key: key);

  @override
  ConsumerState<AppList> createState() => _AppListState();
}

class _AppListState extends ConsumerState<AppList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getApps(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Apps>> snapshot) {
          if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
            final apps = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                  8.0, 8.0, 8.0, kFloatingActionButtonMargin + 48),
              itemCount: apps.length,
              itemBuilder: (BuildContext context, int index) {
                return AppRow(app: apps[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          } else {
            return Container();
          }
        },),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addApp(),
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<Apps>> getApps() async {
    final repository = ref.read(repositoryProvider);
    final result = await repository.getApps();
    return result.maybeWhen(
        success: (apps) => apps,
        failure: (error) {
          logMessage('Problems getting apps $error');
          return [];
        },
        errorMessage: (code, message) {
          logMessage('Problems getting apps $message');
          return [];
        },
        orElse: () {
          logMessage('Problems uploading file');
          return [];
        });
  }

  void addApp() {
    var appName = '';
    void save() async {
      final newApp = Apps(appName: appName.trim());
      final repository = ref.read(repositoryProvider);
      await repository.addApp(newApp);
      if (!mounted) return;
      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Add App'),
            content: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.enter): save,
              },
              child: Column(
                children: [
                  TextField(
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a App Name'),
                    onChanged: (text) => appName = text,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    save();
                  },
                  child: const Text('Add')),
            ]);
      },
    );
  }
}

class AppRow extends ConsumerStatefulWidget {
  final Apps app;

  const AppRow({Key? key, required this.app}) : super(key: key);

  @override
  ConsumerState createState() => _AppRowState();
}

class _AppRowState extends ConsumerState<AppRow> {
  final appTitleStyle =
  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  final countStyle = const TextStyle(fontSize: 14.0);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0.0),
      child: Container(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => goToVersions(),
            child: InkWell(
              highlightColor: Colors.green,
              splashColor: Colors.blue,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(widget.app.appName, style: appTitleStyle)),
                  const Spacer(),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.fromLTRB(2.0, 8.0, 0.0, 8.0),
                    alignment: Alignment.centerLeft,
                    onPressed: () {
                      renameApp(widget.app);
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.fromLTRB(2.0, 8.0, 0.0, 8.0),
                    alignment: Alignment.centerLeft,
                    onPressed: () async {
                      setState(() {});
                      final repository = ref.read(repositoryProvider);
                      await repository.deleteApp(widget.app);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.fromLTRB(2.0, 8.0, 0.0, 8.0),
                    alignment: Alignment.centerLeft,
                    onPressed: () {
                      goToVersions();
                    },
                    icon: const Icon(
                      Icons.navigate_next,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void goToVersions() {
    context.go(context.namedLocation(versionRouteName,
        params: <String, String>{'appId': widget.app.id!.toString()}));
  }

  void renameApp(Apps app) {
    final appNameController = TextEditingController(text: app.appName);
    final appLocationController = TextEditingController(text: app.macAppPath);
    showDialog(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
            title: const Text('Rename App'),
            content: Column(
              children: [
                TextField(
                  controller: appNameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Update the App Name'),
                ),
                TextField(
                  controller: appLocationController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Mac App Path'),
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
                    await repository.updateApp(
                        app.copyWith(
                            appName: appNameController.text.trim(),
                            macAppPath: appLocationController.text.trim()
                        ));
                    appNameController.dispose();
                    if (!mounted) return;
                    Navigator.of(alertContext).pop();
                  },
                  child: const Text('Rename')),
            ]);
      },
    );
  }
}
