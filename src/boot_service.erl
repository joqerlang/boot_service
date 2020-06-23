%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc : Starts a computer eithre in master or worker mode
%%% 
%%% Description boot_service
%%% Make and start the board start SW.
%%%  boot_service initiates tcp_server and l0isten on port
%%%  Then it's standby and waits for controller to detect the board and start to load applications
%%% 
%%%     
%%% -------------------------------------------------------------------
-module(boot_service). 

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

-ifdef(test).
-define(DNS_INFO_FILE,"dns_test.info").
-else.
-define(DNS_INFO_FILE,"dns.info").
-endif.

-define(NUM_TRIES,10).
-define(INTERVAL,30*1000).
%% --------------------------------------------------------------------
 
%% --------------------------------------------------------------------
%% Key Data structures
%% 
%% --------------------------------------------------------------------
-record(state,{}).


	  
%% --------------------------------------------------------------------

%% ====================================================================
%% External functions
%% ====================================================================

-export([dns_get/1,dns_all/0,dns_update/1]).
%% server interface
-export([boot/0,
	 start_service/1,
	 stop_service/1,
	 get_config/0	 
	]).



-export([ping/0,
	 start/0,
	 stop/0
	 ]).
%% internal 
%% gen_server callbacks
-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).


%% ====================================================================
%% External functions
%% ====================================================================
dns_get(ServiceId)->
    local_dns:get(ServiceId).
dns_all()->
    local_dns:all().



boot()->
    application:start(?MODULE).

%% Asynchrounus Signals
%boot_strap()->
 %   PortStr=atom_to_list(PortArg),
 %   Port=list_to_integer(PortStr),
   % application:set_env([{boot_service,{port,Port}}]),
%    application:start(boot_service).
	
%% Gen server function

start()-> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
stop()-> gen_server:call(?MODULE, {stop},infinity).


%%----------------------------------------------------------------------
ping()->
    gen_server:call(?MODULE,{ping},infinity).

%% @doc: Reads the configuration file computer.config that must be resided
%%       in the working directory
%%       get_config()-> [{vm_name,VmName::string()},{ip_addr,IpAddr::string()} 
                     %    {port,Port::integer::()},{mode,Mode::atom()},{source,{Type::atom(),Source::string()}},
                     %    {computer_type,Type::atom()},{services_to_load,[ServiceId::string()]}]).

-spec(get_config()->[tuple()]|{error,Err::string()}).			 
get_config()->
    gen_server:call(?MODULE,{get_config},infinity).

start_service(ServiceId)->    
    gen_server:call(?MODULE,{start_service,ServiceId},infinity).
stop_service(ServiceId)->    
    gen_server:call(?MODULE,{stop_service,ServiceId},infinity).


dns_update(DnsInfo)->
    gen_server:cast(?MODULE,{dns_update,DnsInfo}).
    
%%___________________________________________________________________


%%-----------------------------------------------------------------------


%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%
%% --------------------------------------------------------------------
init([]) ->
    case application:get_all_env() of
	[]-> %% Normal worker
	    local_dns:init();
	Env-> %% List of atoms! Makescript states the services to start
	    {num_services,3}=lists:keyfind(num_services,1,Env),
	    {services,ServicesAtom}=lists:keyfind(services,1,Env),
	    ServiceIdList=string:tokens(atom_to_list(ServicesAtom),"X"),
	    [application:start(list_to_atom(ServiceId))||ServiceId<-ServiceIdList],
	    {ok,DnsInfo}=file:consult(?DNS_INFO_FILE),
	    local_dns:init(),
	    ok=lib_boot_service:connect_catalog(DnsInfo,?NUM_TRIES,?INTERVAL)
    end,
 %Crashes if no catalog is available


     
    {ok, #state{}}.
    
%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (aterminate/2 is called)
%% --------------------------------------------------------------------
handle_call({start_service,ServiceId}, _From, State) ->
    Reply=loader:start(ServiceId),
    {reply, Reply, State};
handle_call({stop_service,ServiceId}, _From, State) ->
    Reply=loader:stop(ServiceId),
    {reply, Reply, State};


handle_call({ping}, _From, State) ->
    Reply={pong,node(),?MODULE},
    {reply, Reply, State};

handle_call({config}, _From, State) ->
    Reply=glurk,
    {reply, Reply, State};



handle_call({stop}, _From, State) ->
    {stop, normal, shutdown_ok, State};

handle_call(Request, From, State) ->
    Reply = {unmatched_signal,?MODULE,?LINE,Request,From},
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast({dns_update,DnsInfo}, State) ->
    ok=local_dns:update(DnsInfo),
    {noreply, State};

handle_cast(Msg, State) ->
    io:format("unmatched match cast ~p~n",[{?MODULE,?LINE,Msg}]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)

handle_info(Info, State) ->
    io:format("unmatched match info ~p~n",[{?MODULE,?LINE,Info}]),
    {noreply, State}.


%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------


    
    
    

%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------
