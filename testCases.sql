DELETE FROM "Schedule";
DELETE FROM edges;
DELETE FROM vis;
DELETE FROM dfsVis;

-- example_01 (PostgreSQL 10)
INSERT INTO "Schedule" ("time", "#t", "op", "attr") VALUES
(1, 1,  'R',  'X'),
(2, 2,  'R',  'X'),
(3, 2,  'W',  'X'),
(4, 1,  'W',  'X'),
(5, 2,  'C',  '-'),
(6, 1,  'C',  '-');

-- calling function
SELECT testeEquivalenciaPorConflito() AS "TEST CASE #1";

-- Cleanning Table;
DELETE FROM "Schedule";

-- example_02 (PostgreSQL 10)
INSERT INTO "Schedule" ("time", "#t", "op", "attr") VALUES
    (7, 3,  'R',  'X'),
    (8, 3,  'R',  'Y'),
    (9, 4,  'R',  'X'),
    (10,  3,  'W',  'Y'),
    (11,  4,  'C',  '-'),
    (12,  3,  'C',  '-');

DELETE FROM edges;
DELETE FROM vis;
DELETE FROM dfsVis;

-- calling function
SELECT testeEquivalenciaPorConflito() AS "TEST CASE #2";

-- -- -- Cleanning Table;
DELETE FROM "Schedule";

INSERT INTO public."Schedule"("time", "#t", op, attr) VALUES 
(1, 5,  'W',  'A'),
(2, 1,  'W',  'A'),
(3, 5,  'W',  'B'),
(4, 7,  'W',  'B'),
(5, 5,  'W',  'C'),
(6, 4,  'W',  'C'),
(7, 1,  'W',  'D'),
(8, 3,  'W',  'D'),
(9, 3,  'W',  'E'),
(10, 7,  'W',  'E'),
(11, 3,  'W',  'F'),
(12, 6,  'W',  'F'),
(13, 7,  'W',  'G'),
(14, 2,  'W',  'G'),
(15, 4,  'W',  'H'),
(16, 7,  'W',  'H'),
(17, 4,  'W',  'I'),
(18, 0,  'W',  'I'),
(19, 0,  'W',  'J'),
(20, 2,  'W',  'J'),
(21, 6,  'W',  'K'),
(22, 4,  'W',  'K'),
(23, 6,  'W',  'L'),
(24, 0,  'W',  'L'),
(25, 6,  'W',  'M'),
(26, 2,  'W',  'M'),
(27, 2,  'W',  'N'),
(28, 3,  'W',  'N');

DELETE FROM edges;
DELETE FROM vis;
DELETE FROM dfsVis;

-- calling function
SELECT testeEquivalenciaPorConflito() AS "TEST CASE #3";

DELETE FROM edges;
DELETE FROM vis;
DELETE FROM dfsVis;

-- Cleanning Table;
DELETE FROM "Schedule";