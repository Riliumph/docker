# 概要

## 歴史

マイケルがコッドの関係モデル論文を読んで実装したのがIngresと呼ばれるDB。  
Ingresに限界を感じ、最新の関係モデルを取り入れたPost-Ingresプロジェクト。  
これが、Postgresの始まり。

> - [Michael Stonebraker](https://ja.wikipedia.org/wiki/%E3%83%9E%E3%82%A4%E3%82%B1%E3%83%AB%E3%83%BB%E3%82%B9%E3%83%88%E3%83%BC%E3%83%B3%E3%83%96%E3%83%AC%E3%83%BC%E3%82%AB%E3%83%BC)…カリフォルニア大学バークレー校の助教授
> - [Edgar Frank "Ted" Codd](https://ja.wikipedia.org/wiki/%E3%82%A8%E3%83%89%E3%82%AC%E3%83%BC%E3%83%BBF%E3%83%BB%E3%82%B3%E3%83%83%E3%83%89)…IBMのアルマーデン研究員。[関係モデル](https://ja.wikipedia.org/wiki/%E9%96%A2%E4%BF%82%E3%83%A2%E3%83%87%E3%83%AB)を考案した

## 商用Postgres

|企業|製品名|特徴|
|:--|:--|:--|
|EnterpriseDB社|EDB Postgres|Oracleとの互換性の高さがウリ|
|富士通|Enterprise Postgres|透過的データ暗号化機能|
|Pivotal|Greenplum|マルチコアによる並列処理が得意|
|Amazon| Amazon RDS Aurora(PostgreSQL Compatible)|Postgres派生ではないが互換性を持つ|

AWSのAmazonRDSでは、互換性のあるAuroraでも本物のPostgresでもどちらでも採用できる。

## 拡張機能

### pg_stat_statements

QLのログ、tat、実行回数、平均実行時間などの性能確認を行うツール

### pg_hint_plan

通常、Postgresはと実行統計情報から自動的に実行計画を決めて実行する。  
このツールを使うことでユーザーが実行計画を決めることができる。  
これによりパフォーマンスをチューニングすることができる。

ただし、基本的にはデフォルトに任せるべきである。  
お前はPostgres開発者ほど賢くないという意識を持て。

### pg_stasinfo / pg_statsreporter

インスタンスの稼働状況を定期的に収集、蓄積するツール。  
性能劣化の兆候や問題発生時の原因特定に役立つ。

`reporter`の方はブラウザを使って可視化してくれる。

### pg_repack

データベースを無停止で再編することができる

### pg_rman

バックアップとレストアツール。

## 環境変数

まずは[ドキュメント](https://www.postgresql.jp/document/15/html/libpq-envars.html)を読め

Dockerで動かしていると混乱してくるが、docker-compose.yamlなどで書かれる以下の環境変数はコンテナに対する環境変数である。

- POSTGRES_USER  
  DBサーバーのpostgres管理者名のこと  
  postgresへ接続ユーザを指定するPGUSERとは意味が異なる。  
  まぁ、基本はPOSTGRES_USERで接続するんだけどさ。
- POSTGRES_PASSWORD  
  Linuxのpostgres管理者のログインパスワードのこと。  
  postgresへ接続する際のPGPASSWORDとは意味が異なる。  
  セキュリティ観点からユーザのパスワードと接続パスワードは分けるべきだけど、面倒なので一緒にするよね
- POSTGRES_AUTH_TRUST  
  ローカル（コンテナ内）からの接続にはパスワードは要求しませんオプション。  
  こんなのはpostgresの環境変数にないので、意味が違うのは一目瞭然。
