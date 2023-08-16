# inner join

`inner join`なんて要らんかったんや！！！！！

## inner joinを使う

シンプルに`data-variant`を表現する。

```sql
select * from data as d inner join variant as v on d.variant_id = v.variant_id;
```

## where句を使う

```sql
select * from data as d, variant as v where d.variant_id = v.variant_id;
```
