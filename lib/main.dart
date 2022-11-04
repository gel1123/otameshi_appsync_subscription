import 'dart:async';

import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'amplifyconfiguration.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

// 上記でサブスクリプションするアプリを作る
class _MyAppState extends State<MyApp> {
  /// サブスクリプションの結果を受け取るためのStream
  StreamSubscription<GraphQLResponse<String>>? subscription = null;

  /// 受信したJSONを文字列のリストで管理するstate
  List<String> _receivedJsons = [];

  /// Amplifyの初期化を行うメソッド
  void _configureAmplify() async {
    try {
      Amplify.addPlugins([AmplifyAPI()]);
      await Amplify.configure(amplifyconfig);
      print('Amplify configured');
    } catch (e) {
      print('Error occurred while configuring Amplify: $e');
    }
  }

  void _startSubscribe() async {
    const graphQLDocument = '''subscription otameshi_subscription {
      onCreateOtameshi_subscription {
        id
        message
      }
    }''';
    final Stream<GraphQLResponse<String>> operation = Amplify.API.subscribe(
      GraphQLRequest<String>(document: graphQLDocument),
      onEstablished: () => print('Subscription established'),
    );
    setState(() {
      subscription = operation.listen((event) {
        print('Subscription event data received: ${event.data}');
        setState(() {
          // event.dataに現在日時のラベルを [YYYY-MM-DD hh:mm:ss] で追加する
          _receivedJsons.add(
              '[${DateTime.now().toLocal().toString().split('.')[0]}] ${event.data}');
        });
      }, onError: (e) {
        print('Error in subscription stream: $e');
      });
    });
  }

  void _stopSubscribe() {
    setState(() {
      subscription?.cancel();
      subscription = null;
      _receivedJsons = [];
    });
  }

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(
                  30,
                  60,
                  30,
                  30,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Scrollbar(
                  child: ListView.separated(
                    itemCount: _receivedJsons.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(20),
                        child: Text(_receivedJsons[index]),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        height: 1,
                        color: Colors.grey[500],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            width: double.infinity,
            height: 80,
            child: TextButton(
              onPressed: () {
                if (subscription == null) {
                  _startSubscribe();
                } else {
                  _stopSubscribe();
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  subscription == null ? Colors.green : Colors.red,
                ),
              ),
              child: Text(
                subscription == null ? 'サブスクリプションを開始する' : 'サブスクリプションを停止する',
                style: TextStyle(
                  color: subscription == null ? Colors.black : Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
