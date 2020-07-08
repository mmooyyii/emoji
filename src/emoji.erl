-module(emoji).
-author("mmooy").

-define(Emoji_to_key_dict, emoji_to_key_dictionary).
-define(key_To_Emoji_dict, key_to_emoji_dictionary).
%% API
-export([start/2, stop/2]).
-export([label_to_emoji/1, emoji_to_label/1]).
-export([emojize/1, demojize/1]).
-export([print/1]).

start(_, _) ->
    case ets:info(?Emoji_to_key_dict) of
        undefined ->
            ets:new(?Emoji_to_key_dict, [set, named_table]),
            ets:new(?key_To_Emoji_dict, [set, named_table]),
            emoji_unicodes:dict_init(?key_To_Emoji_dict, ?Emoji_to_key_dict);
        _ ->
            ignore
    end,
    init_aho_corasick(),
    {ok, self()}.

stop(_, _) ->
    ets:delete(?Emoji_to_key_dict),
    ets:delete(?key_To_Emoji_dict),
    gen_server:stop(encoder),
    gen_server:stop(decoder),
    ok.

label_to_emoji(Key) ->
    case ets:lookup(?key_To_Emoji_dict, to_string(Key)) of
        [{_, V}] -> V;
        _ -> {error, not_find}
    end.

emoji_to_label(Emoji) ->
    case ets:lookup(?Emoji_to_key_dict, to_string(Emoji)) of
        [{_, V}] -> V;
        _ -> {error, not_find}
    end.

init_aho_corasick() ->
    emoji_ac:start_link(encoder, emoji_unicodes:labels()),
    emoji_ac:start_link(decoder, emoji_unicodes:emojis()).

%% label to emoji
emojize(Word) ->
    emoji_ac:encode(to_string(Word)).

%% emoji to label
demojize(Word) ->
    emoji_ac:decode(to_string(Word)).

print(Binary) when is_binary(Binary) ->
    io:format("~ts", [Binary]);
print(String) when is_list(String) ->
    io:format("~ts", [list_to_binary(String)]).


to_string(B) when is_binary(B) ->
    binary_to_list(B);
to_string(B) when is_list(B) ->
    B.