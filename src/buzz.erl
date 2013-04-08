-module (buzz).
-author ('Hisham Ismail <mhishami@gmail.com>').
-export ([start/0]).
-export ([loglevel/1]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.
  
start() ->
	ok = ensure_started(crypto),
	ok = ensure_started(ranch),
	ok = ensure_started(cowboy),
	ok = ensure_started(mongodb),
	ok = ensure_started(mongrel),
	ok = ensure_started(buzz).
    
loglevel(Level) ->
    lager:set_loglevel(lager_console_backend, Level).
    