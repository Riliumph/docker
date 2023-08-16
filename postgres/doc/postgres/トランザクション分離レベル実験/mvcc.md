# MultiVersion Concurrency Control

## MVCCとは

過去の情報を並行管理するシステムのこと。  
RDBのisolation levelが`READ COMMITTED`や`REPEATABLE READ`の時のための機能。

「**テーブルの過去の情報を管理する**」仕組みで成り立っている。

## Isolation Level

DBにも色々あるみたいだが、基本的には以下の４レベル。  
詳細はそれぞれのページへ。

1. [READ UNCOMMITTED](./07-1_READ_UNCOMMITTED.md)
1. [READ COMMITTED](./07-2_READ_COMMITTED.md)
1. [REPEATABLE READ](./07-3_REPEATABL_READ.md)
1. [SERIALIZABLE](./07-4_SERIALIZABLE.md)

Lv2以上を実現する方法は

- `SELECT`処理で共有ロックを行う
- `INSERT`と`UPDATE`処理で占有ロックを行う。

ただし、ロックを行う都合上、パフォーマンスは必ず少なくとも低下する。  
このパフォーマンス低下をより低減し、

## 実装方法

すべてのテーブル、すべてのレコードにMySQLは自動的に以下のカラムをシステム管理カラムとして追加する。

- DB_ROW_ID: レコード行のID
- DB_TRX_ID: 最後にそのレコードを追加・更新したトランザクションID
- DB_ROLL_PTR: そのレコードの過去の値を持つ`undo log record`へのポインタ

1. トランザクションID=100のトランザクションでレコードを挿入する。
   - DB_TRX_IDに100が代入される。
   - DB_ROLL_PTRはNULLのまま
2. トランザクションID=102のトランザクションでレコード値を書き換える。
   - `undo log record`に過去の値が保存される
   - DB_ROLL_PTRに`undo log record`へのポインタが代入される
   - DB_TRX_IDに102が代入される。

## 参考

- [MySQLのMVCC](https://qiita.com/nkriskeeic/items/24b7714b749d38bba87b)
- [PostgreSQLのMVCC](https://www.postgresql.jp/document/15/html/explicit-locking.html)
