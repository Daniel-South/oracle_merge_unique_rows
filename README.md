# oracle_merge_unique_rows

Oracle PL/SQL code by Daniel South, 7 March 2024

To ensure that rows inserted into a table are not duplicates of existing rows, we can check to see whether a row exists and insert it if it does not.
This requires multiple statements in a PL/SQL block.

DECLARE  
    n_num_rows NUMBER := 0;  
  
BEGIN  

  SELECT  COUNT(*)  
  INTO    n_num_rows  
  FROM    my_table  
  WHERE   key_column = 123;  

  IF n_num_rows < 1 THEN  
    INSERT INTO my_table(key_column, attribute1) VALUES(123, 'Hello, World!');  
    COMMIT;  
  ELSE  
    dbms_output.put_line('A row exists already for key column 123');  
  END IF;  
  
END;  
/

If the key column has a unique index or a primary key contstraint, we would attempt to insert the row and ignore the DUP_VAL_ON_INDEX exception,
but that's a messy approach.

What if one statement could
1. Check to see if the row exists
2. Insert the row if it's not in the table
3. Update attributes of the row if it does exist

Oracle has just such a command, the MERGE command. This example shows how to use the MERGE command to insert rows into a table while ensuring uniqueness.
