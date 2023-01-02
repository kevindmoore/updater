import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumberdash/lumberdash.dart';

import '../database/repository.dart';
import '../models/versions.dart';
import '../router/route_names.dart';

class VersionList extends ConsumerStatefulWidget {
  final int appId;

  const VersionList(this.appId, {Key? key}) : super(key: key);

  @override
  ConsumerState<VersionList> createState() => _VersionListState();
}

class _VersionListState extends ConsumerState<VersionList> {
  var appName = '';

  @override
  void initState() {
    super.initState();
    readApp();
  }

  Future readApp() async {
    final repository = ref.read(repositoryProvider);
    final result = await repository.getApp(widget.appId);
    result.maybeWhen(success: (app) {
      appName = app.appName;
      setState(() {
      });
    }, failure: (error) {
      logMessage('Problems getting App $error');
    }, errorMessage: (code, message) {
      logMessage('Problems getting App $message');
    }, orElse: () {
      logMessage('Problems getting App');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(appName),
          automaticallyImplyLeading: true,
          //`true` if you want Flutter to automatically add Back Button when needed,
          //or `false` if you want to force your own back button every where
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          )),
      body: FutureBuilder(
        future: getVersions(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Versions>> snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            final versions = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                  8.0, 8.0, 8.0, kFloatingActionButtonMargin + 48),
              itemCount: versions.length,
              itemBuilder: (BuildContext context, int index) {
                return VersionRow(widget.appId, versions[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addVersion(),
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<Versions>> getVersions() async {
    final repository = ref.read(repositoryProvider);
    final result = await repository.getVersions();
    return result.maybeWhen(
        success: (versions) => versions,
        failure: (error) {
          logMessage('Problems getting versions $error');
          return [];
        },
        errorMessage: (code, message) {
          logMessage('Problems getting versions $message');
          return [];
        },
        orElse: () {
          logMessage('Problems getting versions');
          return [];
        });
  }

  void addVersion() {
    var versionName = '';
    void save() async {
      final newVersion =
          Versions(versionName: versionName.trim(), appId: widget.appId);
      final repository = ref.read(repositoryProvider);
      await repository.addVersion(newVersion);
      if (!mounted) return;
      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Add Version'),
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
                        hintText: 'Enter a Version Name'),
                    onChanged: (text) => versionName = text,
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

class VersionRow extends ConsumerStatefulWidget {
  final int appId;
  final Versions version;

  const VersionRow(this.appId, this.version, {Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _VersionRowState();
}

class _VersionRowState extends ConsumerState<VersionRow> {
  final appTitleStyle =
      const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  final countStyle = const TextStyle(fontSize: 14.0);

  void goToVersionUploader() {
    context.go(context
        .namedLocation(versionUploaderRouteName, params: <String, String>{
      'appId': widget.appId.toString(),
      'versionId': widget.version.id!.toString(),
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0.0),
      child: Container(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => goToVersionUploader(),
            child: InkWell(
              highlightColor: Colors.green,
              splashColor: Colors.blue,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(widget.version.versionName,
                          style: appTitleStyle)),
                  const Spacer(),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.fromLTRB(2.0, 8.0, 0.0, 8.0),
                    alignment: Alignment.centerLeft,
                    onPressed: () {
                      renameVersion(widget.version);
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
                      await repository.deleteVersion(widget.version);
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
                      goToVersionUploader();
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

  void renameVersion(Versions version) {
    final versionNameController =
        TextEditingController(text: version.versionName);
    showDialog(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
            title: const Text('Rename Version'),
            content: Column(
              children: [
                TextField(
                  controller: versionNameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Update the Version Name'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    versionNameController.dispose();
                    Navigator.of(alertContext).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    final repository = ref.read(repositoryProvider);
                    await repository.updateVersion(version.copyWith(
                        versionName: versionNameController.text.trim()));
                    versionNameController.dispose();
                    if (!mounted) return;
                    Navigator.of(alertContext).pop();
                  },
                  child: const Text('Rename')),
            ]);
      },
    );
  }
}
