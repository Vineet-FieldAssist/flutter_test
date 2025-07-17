import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:time_change_detector/time_change_detector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Stream<bool>? _controller;
  String _message = '${DateTime.now()} - ${DateTime.now().timeZoneName}';

  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initWatcher();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && Platform.isAndroid) {
      _initWatcher();
    }
  }

  void _initWatcher() {
    _controller ??= TimeChangeDetector().listener(calendarDayChanged: false);
    print(_message);
    _subscription = _controller!.listen(
          (event) {
        setState(() => _message = 'change detected at: ${DateTime.now()}');
        print(_message);
      },
      onError: (error) => print('ERROR: $error'),
      onDone: () => print('Stream is done'),
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text('Time Change Detector')),
          body: SafeArea(child: Center(child: Text(_message)))));
}
