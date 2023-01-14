import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/cmd_run.dart';
import 'package:process_run/shell.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:updater/models/versions.dart';
import 'package:updater/providers.dart';
import 'package:utilities/utilities.dart';

import '../database/repository.dart';
import '../models/apps.dart';

const String appBucket = 'apps';

class VersionUploader extends ConsumerStatefulWidget {
  final int appId;
  final int versionId;

  const VersionUploader(this.appId, this.versionId, {Key? key})
      : super(key: key);

  @override
  ConsumerState<VersionUploader> createState() => _VersionUploaderState();
}

class _VersionUploaderState extends ConsumerState<VersionUploader> {
  Apps? app;
  Versions? version;

  Future readData() async {
    final repository = ref.read(repositoryProvider);
    final result = await repository.getApp(widget.appId);
    result.maybeWhen(success: (app) {
      this.app = app;
    }, failure: (error) {
      logMessage('Problems getting App $error');
    }, errorMessage: (code, message) {
      logMessage('Problems getting App $message');
    }, orElse: () {
      logMessage('Problems getting App');
    });
    final versionResult = await repository.getVersion(widget.versionId);
    versionResult.maybeWhen(success: (version) {
      this.version = version;
    }, failure: (error) {
      logMessage('Problems getting version $error');
    }, errorMessage: (code, message) {
      logMessage('Problems getting version $message');
    }, orElse: () {
      logMessage('Problems getting version');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(version?.versionName ?? ''),
          automaticallyImplyLeading: true,
          //`true` if you want Flutter to automatically add Back Button when needed,
          //or `false` if you want to force your own back button every where
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          )),
      body: FutureBuilder(
          future: getFiles(),
          builder:
              (BuildContext context, AsyncSnapshot<List<FileObject>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final files = snapshot.data;
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                    8.0, 8.0, 8.0, kFloatingActionButtonMargin + 48),
                itemCount: files!.length,
                itemBuilder: (BuildContext context, int index) {
                  return VersionRow(app!, version!, files[index]);
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              );
            } else {
              return Container();
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => chooseApp(),
        tooltip: 'Upload',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<FileObject>> getFiles() async {
    if (app == null || version == null) {
      await readData();
    }
    final result = await getWidgetSupaDatabaseManager(ref)
        .getBucketList(appBucket, '${app!.appName}/${version!.versionName}');
    return result.maybeWhen(
        success: (data) => data,
        failure: (error) {
          logMessage('Problems getting files $error');
          return [];
        },
        errorMessage: (code, message) {
          logMessage('Problems getting files $message');
          return [];
        },
        orElse: () => []);
  }

  void chooseApp() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null && result.files.isNotEmpty) {
      // Take first File
      final file = result.files[0];
      var fileName = file.name;
      var path = file.path;
      if (file.name.endsWith('.app')) {
        path = '$path/Contents/MacOS';
        final appName = await getPathContents(path);
        fileName = appName;
        path = '$path/$appName';
      }

      if (app != null && version != null) {
        final uploadResult = await getWidgetSupaDatabaseManager(ref).uploadFile(
            appBucket,
            '${app!.appName}/${version!.versionName}',
            fileName,
            File(path!));
        setState(() {
          uploadResult.maybeWhen(
              success: (bucketId) {
                final repository = ref.read(repositoryProvider);
                repository.updateVersion(version!.copyWith(bucketId: bucketId));
              },
              failure: (error) {
                logMessage('Problems uploading file $error');
                return [];
              },
              errorMessage: (code, message) {
                logMessage('Problems uploading file $message');
              },
              orElse: () => logMessage('Problems uploading file'));
        });
      }
    }
  }

  Future<String> getPathContents(String path) async {
    final cmd = ProcessCmd('ls', [path]);
    final result = await runCmd(cmd, verbose: true);
    var data = result.stdout.toString();
    if (data.endsWith('\n')) {
      data = data.substring(0, data.indexOf('\n'));
    }
    return data;
  }
}

class VersionRow extends ConsumerStatefulWidget {
  final Apps app;
  final Versions version;
  final FileObject file;

  const VersionRow(this.app, this.version, this.file, {Key? key})
      : super(key: key);

  @override
  ConsumerState createState() => _VersionRowState();
}

class _VersionRowState extends ConsumerState<VersionRow> {
  final appTitleStyle =
      const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  final countStyle = const TextStyle(fontSize: 14.0);

  void downloadApp() async {
    final outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: widget.file.name,
    );

    if (outputFile != null) {
      getWidgetSupaDatabaseManager(ref).downloadFile(
          appBucket,
          '${widget.app.appName}/${widget.version.versionName}',
          widget.file.name,
          File(outputFile));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0.0),
      child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: <Widget>[
              Expanded(child: Text(widget.file.name, style: appTitleStyle)),
              const Spacer(),
              IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.fromLTRB(2.0, 8.0, 0.0, 8.0),
                alignment: Alignment.centerLeft,
                onPressed: () async {
                  deleteFile();
                  setState(() {});
                },
                icon: const Icon(
                  Icons.delete_outlined,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.fromLTRB(2.0, 8.0, 0.0, 8.0),
                alignment: Alignment.centerLeft,
                onPressed: () {
                  downloadApp();
                },
                icon: const Icon(
                  Icons.download_outlined,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.fromLTRB(2.0, 8.0, 0.0, 8.0),
                alignment: Alignment.centerLeft,
                onPressed: () {
                  updateApp();
                },
                icon: const Icon(
                  Icons.install_desktop_outlined,
                  color: Colors.black,
                ),
              ),
            ],
          )),
    );
  }

  void deleteFile() async {
    final repository = ref.read(repositoryProvider);
    await repository.deleteVersion(widget.version);
    await getWidgetSupaDatabaseManager(ref).deleteFile(
        appBucket,
        '${widget.app.appName}/${widget.version.versionName}',
        widget.file.name);
  }

  void updateApp() async {
    if (widget.app.macAppPath != null && widget.app.macAppPath!.isNotEmpty) {
      try {
        final directory = await getApplicationSupportDirectory();
        await getWidgetSupaDatabaseManager(ref).downloadFile(
            appBucket,
            '${widget.app.appName}/${widget.version.versionName}',
            widget.file.name,
            File('${directory.path}/${widget.file.name}'));
        var cmd = ProcessCmd('cp', [
          '-f',
          '${directory.path}/${widget.file.name}',
          widget.app.macAppPath!
        ]);
        bool errorShown = false;
        var result = await runCmd(cmd, verbose: true);
        if (result.exitCode != 0) {
          // if (!context.mounted) return;
          showTextMessage(context, result.errText);
          errorShown = true;
        }
        cmd = ProcessCmd('chmod', [
          '755',
          '${widget.app.macAppPath!}/${widget.file.name}'
        ]);
        result = await runCmd(cmd, verbose: true);
        if (result.exitCode != 0) {
          // if (!context.mounted) return;
          showTextMessage(context, result.errText);
          errorShown = true;
        }
        if (!errorShown) {
          showTextMessage(context, '${widget.app.appName} has been updated');
        }
        // await shell.run(shellArguments(arguments));
      } on ShellException catch (exception) {
        logError(exception);
        // We might get a shell exception
      }
    }
  }
}
