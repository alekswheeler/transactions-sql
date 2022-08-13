# transactions-sql

## Comandos

### Executando psql

    docker exec -ti transactions-sql_teste-postgres-compose_1 psql -U postgres

### Como rodar o script

Primeiro é preciso copiar o script para dentro do `volume` do container seguindo o comando abaixo:

    docker cp ./script.sql transactions-sql_teste-postgres-compose_1:/docker-entrypoint-initdb.d/script.sql

Em seguida, executamos o script dentro do container:

    docker exec -u postgres transactions-sql_teste-postgres-compose_1 psql -f docker-entrypoint-initdb.d/script.sql

### Entry table

op = "R", "W", "C";
att = "z", "y", "y", ...

Schedule (int time, int transaction, char op, char att);
