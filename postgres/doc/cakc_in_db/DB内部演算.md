# 演算方法

## SQL

```console
flexible_calc=# （省略）
 data_id | case 
---------+------
       1 | t
(1 row)
```

## 任意のコード実行は可能か？

たとえば、`bash`には文字列を演算するために`eval`コマンドが用意されている。  
これにより、文字列として生成したコマンドを実行することができたりする。

```bash
tool='sort -f';
printf "%s\n" "hoge" | eval "${tool}"
```

しかし、SQLはDBへのクエリと操作を行うための言語であり、セキュリティとデータの整合性を保つために、任意のコードの実行は制限されている。  
任意のコードを実行できるとは、まさにSQLインジェクション以上に簡単にDBをハックできるということだ。

すでに、存在しているクエリに情報を渡すということは可能である。  
しかし、そのクエリはSQLを呼び出すプログラミング言語側に実装される必要がある。

こんな感じ。

```python
import psycopg2

conn = psycopg2.connect(database="mydb", user="myuser", password="mypassword", host="localhost", port="5432")
cur = conn.cursor()

query = "SELECT column1, column2 FROM data WHERE column3 = %s;"
cur.execute(query, (value,))
result = cur.fetchall()

cur.close()
conn.close()
```

## 演算子文字列を演算器にするために

SQL側で任意のクエリを動的に作成することも、文字列をクエリとして解釈させて演算するということができないことは分かった。  

つまり、'a = b'という文字列を作っても`a = b`という演算として解釈することはできない。  
仮にできれば、`=`の部分すらも変数化すれば、任意の演算子をDBにストアしておくだけで、あらゆる演算ができた。  

できない以上、次のアイデアである。  
通常のプログラミング言語と同様に、すでに実装された演算内容を取得できた文字列によって分岐することで解決してみる。

```sql
select
    d.data_id,
    case
        when d.operator = '=' then d.left_operand = d.right_operand
        when d.operator = '<>' then d.left_operand <> d.right_operand
        when d.operator = '<' then d.left_operand < d.right_operand
        when d.operator = '<=' then d.left_operand <= d.right_operand
        when d.operator = '>' then d.left_operand > d.right_operand
        when d.operator = '>=' then d.left_operand >= d.right_operand
        else false
    end
from
    simple_data as d
```
