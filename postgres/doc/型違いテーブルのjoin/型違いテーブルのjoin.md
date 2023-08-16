# 型違いテーブルのjoin

まず、`variant`テーブルを完成させよう。  
型違いのカラムを作れるのか試したい。

```sql
-- 型名を追加したCTEを作成
with  replace_type_name_tbl as (
    select v.variant_id, v.type_id, t.type_name, v.value_id from variant as v, types as t where v.type_id = t.type_id
),
-- int型を持つレコードにint_valueテーブルから値をjoin
joined_int as (
select * from replace_type_name_tbl as rtn_tbl, int_values as iv where rtn_tbl.value_id = iv.value_id and rtn_tbl.type_id = 1
),
-- time_stamp型を持つレコードにtime_valueテーブルから値をjoin
joined_ts as (
select * from replace_type_name_tbl as rtn_tbl, time_values as iv where rtn_tbl.value_id = iv.value_id and rtn_tbl.type_id = 2
)
-- int型をjoinしたテーブルとtimestamp型をjoinしたテーブルをunion all
select * from joined_int union all select * from joined_ts;
```

結果

```console
variant_data_db-# select * from joined_int union all select * from joined_ts;
ERROR:  UNION types integer and timestamp without time zone cannot be matched
LINE 9: select * from joined_int union all select * from joined_ts;
                                                  ^
```

「型が一致しねーからUNIONできねよーんｗｗｗｗ」

やっぱできねぇんじゃん！！！！！！！！！！！！！！！！！！！！！！！！！！！！
