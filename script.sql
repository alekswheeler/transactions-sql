
DROP TABLE IF EXISTS edges;
CREATE TABLE edges(
  u INTEGER,
  v INTEGER,
  PRIMARY KEY (u, v)
);

-- function signature (PostgreSQL 10)
CREATE OR REPLACE FUNCTION testeEquivalenciaPorConflito () 
RETURNS integer AS $$
    DECLARE
      node_u "Schedule"%ROWTYPE;
      node_v "Schedule"%ROWTYPE;
      rec RECORD;
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
          IF node_u."attr" = node_v."attr" AND node_u."op" = 'W' OR node_v."op" = 'W' AND node_u."#t" != node_v."#t" THEN
            SELECT * INTO rec FROM edges WHERE u = node_u."#t" AND v = node_v."#t";
            IF NOT FOUND THEN
              INSERT INTO edges(u, v) VALUES(node_u."#t", node_v."#t");
            END IF;
          END IF;
        END LOOP;
      END LOOP;
    -- Algoritmo DFS para identificar ciclos em grafos dirigidos não valorados
    RETURN 0;
    END;
$$ LANGUAGE plpgsql;

-- calling function
SELECT testeEquivalenciaPorConflito() AS resp;

SELECT * FROM edges;
DROP TABLE edges;