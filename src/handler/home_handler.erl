-module (home_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
	{ok, Req, undefined}.

handle(Req, State) ->
	{Method, Req2} = cowboy_req:method(Req),
	{Path, Req3} = cowboy_req:path(Req2),
	{ok, Req4} = home(Method, Path, Req3),
	{ok, Req4, State}.

home(<<"GET">>, _, Req) ->
    {ok, Content} = home_dtl:render([]),
	cowboy_req:reply(400, [], Content, Req);
    
home(_, _, Req) ->
	%% Method not allowed.
	cowboy_req:reply(405, Req).

terminate(_Reason, _Req, _State) ->
	ok.
