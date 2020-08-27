-module(emoji_sup).
-author("yimo").

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
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
        start => {'emoji_ac', start_link, [encoder, emoji_unicodes:labels()]},
        restart => permanent,
        shutdown => 2000,
        type => worker,
        modules => [emoji_ac]},

    Decoder = #{id => 'emoji_encoder',
        start => {'emoji_ac', start_link, [encoder, emoji_unicodes:labels()]},
        restart => permanent,
        shutdown => 2000,
        type => worker,
        modules => [emoji_ac]},

    {ok, {SupFlags, [Encoder, Decoder]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
