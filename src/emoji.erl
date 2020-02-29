-module(emoji).
-author("mmooy").

-define(Emoji_to_key_dict, emoji_to_key_dictionary).
-define(key_To_Emoji_dict, key_to_emoji_dictionary).
%% API
-export([start/2, stop/2]).
-export([key_to_emoji/1, emoji_to_key/1]).

start(_, _) ->
    case ets:info(?Emoji_to_key_dict) of
        undefined ->
            ets:new(?Emoji_to_key_dict, [set, named_table]),
            ets:new(?key_To_Emoji_dict, [set, named_table]),
            emoji_unicodes:dict_init(?key_To_Emoji_dict, ?Emoji_to_key_dict);
        _ ->
            ignore
    end,
    {ok, self()}.

stop(_, _) ->
    ets:delete(?Emoji_to_key_dict),
    ets:delete(?key_To_Emoji_dict),
    ok.

-spec key_to_emoji(binary()) -> binary().
key_to_emoji(Key) ->
    case ets:lookup(?key_To_Emoji_dict, Key) of
        [{K, V}] ->
            {K, V};
        _ ->
            {error, not_find}
    end.

-spec emoji_to_key(binary()) -> binary().
emoji_to_key(Emoji) ->
    case ets:lookup(?Emoji_to_key_dict, Emoji) of
        [{K, V}] ->
            {K, V};
        _ ->
            {error, not_find}
    end.

