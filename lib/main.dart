import 'package:colorize_lumberdash/colorize_lumberdash.dart';
import 'package:desktop_lifecycle/desktop_lifecycle.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supa_manager/supa_manager.dart';
import 'package:utilities/utilities.dart';

import 'providers.dart';
import 'router/routes.dart';
final ValueListenable<bool> event = DesktopLifecycle.instance.isActive;

final bool active = event.value;
const int checkActiveSeconds = 60 * 5; // 5 minutes

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  putLumberdashToWork(withClients: [
    ColorizeLumberdash(),
  ]);
  if (isDesktop()) {
    await DesktopWindow.setWindowSize(const Size(700, 600));

    await DesktopWindow.setMinWindowSize(const Size(700, 600));
    await DesktopWindow.setMaxWindowSize(Size.infinite);
  }

  globalSharedPreferences = await SharedPreferences.getInstance();
  final secrets = await SecretLoader(secretPath: 'assets/secrets.json').load();
  configuration = Configuration();
  await configuration.initialize(
      secrets.url, secrets.apiKey, secrets.apiSecret);

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> with WidgetsBindingObserver {
  var initialized = false;
  Stopwatch? stopWatch;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        stopStopwatch();
        final seconds = stopWatch?.elapsed.inSeconds ?? 0;
        if (seconds > checkActiveSeconds) {
          final auth = getSupaAuthManager(ref);
          auth.refreshSession();
        }
        break;
      case AppLifecycleState.inactive:
      // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        startStopwatch();
        break;
      case AppLifecycleState.detached:
      // TODO: Handle this case.
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    // Mobile
    if (isMobile()) {
      WidgetsBinding.instance.addObserver(this);
    } else if (isDesktop()) {
      // Desktop
      event.addListener(() {
        if (event.value) {
          stopStopwatch();
          final seconds = stopWatch?.elapsed.inSeconds ?? 0;
          if (seconds > checkActiveSeconds) {
            final auth = getSupaAuthManager(ref);
            auth.refreshSession();
          }
        } else {
          startStopwatch();
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialized) {
        return;
      }
      final auth = getSupaAuthManager(ref);
      auth.loadUser();
      initialized = true;
    });
    final router = ref.watch(routeProvider).router;
    final menuManager = ref.read(menuManagerProvider);
    return PlatformMenuBar(
        menus: menuManager.createMenus(),
        child: MaterialApp.router(
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
          debugShowCheckedModeBanner: false,
          title: 'Note Master',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              scrollbarTheme: ScrollbarThemeData(
                thumbVisibility: MaterialStateProperty.all<bool>(true),
              )),
        ),
    );
  }

  void startStopwatch() {
    stopWatch = Stopwatch()..start();
  }

  void stopStopwatch() {
    stopWatch?.stop();
  }
}
