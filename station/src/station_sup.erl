% @doc station top level supervisor.
% @end
-module(station_sup).

-behavior(supervisor).

% API
-export([start_link/2]).

% Callbacks
-export([init/1]).

%--- API -----------------------------------------------------------------------

start_link(Name, MFA) ->
    supervisor:start_link(?MODULE, {Name, MFA}).

%--- Callbacks -----------------------------------------------------------------

init({Name, MFA}) ->
  SupFlags = #{strategy => one_for_all,
               intensity => 1,
               period => 5},
  ChildSpecs = [#{id => station_serv,
                  start => {station_serv, start_link, [Name, self(), MFA]},
                  restart => permanent,
                  type => worker,
                  shutdown => 5000,
                  modules => [station_serv]}],
  ok = supervisor:check_childspecs(ChildSpecs),
  {ok, {SupFlags, ChildSpecs}}.
