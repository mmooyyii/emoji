Emoji
=====

适用于 Erlang 的一个emoji字典,用于解决emoji在数据库等方面可能储存困难的问题。  
This project was inspired by [carpedm20](https://github.com/carpedm20/emoji)


Example
=====

```
    1> application:start(emoji).
    ok
    2> emoji:key_to_emoji(<<"1st_place_medal">>).
    {<<"1st_place_medal">>,<<240,159,165,135>>}
    3> emoji:key_to_emoji(<<"awfijoaf">>).
    {error,not_find}
    4> emoji:emoji_to_key(<<240,159,165,135>>).
    {<<240,159,165,135>>,<<"1st_place_medal">>}
```