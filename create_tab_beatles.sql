/***********************************************************************************************
FILE:		create_tab_beatles.sql
TITLE:		Create a table to hold a list Beatles
AUTHOR:		Daniel R. South
***********************************************************************************************/

SET SERVEROUTPUT ON
SET VERIFY OFF


DECLARE
	CV_TAB_NAME	CONSTANT	VARCHAR2(128) 	:= 'BEATLES';
	n_row_count	NUMBER		:= 0;
	v_create_sql	VARCHAR2(4000);

BEGIN
	dbms_output.put_line('*** Create table ' || CV_TAB_NAME );

	SELECT 	COUNT(*)
	INTO	n_row_count
	FROM	user_tables
	WHERE	table_name = CV_TAB_NAME;

	IF n_row_count > 0 THEN
		dbms_output.put_line('==> Table ' || CV_TAB_NAME || ' already exists.');

	ELSE
		v_create_sql := 'CREATE TABLE ' || CV_TAB_NAME || q'[ (
			first_name		VARCHAR2(32),
			last_name		VARCHAR2(32),
			main_instrument		VARCHAR2(100),
			PRIMARY_KEY( first_name, last_name )
		) ]';

		EXECUTE IMMEDIATE v_create_sql;

		dbms_output.put_line('==> Table ' || CV_TAB_NAME || ' was created successfully!');
	END IF;

EXCEPTION
	WHEN OTHERS THEN
		dbms_output.put_line('!! Something went wrong while creating table ' || CV_TAB_NAME || '!!');
		dbms_output.put_line(SQLERRM);
		RAISE;
END;
/
