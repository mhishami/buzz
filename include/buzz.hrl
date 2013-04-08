
-define (INFO(Name), error_logger:info_msg(Name)).
-define (INFO(Name, Args), error_logger:info_msg(Name, Args)).

-define (get_path(Path), tl(binary:split(Path, <<"/">>, [global]))).
-define (get_action(Path), lists:nth(2, tl(binary:split(Path, <<"/">>, [global])))).
