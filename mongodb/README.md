# mongodb

## 環境の操作

```console
$ docker compose up -d
```

## mongodb使い方

### 接続方法

```console
$ docker compose exec -it mongo mongosh "mongodb://mongo:mongo@localhost:27017/?authSource=admin"
(DB NAME)>
```

### クエリの実行

mongodbshはそのコンソールにJavaScriptを流すことが出来る。

```console
(DB NAME)> db.products.insertOne({_id: 1, name: "alice", stock: 1})
{ acknowledged: true, insertedId: 1 }
```

## TOCTOU問題

前提
とりあえず、DBを変更しておく

```console
test> use toctou_test
```

状態の確認

```console
tectou_test> db.products.find()
[ { _id: 1, name: 'alice', stock: 1 } ]
```

コンソールAで実行する。

```console
tectou_test> db.products.findOne({name: "alice"})
```

コンソールBで実行する。

```console
tectou_test> db.products.updateOne(
{ name: "alice" },
{ $inc: { stock: -1 } }
)
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 1,
  upsertedCount: 0
}

tectou_test> db.products.findOne({ name: "alice" })
{ _id: 1, name: 'alice', stock: 0 }
```

コンソールAが`stock=1`を確認している間にコンソールBが`stock=0`に変更しちゃった。  
コンソールAは`stock=1`を信用して計算してしまう。

```console
tectou_test> db.products.updateOne(
  { name: "alice" },
  { $inc: { stock: -1 } }
)
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 1,
  upsertedCount: 0
}
```

結果……

```console
tectou_test> db.products.findOne({ name: "alice" })
{ _id: 1, name: 'alice', stock: -1 }
```

ああ～、stockが0を超えてマイナスに……
