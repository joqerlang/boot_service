%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(local_dns_test). 
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").

%% --------------------------------------------------------------------
-define(DNS_1,[{"dns_service",'root_sthlm_1@asus'},
	       {"log_service",'root_sthlm_1@asus'},
	       {"adder_service",'worker_varmdoe_1@asus'},
	       {"adder_service",'worker_sthlm_1@asus'},
	       {"divi_service",'worker_sthlm_2@asus'}]).

-define(DNS_2,[{"dns_service",'root_sthlm_1@asus'},
	       {"adder_service",'worker_varmdoe_1@asus'},
	       {"divi_service",'worker_sthlm_2@asus'}]).
-export([start/0]).

%% ====================================================================
%% External functions
%% ====================================================================


% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
start()->
    
    ?debugMsg("local_dns_test init"),
    ?assertEqual(ok,init()),
    
    ?debugMsg("local_dns_test update_1"),
    ?assertEqual(ok,update_1()), 

    ?debugMsg("local_dns_test update_2"),
    ?assertEqual(ok,update_2()), 
    ok.

init()->
  %  ?assertEqual(ok,local_dns:init()),
    ?assertEqual([],boot_service:dns_all()),    
    ?assertEqual([],boot_service:dns_get("adder_service")),  
    ok.
   

update_1()->
    ?assertEqual(ok,boot_service:dns_update(?DNS_1)),
    ?assertEqual([{"dns_service",root_sthlm_1@asus},
		  {"log_service",root_sthlm_1@asus},
		  {"adder_service",worker_varmdoe_1@asus},
		  {"adder_service",worker_sthlm_1@asus},
		  {"divi_service",worker_sthlm_2@asus}],boot_service:dns_all()),    
    ?assertEqual([{"adder_service",worker_varmdoe_1@asus},
		  {"adder_service",worker_sthlm_1@asus}],boot_service:dns_get("adder_service")), 
    ?assertEqual([{"log_service",root_sthlm_1@asus}],boot_service:dns_get("log_service")),  
    ?assertEqual([],boot_service:dns_get("glurk_service")),  
    ok.	 

update_2()->
    ?assertEqual(ok,boot_service:dns_update(?DNS_2)),
    ?assertEqual([{"dns_service",root_sthlm_1@asus},
		  {"adder_service",worker_varmdoe_1@asus},
		  {"divi_service",worker_sthlm_2@asus}],boot_service:dns_all()),    
    ?assertEqual([{"adder_service",worker_varmdoe_1@asus}],boot_service:dns_get("adder_service")), 
    ?assertEqual([],boot_service:dns_get("log_service")),  
    ?assertEqual([],boot_service:dns_get("glurk_service")),  
    ok.	
