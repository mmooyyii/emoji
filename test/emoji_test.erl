%%%-------------------------------------------------------------------
%%% @author mmooy
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 2月 2020 22:04
%%%-------------------------------------------------------------------
-module(emoji_test).
-author("mmooyyii").

-include_lib("eunit/include/eunit.hrl").

start_stop_test() ->
    ok = application:start(emoji),
    ok = application:stop(emoji).

key_to_emoji1_test() ->
    application:start(emoji),
    ?assert(binary_to_list(<<"🥇"/utf8>>) =:= emoji:label_to_emoji("1st_place_medal")),
    ?assert("smiling_face_with_smiling_eyes" =:= emoji:emoji_to_label(<<"😊"/utf8>>)).

key_to_emoji2_test() ->
    application:start(emoji),
    ?assert({error, not_find} == emoji:label_to_emoji(<<"not_find">>)),
    ?assert({error, not_find} == emoji:emoji_to_label(<<"not_find">>)).

encode_decode_test() ->
    application:start(emoji),
    ?assert(binary_to_list(<<"🦈🐎"/utf8>>) == emoji:emojize(emoji:demojize(<<"🦈🐎"/utf8>>))),
    ?assert(binary_to_list(<<"希望🐶没事🙏。"/utf8>>) == emoji:emojize(emoji:demojize(<<"希望🐶没事🙏。"/utf8>>))),
    ?assert(binary_to_list(<<"abc"/utf8>>) == emoji:emojize(emoji:demojize(<<"abc"/utf8>>))).

to_string_test() ->
    ?assert(binary_to_list(<<"😊"/utf8>>) =:= [240, 159, 152, 138]).