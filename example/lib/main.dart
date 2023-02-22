import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_plugin_engagelab/flutter_plugin_engagelab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _event_name = 'Unknown';
  String _event_data = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    FlutterPluginEngagelab.addEventHandler(
        onMTCommonReceiver: (Map<String, dynamic> message) async {
      FlutterPluginEngagelab.printMy("flutter onMTCommonReceiver: $message");
      String event_name = message["event_name"];
      String event_data = message["event_data"];
      FlutterPluginEngagelab.printMy("flutter onMTCommonReceiver event_name: " + event_name);
      FlutterPluginEngagelab.printMy("flutter onMTCommonReceiver event_data: " + event_data);
      setState(() {
        _event_name = "$event_name";
        _event_data = "$event_data";
        // debugLable = "flutter onMTCommonReceiver: $message";
        if (Comparable.compare(event_name, "onConnectStatus") == 0 ||
            Comparable.compare(event_name, "networkDidLogin") == 0) {
            FlutterPluginEngagelab.getRegistrationId().then((rid) {
              FlutterPluginEngagelab.printMy("flutter get registration id : $rid");
              setState(() {
                _platformVersion = "$rid";
              });
            });
        }
      });
    });
    FlutterPluginEngagelab.configDebugMode(true);
    if (Platform.isIOS) {
      FlutterPluginEngagelab.initIos(
        appKey: "你的appkey",
        channel: "testChannel",
      );
    } else if (Platform.isAndroid) {
      FlutterPluginEngagelab.initAndroid();
    }

    String platformVersion = "";
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    FlutterPluginEngagelab.getRegistrationId().then((rid) {
      FlutterPluginEngagelab.printMy("flutter get registration id : $rid");
      setState(() {
        _platformVersion = "$rid";
      });
    });
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('RID: $_platformVersion\n'
              'EVENT NAME: $_event_name\n'
              'EVENT DATA: $_event_data\n'),
        ),
      ),
    );
  }
}
