%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Create1d : 10 dec 2012
%%% -------------------------------------------------------------------
-module(boot_service_tests). 
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").

%% --------------------------------------------------------------------


-ifdef(master).
-define(CHECK_LOADED_SERVICES,check_loaded_services()).
-else.
-define(CHECK_LOADED_SERVICES,ok).
-endif.

%% External exports
-export([start/0]).




%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
start()->
    spawn(fun()->eunit:test({timeout,10*60,boot_service}) end).

cases_test()->
    ?debugMsg("Test system setup"),
    setup(),
    %% Start application tests
    ?debugMsg("check_loaded_services test"),    
    ?assertEqual(ok,?CHECK_LOADED_SERVICES),

    ?debugMsg("test loader"),    
    ?assertEqual(ok,loader_test:start()),

  %  ?debugMsg("tcp_client call test"),    
   % ?assertEqual(ok,tcp_client_call()),

  %  ?debugMsg("dns,log master call test"),    
  %  ?assertEqual(ok,master_call()),    
%    ?debugMsg("Start stop_test_system:start"),
    %% End application tests
  
    cleanup(),
    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
setup()->
    ?assertEqual(ok,boot_service:boot()),
    ?assertMatch({pong,_,boot_service},boot_service:ping()),  
    ok.

check_loaded_services()->
     ?assertMatch({pong,_,iaas_service},iaas_service:ping()),  
     ?assertMatch({pong,_,catalog_service},catalog_service:ping()),  
     ?assertMatch({pong,_,orchistrate_service},orchistrate_service:ping()),  
    ok.



tcp_client_call()->
    IpAddr=lib_boot_service:get_config(ip_addr),
    Port=lib_boot_service:get_config(port),
    ?assertMatch({pong,_,boot_service},
		 tcp_client:call({IpAddr,Port},{boot_service,ping,[]})),
    ok.


master_call()->
    IpAddr=lib_boot_service:get_config(ip_addr),
    Port=lib_boot_service:get_config(port),
     ?assertMatch({pong,_,dns_service},
		 tcp_client:call({IpAddr,Port},{dns_service,ping,[]})),
     ?assertMatch({pong,_,log_service},
		 tcp_client:call({IpAddr,Port},{log_service,ping,[]})),
     ?assertMatch({pong,_,master_service},
		 tcp_client:call({IpAddr,Port},{master_service,ping,[]})),

     ?assertMatch({pong,_,master_service},
		  tcp_client:call({IpAddr,Port},{dns_service,all,[]})),
    ?assertEqual(ok,application:stop(master_service)),  
    ?assertEqual(ok,application:stop(log_service)),  
    ?assertEqual(ok,application:stop(dns_service)),  
    ok.
cleanup()->
    ?assertMatch({pong,_,boot_service},boot_service:ping()),   
    ?assertEqual(ok,application:stop(boot_service)),  
    init:stop().




