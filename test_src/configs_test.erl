%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(configs_test). 
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").

%% --------------------------------------------------------------------

-compile(export_all).

%% ====================================================================
%% External functions
%% ====================================================================


% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
start_git()->
    ?assertEqual({ok,[{vm_name,"master_sthlm_1"},
		      {ip_addr,"localhost"},
		      {port,40000},
		      {mode,parallell},
		      {source,{git,"https://github.com/joq62/"}},
		      {system_role,master},
		      {services_to_load,["dns_service","log_service","master_service"]}]},
		 lib_boot_service:get_config()),
    
   ok.    
   
start_dir()->
    ?assertEqual({ok,[{vm_name,"master_sthlm_1"},
		      {ip_addr,"localhost"},
		      {port,40000},
		      {mode,parallell},
		      {source,{dir,"/home/pi/erlang/infrastructure/"}},
		      {system_role,master},
		      {services_to_load,["dns_service","log_service","master_service"]}]},
		 lib_boot_service:get_config()),
    
   ok.    
   
