-module (auth_controller).

-export ([handle_request/5]).
-export ([before_filter/2]).

-define(EMAIL, <<"email">>).
-define(PASS, <<"password">>).

before_filter(Params, _Req) ->
    lager:log(debug, self(), "auth: Params: ~p", [Params]),
    {ok, proceed}.
    
handle_request(<<"GET">>, <<"login">>, _Args, _Params, _Req) ->
    {<<"login">>, []};
    
handle_request(<<"POST">>, <<"login">>, _Args, [_, {sid, Sid}, _, {qs_body, Vals}] = Params, _Req) ->
    lager:log(debug, self(), "auth: Params: ~p", [Params]),    
    lager:log(debug, self(), "auth: Vals = ~p", [Vals]),
    
    Email = proplists:get_value(?EMAIL, Vals, []),
    Pass = proplists:get_value(?PASS, Vals, []),
    
    case buzz_user:authenticate(Email, Pass) of
        ok ->            
            lager:log(info, self(), "auth: Login for ~p is successful", [Email]),
            tuah:set(Sid, Email, 2*60),   %% 2 min timeout
            
            {redirect, <<"/">>};
        _ ->
            {<<"login">>, [{error, <<"Email or password is wrong">>}]}
    end;

handle_request(<<"GET">>, <<"logout">>, _Args, [_, {sid, Sid}, _, _], _Req) ->
    tuah:delete(Sid),
    {redirect, <<"/">>};

handle_request(<<"GET">>, <<"register">>, _Args, _Params, _Req) ->
    Days = lists:seq(1, 31),
    Months = [ 
        <<"Jan">>, <<"Feb">>, <<"Mar">>, <<"Apr">>, <<"May">>, <<"Jun">>,
        <<"Jul">>, <<"Aug">>, <<"Sep">>, <<"Oct">>, <<"Nov">>, <<"Dec">>
    ],
    Years = lists:seq(1970, 2013-18),
    
    {<<"register">>, [{days, Days}, {months, Months}, {years, Years}]};

handle_request(_, _, _, _, _) ->
    {error, <<"Oppsss, Forbidden!">>}.
    