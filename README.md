# flutter_otameshi_appsync_subscription

## 動機
FlutterでAppSyncのサブスクリプション機能を試したい

## 必要なもの

- このリポジトリのソースコード
- 自分のAWSアカウント
- AWS AppSync のリソース（otameshi_appsync_subscriptionという名前で筆者は作りました）
- AWS AppSyncのデータソースとして使うDynamoDB
- **AWS AppSyncのエンドポイントやAPIキーなどの設定値を記述した `lib/amplifyconfiguration.dart` （あえてGit管理対象外にしているので、このリポジトリをクローンして試してみるときは、自分の環境に合わせた `lib/amplifyconfiguration.dart` を作成してください。一応、このREADME.mdの最後に `lib/amplifyconfiguration.dart` のサンプルを置いています）**

## AppSyncのスキーマ

ウィザードから作成したAppSyncの雛形をそのまま使っているので、下記のようなスキーマになっている。（特にIaCの類は使っていないので、AWSマネジメントコンソールから以下コピペ）

```schema
input CreateOtameshi_subscriptionInput {
	message: String!
}

input DeleteOtameshi_subscriptionInput {
	id: ID!
}

type Mutation {
	createOtameshi_subscription(input: CreateOtameshi_subscriptionInput!): otameshi_subscription
	updateOtameshi_subscription(input: UpdateOtameshi_subscriptionInput!): otameshi_subscription
	deleteOtameshi_subscription(input: DeleteOtameshi_subscriptionInput!): otameshi_subscription
}

type Query {
	getOtameshi_subscription(id: ID!): otameshi_subscription
	listOtameshi_subscriptions(filter: TableOtameshi_subscriptionFilterInput, limit: Int, nextToken: String): otameshi_subscriptionConnection
}

type Subscription {
	onCreateOtameshi_subscription(id: ID, message: String): otameshi_subscription
		@aws_subscribe(mutations: ["createOtameshi_subscription"])
	onUpdateOtameshi_subscription(id: ID, message: String): otameshi_subscription
		@aws_subscribe(mutations: ["updateOtameshi_subscription"])
	onDeleteOtameshi_subscription(id: ID, message: String): otameshi_subscription
		@aws_subscribe(mutations: ["deleteOtameshi_subscription"])
}

input TableBooleanFilterInput {
	ne: Boolean
	eq: Boolean
}

input TableFloatFilterInput {
	ne: Float
	eq: Float
	le: Float
	lt: Float
	ge: Float
	gt: Float
	contains: Float
	notContains: Float
	between: [Float]
}

input TableIDFilterInput {
	ne: ID
	eq: ID
	le: ID
	lt: ID
	ge: ID
	gt: ID
	contains: ID
	notContains: ID
	between: [ID]
	beginsWith: ID
}

input TableIntFilterInput {
	ne: Int
	eq: Int
	le: Int
	lt: Int
	ge: Int
	gt: Int
	contains: Int
	notContains: Int
	between: [Int]
}

input TableOtameshi_subscriptionFilterInput {
	id: TableIDFilterInput
	message: TableStringFilterInput
}

input TableStringFilterInput {
	ne: String
	eq: String
	le: String
	lt: String
	ge: String
	gt: String
	contains: String
	notContains: String
	between: [String]
	beginsWith: String
}

input UpdateOtameshi_subscriptionInput {
	id: ID!
	message: String
}

type otameshi_subscription {
	id: ID!
	message: String!
}

type otameshi_subscriptionConnection {
	items: [otameshi_subscription]
	nextToken: String
}
```

## DynamoDBのテーブル構造

- パーティションキー：id（String）
- ソートきー：なし
- その他のカラム：message（String）

## lib/amplifyconfiguration.dart

APIキーを直書きしているので、あえてGit管理対象外にしている。

このリポジトリをクローンして、AppSyncのサブスクリプション機能を試してみたければ、 `lib/amplifyconfiguration.dart` を作成して、自分の環境に応じて下記のように設定する。

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

上記を値入りの例を書くと、次のようになる（APIキーなど、それぞれの値はダミー）

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
