import 'dart:async';
import 'dart:developer';

import 'package:chopper_sample/app_snackbar.dart';
import 'package:chopper_sample/data/post_api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'home_page.dart';

void main() {
  _setupLogging();
  runApp(const MyApp());
}

void _setupLogging() {
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((event) {
    if (kDebugMode) {
      print('${event.level.name} : ${event.time} : ${event.message}');
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isOffline = true;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      isOffline = result != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    final snackBar = showSnackbar(context);
    final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

    if (!isOffline) {
      final delay = scaffoldMessengerKey.currentState == null ? 1 : 0;
      Timer(Duration(seconds: delay), () {
        scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      });
    }

    return Provider(
      create: (_) => PostApiService.create(),
      dispose: (context, PostApiService service) => service.client.dispose(),
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        home: const HomePage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity();
      _connectivitySubscription =
          _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }
}
