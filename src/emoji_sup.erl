-module(emoji_sup).
-author("yimo").

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

init([]) ->
    SupFlags = #{strategy => one_for_one,
        intensity => 1000,
        period => 3600},

    Encoder = #{id => 'emoji_encoder',
        start => {'emoji_ac', start_link, [emoji_encoder, emoji_unicodes:labels()]},
        restart => permanent,
        shutdown => 2000,
        type => worker,
        modules => [emoji_ac]},

    Decoder = #{id => 'emoji_decoder',
        start => {'emoji_ac', start_link, [emoji_decoder, emoji_unicodes:emojis()]},
        restart => permanent,
        shutdown => 2000,
        type => worker,
        modules => [emoji_ac]},

    {ok, {SupFlags, [Encoder, Decoder]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

