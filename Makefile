all:
	rm -rf *.info app_config catalog node_config  logfiles *_service include *~ */*~ */*/*~;
	rm -rf */*.beam;
	rm -rf *.beam erl_crash.dump */erl_crash.dump */*/erl_crash.dump;
	cp src/*.app ebin;
	erlc -o ebin src/*.erl;
doc_gen:
	rm -rf  node_config logfiles doc/*;
	erlc ../doc_gen.erl;
	erl -s doc_gen start -sname doc

master:
	rm -rf *_service  *_config catalog erl_crasch.dump;
#	orchistrate_service
	git clone https://github.com/joqerlang/orchistrate_service.git;
	cp orchistrate_service/src/*.app orchistrate_service/ebin;
	erlc -o orchistrate_service/ebin orchistrate_service/src/*.erl;
#	iaas_service
	git clone https://github.com/joqerlang/iaas_service.git;
	cp iaas_service/src/*.app iaas_service/ebin;
	erlc -o iaas_service/ebin iaas_service/src/*.erl;
#	catalog_service
	git clone https://github.com/joqerlang/catalog.git;
	cp catalog/dns_test.info .;
	rm -rf catalog;
	git clone https://github.com/joqerlang/app_config.git;
	cp app_config/app.spec .;
	rm -rf app_config;
	git clone https://github.com/joqerlang/catalog_service.git;	
	cp catalog_service/src/*.app catalog_service/ebin;
	erlc -o catalog_service/ebin catalog_service/src/*.erl;
#	boot_service
	cp src/*.app ebin;
	erlc -D test -o ebin src/*.erl;	
#	test
	erlc -D master -o test_ebin test_src/*.erl;
	erl -pa */ebin -pa ebin -pa test_ebin -boot_service num_services 3 -boot_service services orchistrate_serviceXcatalog_serviceXiaas_service -s boot_service_tests start -sname master_boot_test
worker:
	rm -rf *.info catalog *_service ebin/* test_ebin/* test_src/*~ src/*~ erl_crasch.dump;
	git clone https://github.com/joqerlang/catalog.git;
	cp catalog/dns_test.info .;
	rm -rf catalog;
	cp src/*.app ebin;
	erlc -D test -o  ebin src/*.erl;	
#	test
	erlc -D worker -D test -o test_ebin test_src/*.erl;
	erl -pa */ebin -pa ebin -pa test_ebin -s boot_service_tests start -sname worker_boot_test
