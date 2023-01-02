import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supa_manager/supa_manager.dart';
import 'package:utilities/utilities.dart';

import '../models/apps.dart';
import '../models/versions.dart';
import '../providers.dart';

final repositoryProvider = Provider<Repository>((ref) {
  return Repository(ref);
});

final appNotifierProvider =
    StateNotifierProvider<ListNotifier<Apps>, List<Apps>>((ref) {
  return ListNotifier(
      getSupaDatabaseManager(ref), AppTableData(), (app) => AppTableEntry(app));
});
final versionNotifierProvider =
    StateNotifierProvider<ListNotifier<Versions>, List<Versions>>((ref) {
  return ListNotifier(getSupaDatabaseManager(ref), VersionsTableData(),
      (version) => VersionsTableEntry(version));
});

class Repository {
  final ProviderRef ref;
  late SupaDatabaseManager databaseRepository;
  TableData<Apps> appTableData = AppTableData();
  TableData<Versions> versionTableData = VersionsTableData();

  Repository(this.ref) {
    databaseRepository = ref.read(configurationProvider).supaDatabaseRepository;
  }

  Future<Result<Apps?>> addApp(Apps show) async {
    return databaseRepository.addEntry(appTableData, AppTableEntry(show));
  }

  Future<Result<Apps?>> updateApp(Apps show) {
    return databaseRepository.updateTableEntry(
        appTableData, AppTableEntry(show));
  }

  Future<Result<Apps?>> deleteApp(Apps show) {
    return Future.value(
        databaseRepository.deleteTableEntry(appTableData, AppTableEntry(show)));
  }

  Future<Result<List<Apps>>> getApps() {
    return databaseRepository.readEntries(appTableData);
  }

  Future<Result<Apps?>> getApp(int id) async {
    return databaseRepository.readEntry(appTableData, id);
  }

  Future<Result<Versions?>> addVersion(Versions version) {
    return databaseRepository.addEntry(
        versionTableData, VersionsTableEntry(version));
  }

  Future<Result<Versions?>> updateVersion(Versions version) {
    return databaseRepository.updateTableEntry(
        versionTableData, VersionsTableEntry(version));
  }

  Future<Result<Versions?>> deleteVersion(Versions version) {
    return databaseRepository.deleteTableEntry(
        versionTableData, VersionsTableEntry(version));
  }

  Future<Result<List<Versions>>> getVersions() {
    return databaseRepository.readEntries(versionTableData);
  }
  Future<Result<Versions?>> getVersion(int id) async {
    return databaseRepository.readEntry(versionTableData, id);
  }

}

/// Table Entry classes
const appTableName = 'UpdaterApps';
const versionsTableName = 'UpdaterVersion';
const appIdName = 'appId';

class AppTableData extends TableData<Apps> {
  AppTableData() {
    tableName = appTableName;
    hasUserId = false;
  }

  @override
  Apps fromJson(Map<String, dynamic> json) {
    return Apps.fromJson(json);
  }
}

class AppTableEntry with TableEntry<Apps> {
  final Apps app;

  AppTableEntry(this.app);

  @override
  AppTableEntry addUserId(String userId) {
    return AppTableEntry(app);
  }

  @override
  Map<String, dynamic> toJson() {
    return app.toJson();
  }

  @override
  int? get id => app.id;

  @override
  set id(int? id) {}
}

class VersionsTableData extends TableData<Versions> {
  VersionsTableData() {
    tableName = versionsTableName;
    hasUserId = false;
  }

  @override
  Versions fromJson(Map<String, dynamic> json) {
    return Versions.fromJson(json);
  }
}

class VersionsTableEntry with TableEntry<Versions> {
  final Versions version;

  VersionsTableEntry(this.version);

  @override
  VersionsTableEntry addUserId(String userId) {
    return VersionsTableEntry(version);
  }

  @override
  Map<String, dynamic> toJson() {
    return version.toJson();
  }

  @override
  int? get id => version.id;

  @override
  set id(int? id) {}
}
