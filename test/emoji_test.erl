%%%-------------------------------------------------------------------
%%% @author mmooy
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 2月 2020 22:04
%%%-------------------------------------------------------------------
-module(emoji_test).
-author("mmooy").

-include_lib("eunit/include/eunit.hrl").

start_stop_test() ->
    {ok, Pid} = emoji:start(none, none),
    ?assert(is_pid(Pid)),
    ?assert(ok == emoji:stop(none, none)).

key_to_emoji1_test() ->
    emoji:start(none, none),
    ?assert({<<"1st_place_medal">>, <<"🥇"/utf8>>} == emoji:key_to_emoji(<<"1st_place_medal">>)),
    ?assert({<<"🥇"/utf8>>, <<"1st_place_medal">>} == emoji:emoji_to_key(<<"🥇"/utf8>>)).

key_to_emoji2_test() ->
    emoji:start(none, none),
    ?assert({error,not_find} == emoji:key_to_emoji(<<"not_find">>)),
    ?assert({error,not_find} == emoji:emoji_to_key(<<"not_find">>)).