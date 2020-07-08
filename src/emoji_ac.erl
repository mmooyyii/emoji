-module(emoji_ac).
-author("yimo").

-behaviour(gen_server).

%% API
-export([start_link/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
    code_change/3]).

-export([encode/1, decode/1, replace/2]).
-define(SERVER, ?MODULE).

-record(emoji_ac_state, {aho_corasick, self}).

%%%===================================================================
%%% API
%%%===================================================================

start_link(Name, Words) ->
    gen_server:start_link({local, Name}, ?MODULE, [Name, aho_corasick:build_tree(Words)], []).

init([Name, Aho]) ->
    {ok, #emoji_ac_state{aho_corasick = Aho, self = Name}}.

handle_call({decode, String}, _From, State = #emoji_ac_state{aho_corasick = Aho, self = decoder}) ->
    {reply, aho_corasick:match(String, Aho), State};

handle_call({encode, String}, _From, State = #emoji_ac_state{aho_corasick = Aho, self = encoder}) ->
    {reply, aho_corasick:match(String, Aho), State}.

handle_cast(_Request, State = #emoji_ac_state{}) ->
    {noreply, State}.

handle_info(_Info, State = #emoji_ac_state{}) ->
    {noreply, State}.

terminate(_Reason, _State = #emoji_ac_state{}) ->
    ok.

code_change(_OldVsn, State = #emoji_ac_state{}, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

encode(String) ->
    Labels = lists:sort(gen_server:call(encoder, {encode, String})),
    L = lists:map(fun({A, B, C}) ->
        E = emoji:label_to_emoji(lists:sublist(C, 2, length(C) - 2)),
        {A, B, E} end, Labels),
    replace(String, L).

decode(String) ->
    Emojis = lists:sort(gen_server:call(decoder, {decode, String})),
    E = lists:map(fun({A, B, C}) ->
        L = emoji:emoji_to_label(C),
        {A, B, "{" ++ L ++ "}"} end, Emojis),
    replace(String, E).

replace(String, [FirstWord | RestWord]) ->
    F = fun
            (Char, {StringIndex, null, [], Acc}) ->
                {StringIndex + 1, null, [], [Char | Acc]};
            (_Char, {StringIndex, {Start, End, Word}, Words, Acc}) when StringIndex =:= Start andalso StringIndex < End ->
                {StringIndex + 1, {Start, End, Word}, Words, p_concat(Word, Acc)};
            (_Char, {StringIndex, {Start, End, Word}, Words, Acc}) when StringIndex > Start andalso StringIndex < End ->
                {StringIndex + 1, {Start, End, Word}, Words, Acc};
            (_Char, {StringIndex, {_Start, End, _}, Words, Acc}) when StringIndex == End ->
                {Word, NewWords} = get_word(End, Words),
                {StringIndex + 1, Word, NewWords, Acc};
            (Char, {StringIndex, {Start, End, Word}, Words, Acc}) when StringIndex < Start ->
                {StringIndex + 1, {Start, End, Word}, Words, [Char | Acc]}
        end,
    {_, _, _, Return} = lists:foldl(F, {1, FirstWord, RestWord, []}, String),
    lists:reverse(Return);
replace(String, []) ->
    String.

get_word(PreEnd, [{Start, _, _} | R]) when Start =< PreEnd ->
    get_word(PreEnd, R);
get_word(_PreEnd, [{Start, End, Word} | R]) ->
    {{Start, End, Word}, R};
get_word(_, []) -> {null, []}.


p_concat([L1 | R], L2) ->
    p_concat(R, [L1 | L2]);
p_concat([], L2) -> L2.

