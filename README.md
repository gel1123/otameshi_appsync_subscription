# flutter_otameshi_appsync_subscription

## 動機
FlutterでAppSyncのサブスクリプション機能を試したい

## lib/amplifyconfiguration.dart

自分の環境に応じて下記のように設定する

```dart
const amplifyconfig = '''{
  "api": {
    "plugins": {
      "awsAPIPlugin": {
        "otameshi_appsync_subscription": {
          "endpointType": "GraphQL",
          "endpoint": "[AppSyncのエンドポイント]",
          "region": "[AppSyncのリージョン]",
          "authorizationType": "API_KEY",
          "apiKey": "[AppSyncのAPIキー]"
        }
      }
    }
  }
}''';
```

値入りの例を書くと、次のようになる（APIキーなど、それぞれの値はダミー）

```dart
const amplifyconfig = '''{
  "api": {
    "plugins": {
      "awsAPIPlugin": {
        "otameshi_appsync_subscription": {
          "endpointType": "GraphQL",
          "endpoint": "https://xxxxxxxxxxxx.appsync-api.ap-northeast-1.amazonaws.com/graphql",
          "region": "ap-northeast-1",
          "authorizationType": "API_KEY",
          "apiKey": "xxx-xxxxxxxxxx"
        }
      }
    }
  }
}''';
```
