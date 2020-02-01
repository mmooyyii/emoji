-module(emoji).
-author("mmooy").

-define(Emoji_dict, emoji_dictionary).

%% API
-export([start/2, stop/2]).
-export([key_to_emoji/1, emoji_to_key/1]).

start(_, _) ->
    case ets:info(?Emoji_dict) of
        undefined ->
            ets:new(?Emoji_dict, [set, named_table]),
            emoji_unicodes:dict_init(?Emoji_dict);
        _ ->
            ignore
    end,
    {ok, self()}.

stop(_, _) ->
    ets:delete(?Emoji_dict),
    ok.

-spec key_to_emoji(binary()) -> binary().
key_to_emoji(Key) ->
    case ets:lookup(?Emoji_dict, Key) of
        [{K, V}] ->
            {K, V};
        _ ->
            {error, not_find}
    end.

-spec emoji_to_key(binary()) -> binary().
emoji_to_key(Emoji) ->
    case ets:lookup(?Emoji_dict, Emoji) of
        [{K, V}] ->
            {K, V};
        _ ->
            {error, not_find}
    end.

