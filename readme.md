Emoji
=====

* 适用于 Erlang 的一个emoji字典,用于解决emoji在数据库等方面可能储存困难的问题。
* 使用Aho-Chorasick实现O(n)级的字符串处理
* This project was inspired by [carpedm20](https://github.com/carpedm20/emoji)

Example
=====

```
(emoji@127.0.0.1)1> emoji:print(emoji:demojize(<<"希望🐶没事🙏"/utf8>>)).
希望{dog}没事{pray}
ok
(emoji@127.0.0.1)1> emoji:print(emoji:emojize(<<"希望{dog}没事{pray}"/utf8>>)).
希望🐶没事🙏
ok
```
