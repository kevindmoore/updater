import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supa_manager/supa_manager.dart';
import 'package:utilities/utilities.dart';

import 'theme/theme.dart';
import 'ui/menus.dart';

late Configuration configuration;
final configurationProvider = Provider<Configuration>((ref) {
  return configuration;
});

final configurationLoginStateProvider =
    Provider.family<LoginStateNotifier, Configuration>((ref, configuration) {
  return configuration.loginStateNotifier;
});

final logInStateProvider = ChangeNotifierProvider<LoginStateNotifier>((ref) {
  return LoginStateNotifier();
});

final searchTextStateProvider = StateProvider<String>((ref) {
  return '';
});

final supaBaseDatabaseProvider =
    Provider.family<SupaDatabaseManager, Configuration>((ref, configuration) {
  return configuration.supaDatabaseRepository;
});

LoginStateNotifier getLoginStateNotifier(Ref ref) {
  return ref.read(configurationProvider).loginStateNotifier;
}

SupaDatabaseManager getSupaDatabaseManager(Ref ref) {
  return ref.read(configurationProvider).supaDatabaseRepository;
}

SupaDatabaseManager getWidgetSupaDatabaseManager(WidgetRef ref) {
  return ref.read(configurationProvider).supaDatabaseRepository;
}

SupaAuthManager getSupaAuthManager(WidgetRef ref) {
  return ref.read(configurationProvider).supaAuthManager;
}

SupaAuthManager getProviderSupaAuthManager(ProviderRef ref) {
  return ref.read(configurationProvider).supaAuthManager;
}

SupaAuthManager getChangeProviderSupaAuthManager(
    ChangeNotifierProviderRef ref) {
  return ref.read(configurationProvider).supaAuthManager;
}

final themeProvider = StateNotifierProvider<ThemeManager, ThemeColors>((ref) {
  return ThemeManager(globalSharedPreferences);
});

final menuManagerProvider = Provider<MenuManager>((ref) {
  final manager = MenuManager(ref);
  return manager;
});
