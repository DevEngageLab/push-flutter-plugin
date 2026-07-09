import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

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
  String _eventName = 'Unknown';
  String _eventData = 'Unknown';

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
      String eventName = message["event_name"];
      String eventData = message["event_data"];
      FlutterPluginEngagelab.printMy(
          "flutter onMTCommonReceiver event_name: " + eventName);
      FlutterPluginEngagelab.printMy(
          "flutter onMTCommonReceiver event_data: " + eventData);
      setState(() {
        _eventName = eventName;
        _eventData = eventData;
        // debugLable = "flutter onMTCommonReceiver: $message";
        if (Comparable.compare(eventName, "onConnectStatus") == 0 ||
            Comparable.compare(eventName, "networkDidLogin") == 0) {
          FlutterPluginEngagelab.getRegistrationId().then((rid) {
            FlutterPluginEngagelab.printMy(
                "flutter get registration id : $rid");
            setState(() {
              _platformVersion = rid;
            });
            // // 设置用户语言
            // FlutterPluginEngagelab.setUserLanguage("zh-Hans-CN");
          });
        }
      });
    });
    FlutterPluginEngagelab.configDebugMode(true);

    // 设置设备更换时是否重置RegistrationID
    FlutterPluginEngagelab.setEnableResetOnDeviceChange(true);

    // // 设置是否启用UDP（请在初始化前调用）
    // FlutterPluginEngagelab.setEnableUdp(true);

    // // 设置语音播报功能（请在初始化前调用）
    // FlutterPluginEngagelab.setEnablePushTextToSpeech(true);

    // // 设置appGroupId（iOS only，请在初始化前调用）
    // if (Platform.isIOS) {
    //   FlutterPluginEngagelab.setAppGroupId("group.com.engagelab.push");
    // }

    if (Platform.isIOS) {
      FlutterPluginEngagelab.initIos(
        appKey: "8344af5668f374579426ce6d", // 5645a6e0c6ef00bb71facf21
        channel: "testChannel",
      );
      FlutterPluginEngagelab.checkNotificationAuthorizationIos();
    } else if (Platform.isAndroid) {
      FlutterPluginEngagelab.initAndroid();
    } else {
      FlutterPluginEngagelab.configDebugMode(true);
      FlutterPluginEngagelab.setAppKey("0cd10cb91d2ee8a7b0700789");
      FlutterPluginEngagelab.setChannel("testChannel");
      FlutterPluginEngagelab.initOhos();
    }

    String platformVersion = "";
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    FlutterPluginEngagelab.getRegistrationId().then((rid) {
      FlutterPluginEngagelab.printMy("flutter get registration id : $rid");
      setState(() {
        _platformVersion = rid;
      });
    });

    // iOS要是使用应用内消息，请在页面进入离开的时候配置pageEnterTo 和  pageLeave 函数，参数为页面名。
    FlutterPluginEngagelab.pageEnterTo(
        "HomePage"); // 在离开页面的时候请调用 FlutterPluginEngagelab.pageLeave("HomePage");

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
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                color: Colors.brown,
                child: Text('RID: $_platformVersion\n'
                    'EVENT NAME: $_eventName\n'
                    'EVENT DATA: $_eventData\n'),
                width: 350,
                height: 100,
              ),
              Row(children: <Widget>[
                const Text(" "),
                CustomButton(
                    title: "发送本地通知",
                    onPressed: () {
                      // 三秒后出发本地推送
                      var fireDate = DateTime.fromMillisecondsSinceEpoch(
                          DateTime.now().millisecondsSinceEpoch + 3000);
                      var localNotification = LocalNotification(
                          id: 234,
                          title: 'fadsfa',
                          content: 'fdas',
                          fireTime: fireDate,
                          subtitle: 'fasf',
                          category: 'local',
                          priority: 2,
                          badge: 5,
                          extra: {"fa": "0"});
                      FlutterPluginEngagelab.sendLocalNotification(
                              localNotification)
                          .then((res) {
                        // setState(() {
                        //   debugLable = res;
                        // });
                      });
                    }),
              ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(" "),
                    CustomButton(
                        title: "updateTags",
                        onPressed: () {
                          FlutterPluginEngagelab.updateTags({
                            "sequence": 1,
                            "tags": ["lala", "haha"]
                          });
                        }),
                    const Text(" "),
                    CustomButton(
                        title: "addTags",
                        onPressed: () {
                          FlutterPluginEngagelab.addTags({
                            "sequence": 2,
                            "tags": ["lala", "haha"]
                          });
                        }),
                    const Text(" "),
                    CustomButton(
                        title: "deleteTags",
                        onPressed: () {
                          FlutterPluginEngagelab.deleteTags({
                            "sequence": 3,
                            "tags": ["lala", "haha"]
                          });
                        }),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(" "),
                    CustomButton(
                        title: "getAllTags",
                        onPressed: () {
                          FlutterPluginEngagelab.queryAllTag(4);
                        }),
                    const Text(" "),
                    CustomButton(
                        title: "cleanTags",
                        onPressed: () {
                          FlutterPluginEngagelab.deleteAllTag(5);
                        }),
                    const Text(" "),
                    CustomButton(
                        title: "queryTag",
                        onPressed: () {
                          FlutterPluginEngagelab.queryTag(
                              {"sequence": 6, "tag": "lala"});
                        }),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(" "),
                    CustomButton(
                        title: "setAlias",
                        onPressed: () {
                          FlutterPluginEngagelab.setAlias(7, "thealias11");
                        }),
                    const Text(" "),
                    CustomButton(
                        title: "deleteAlias",
                        onPressed: () {
                          FlutterPluginEngagelab.clearAlias(8);
                        }),
                    const Text(" "),
                    CustomButton(
                        title: "getAlias",
                        onPressed: () {
                          FlutterPluginEngagelab.getAlias(9);
                        }),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}

/// 封装控件
class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? title;

  const CustomButton({Key? key, this.onPressed, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text("$title"),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        overlayColor: MaterialStateProperty.all(const Color(0xff888888)),
        backgroundColor: MaterialStateProperty.all(const Color(0xff585858)),
        padding:
            MaterialStateProperty.all(const EdgeInsets.fromLTRB(10, 5, 10, 5)),
      ),
    );
  }
}
