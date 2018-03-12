% @doc robot public API.
% @end
-module(robot).

-behavior(application).

% Callbacks
-export([start/2]).
-export([stop/1]).

%--- Callbacks -----------------------------------------------------------------

start(_Type, _Args) ->
    {ok, Supervisor} = robot_sup:start_link(),
    LEDs = [1, 2],
    [grisp_led:flash(L, red, 500) || L <- LEDs],
    timer:sleep(5000),
    grisp_led:off(2),
    Random = fun() ->
        {rand:uniform(2) - 1, rand:uniform(2) -1, rand:uniform(2) - 1}
    end,
    grisp_led:pattern(1, [{100, Random}]),
    application:load(partisan),
    partisan_config:init(),
    partisan_sup:start_link(),
    partisan_default_peer_service_manager:start_link(),
    partisan_default_peer_service_manager:myself(),
    {ok, Supervisor}.

stop(_State) -> ok.