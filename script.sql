DROP TABLE IF EXISTS edges;
CREATE TABLE edges(
  u INTEGER,
  v INTEGER,
  PRIMARY KEY (u, v)
);

DROP TABLE IF EXISTS vis;
CREATE TABLE vis(
    transaction INTEGER PRIMARY KEY,
    status BOOLEAN
);

DROP TABLE IF EXISTS dfsVis;
CREATE TABLE dfsVis(
    transaction INTEGER PRIMARY KEY,
    status BOOLEAN
);

CREATE OR REPLACE FUNCTION checkCycle(node integer)
RETURNS boolean AS $$
    DECLARE
    f record;
    rec record;
    rec2 record;
    BEGIN

    UPDATE vis SET "status" = true WHERE transaction = node;
    UPDATE dfsVis SET "status" = true WHERE transaction = node;

    --varrendo adjacencias do node
        FOR f in SELECT * FROM edges WHERE node = edges.u
        LOOP
        --if(!visitado[f])
            SELECT * INTO rec FROM vis WHERE f.u = vis.transaction ;
            SELECT * INTO rec2 FROM dfsVis WHERE f.u = dfsVis.transaction ;
            IF rec."status" = false THEN
                IF checkCycle(f.u) = true THEN
                    RETURN true;
                END IF;
            --if (dfsVis[f])

            ELSIF rec2."status" = true THEN
                RETURN true;
            END IF;
        END LOOP;
    UPDATE dfsVis SET "status" = false WHERE transaction = node;
    RETURN false;
    END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION isCyclic()
RETURNS boolean AS $$
    DECLARE
    v record;
    rec record;
    BEGIN
        FOR v IN SELECT DISTINCT "#t" from "Schedule"
        LOOP
            SELECT * INTO rec FROM vis WHERE v."#t" = vis.transaction ;
            IF rec."status" = false THEN
                IF checkCycle(v."#t") = true THEN
                    RETURN true;
                END IF;
            END IF;
        END LOOP;
        RETURN false;
    END;
$$ language plpgsql;

-- function signature (PostgreSQL 10)
CREATE OR REPLACE FUNCTION testeEquivalenciaPorConflito () 
RETURNS integer AS $$
    DECLARE
      node_u "Schedule"%ROWTYPE;
      node_v "Schedule"%ROWTYPE;
      rec RECORD;
      nnodes integer;
      result boolean;
    BEGIN
      -- Itera sobre todas as linhas (u)
      FOR node_u IN 
        SELECT * FROM "Schedule"
      LOOP
      -- Itera sobre todas as linhas cujo time é maior do que o time de u
        FOR node_v IN
          SELECT * FROM "Schedule" WHERE node_u."time" < "Schedule".time
        LOOP
          -- Regras de criação de arestas
          IF (node_u."attr" = node_v."attr") AND (node_u."op" = 'W' OR node_v."op" = 'W') AND (node_u."#t" != node_v."#t") THEN
            SELECT * INTO rec FROM edges WHERE u = node_u."#t" AND v = node_v."#t";
            IF NOT FOUND THEN
              INSERT INTO edges(u, v) VALUES(node_u."#t", node_v."#t");
            END IF;
          END IF;
        END LOOP;
      END LOOP;

    -- Algoritmo DFS para identificar ciclos em grafos dirigidos não valorados
      FOR rec IN SELECT DISTINCT "#t" FROM "Schedule"
      LOOP
        --RAISE NOTICE '%',rec;
        INSERT INTO vis(transaction,status) values(rec."#t",false);
        INSERT INTO dfsVis(transaction,status) values(rec."#t",false);
      END LOOP;

      SELECT INTO result isCyclic();
        IF result = true THEN
            RETURN 0;
        ELSE RETURN 1;
        END IF;
    END;
$$ LANGUAGE plpgsql;

-- calling function
SELECT testeEquivalenciaPorConflito() AS resp;
SELECT * FROM edges;
/*SELECT * FROM vis;
SELECT * FROM dfsVis;*/
