-module (auth_controller).

-export ([handle_request/5]).
-export ([before_filter/2]).

-include ("buzz.hrl").
-include_lib("mongrel/include/mongrel_macros.hrl").

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

handle_request(<<"GET">>, <<"logout">>, _Args, [{auth, User}, {sid, Sid}, _, _], _Req) ->
    lager:log(info, self(), "User ~p logged out. Session = ~p", [User, Sid]),
    tuah:delete(Sid),
    {redirect, <<"/">>};

handle_request(<<"GET">>, <<"register">>, _Args, _Params, _Req) ->
    Days = lists:seq(1, 31),
    Months = [ 
        <<"Jan">>, <<"Feb">>, <<"Mar">>, <<"Apr">>, <<"May">>, <<"Jun">>,
        <<"Jul">>, <<"Aug">>, <<"Sep">>, <<"Oct">>, <<"Nov">>, <<"Dec">>
    ],
    Years = lists:seq(1970, 2013-18),
    Prefix = lists:seq(0, 9),
    
    {<<"register">>, [{days, Days}, {months, Months}, {years, Years}, {prefix, Prefix}]};

% -record(user, {'_id', email, password, join_date, update_date, groups}).
% -record(profile, {'_id', email, first_name, last_name, mobile_no, birthdate, avatar}).

handle_request(<<"POST">>, <<"register">>, _Args, [_, _, _, {qs_body, Vals}], _Req) ->
    lager:log(debug, self(), "Register vals = ~p", [Vals]),
    BD = {
        {?b2i(proplists:get_value(<<"year">>, Vals)),
         month(proplists:get_value(<<"month">>, Vals)),
         ?b2i(proplists:get_value(<<"day">>, Vals))}, {0, 0, 0}},
    BirthDate = date_to_timestamp(BD),
    lager:log(debug, self(), "BirthDate = ~p", [BirthDate]),
    
    User = #user{?id(), email= proplists:get_value(?EMAIL, Vals),
            password= proplists:get_value(<<"password2">>, Vals),
            join_date= now(), update_date= now(),
            groups = []},    
    lager:log(debug, self(), "User = ~p", [User]),
    
    Prefix = proplists:get_value(<<"prefix">>, Vals),
    Number = proplists:get_value(<<"number">>, Vals),
    Profile = #profile{?id(), email= proplists:get_value(?EMAIL, Vals),
            mobile_no= << Prefix/binary, Number/binary >>,
            birthdate=BirthDate, avatar= <<>>},
    lager:log(debug, self(), "Profile = ~p", [Profile]),
    
    buzz_db:register(User, Profile),
    {redirect, <<"/">>};

handle_request(_, _, _, _, _) ->
    {error, <<"Oppsss, Forbidden!">>}.
    
%% ----------------------------------------------------------------------------
month(<<"Jan">>) -> 1;
month(<<"Feb">>) -> 2;
month(<<"Mar">>) -> 3;
month(<<"Apr">>) -> 4;
month(<<"May">>) -> 5;
month(<<"Jun">>) -> 6;
month(<<"Jul">>) -> 7;
month(<<"Aug">>) -> 8;
month(<<"Sep">>) -> 9;
month(<<"Oct">>) -> 10;
month(<<"Nov">>) -> 11;
month(<<"Dec">>) -> 12.

date_to_timestamp(Datetime) ->
    Seconds = calendar:datetime_to_gregorian_seconds(Datetime) - 62167219200,
    {Seconds div 1000000, Seconds rem 1000000, 0}.

    