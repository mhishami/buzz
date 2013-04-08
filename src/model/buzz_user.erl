-module (buzz_user).
-author ('Hisham Ismail <mhishami@gmail.com>').

-export ([authenticate/2]).

authenticate(Email, Password) ->
    case Email =:= <<"mhishami@gmail.com">> andalso
        Password =:= <<"sa">> of
        true ->
            ok;
        _ ->
            error
    end.
    