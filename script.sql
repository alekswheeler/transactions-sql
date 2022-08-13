create or replace function add_nums(_num1 integer, _num2 integer)
  returns integer as
  $func$
    declare
      _sum integer;
    begin
      _sum := _num1 + _num2;
      return _sum;
    end;
  $func$
  language 'plpgsql';

  SELECT add_nums(3, 5);