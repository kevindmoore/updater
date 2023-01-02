import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supa_manager/supa_manager.dart';
import 'package:updater/ui/app_list.dart';
import 'package:updater/ui/version_list.dart';
import 'package:updater/ui/version_uploader.dart';
import 'package:utilities/utilities.dart';

import '../providers.dart';
import '../ui/login.dart';
import 'error_page.dart';
import 'route_names.dart';

final routeProvider = Provider<MyRouter>((ref) {
  return MyRouter(ref, getLoginStateNotifier(ref));
});

final navigatorKey = GlobalKey<NavigatorState>();

class MyRouter {
  final ProviderRef ref;
  final LoginStateNotifier loginState;

  MyRouter(this.ref, this.loginState);

  late final router = GoRouter(
    navigatorKey: navigatorKey,
    refreshListenable: loginState,
    debugLogDiagnostics: true,
    initialLocation: loginRouteName.path(),
    routes: [
      GoRoute(
        name: rootRouteName,
        path: '/',
        pageBuilder: (context, state) {
          return MaterialPage<void>(key: state.pageKey, child: const AppList());
        },
        routes: [
          GoRoute(
            name: versionRouteName,
            path: 'version/:appId',
            pageBuilder: (context, state) {
              return MaterialPage<void>(
                  key: state.pageKey,
                  child: VersionList(int.parse(state.params['appId']!)));
            },
            routes: [
              GoRoute(
                name: versionUploaderRouteName,
                path: 'uploader/:versionId',
                pageBuilder: (context, state) {
                  return MaterialPage<void>(
                      key: state.pageKey,
                      child: VersionUploader(int.parse(state.params['appId']!),
                          int.parse(state.params['versionId']!)));
                },
              )
            ],
          )
        ],
      ),
      GoRoute(
        name: loginRouteName,
        path: '/login',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const LoginDialog(),
        ),
      ),
      // GoRoute(
      //   name: homeRouteName,
      //   path: '/home',
      //   pageBuilder: (context, state) {
      //     return MaterialPage<void>(
      //         key: state.pageKey, child: const MainEntry());
      //   },
      // ),
      // GoRoute(
      //   name: notesRouteName,
      //   path: '/notes',
      //   pageBuilder: (context, state) {
      //     return MaterialPage<void>(
      //         key: state.pageKey, child: const MainPhoneEditor());
      //   },
      // ),
    ],

    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: ErrorPage(error: state.error),
    ),

    // redirect to the login page if the user is not logged in
    redirect: (context, state) {
      final loginLoc = loginRouteName.path();
      final loggingIn = state.subloc == loginLoc;
      final loggedIn = loginState.isLoggedIn();

      if (!loggedIn && !loggingIn) return loginLoc;
      if (loggedIn && (loggingIn)) return '/';
      return null;
    },
  );
}
