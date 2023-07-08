# yamlでの共通変数

`docker-compose.yaml`において、同じ値をべたで何回も書く必要が出てきた。  
これを変数化して使いまわしたい。

yamlにはアンカー/エイリアスと呼ばれる機能があり、それを使うことで変数のように扱える。  
ただし、注意点があり、`x-hoge`と`x-`で始まる命名規則を用いることで、Docker Composeから管理されなくなり便利である。

```yaml
version 3.8
x-hoge: &HOGE "hoge"
x-fuga: &FUGA "fuga"
services:
... ... ...
... ...
...
```

## 参考

- [docker-compose.ymlの中で値を使い回す方法](https://techracho.bpsinc.jp/hachi8833/2020_02_07/87447)
- [Define local variable in docker-compose.yml? - Stack Overflow](https://stackoverflow.com/questions/54078707/define-local-variable-in-docker-compose-yml)
