run:
	docker cp ./testCases.sql transactions-sql_teste-postgres-compose_1:/docker-entrypoint-initdb.d/testCases.sql \
	&& \
	docker exec -u postgres transactions-sql_teste-postgres-compose_1 psql -f docker-entrypoint-initdb.d/testCases.sql -q

runFile:
	docker cp ./$(FILE) transactions-sql_teste-postgres-compose_1:/docker-entrypoint-initdb.d/$(FILE).sql \
	&& \
	docker exec -u postgres transactions-sql_teste-postgres-compose_1 psql -f docker-entrypoint-initdb.d/$(FILE) -q
