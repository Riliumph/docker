# inner join

`inner join`なんて要らんかったんや！！！！！

## inner joinを使う

シンプルに`data-variant`を表現する。

```sql
SELECT
    *
FROM
    DATA AS d
    INNER JOIN variant AS v ON d.variant_id = v.variant_id;
```

## where句を使う

```sql
SELECT
    *
FROM
    DATA AS d,
    variant AS v
WHERE
    d.variant_id = v.variant_id;
```
