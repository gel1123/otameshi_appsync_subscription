import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'amplifyconfiguration.dart';


Future<void> subscribe() async {
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

  try {
    // Retrieve 5 events from the subscription
    var i = 0;
    await for (var event in operation) {
      i++;
      print('Subscription event data received: ${event.data}');
      if (i == 5) {
        break;
      }
    }
  } on Exception catch (e) {
    print('Error in subscription stream: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

// 上記でサブスクリプションするアプリを作る
class _MyAppState extends State<MyApp> {
  // Amplifyを初期化する
  void _configureAmplify() async {
    try {
      Amplify.addPlugins([AmplifyAPI()]);
      await Amplify.configure(amplifyconfig);
      print('Amplify configured');
    } catch (e) {
      print('Error occurred while configuring Amplify: $e');
    }
  }
  // initStateで上記をコールする
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Subscribe'),
            onPressed: () async {
              await subscribe();
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
