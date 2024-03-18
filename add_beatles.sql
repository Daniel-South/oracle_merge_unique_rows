/***********************************************************************************************
FILE:		add_beatles.sql
TITLE:		Add members of The Beatles to an Oracle table using the MERGE command
AUTHOR:		Daniel R. South
DATE:		2024-03-07

DESCRIPTION:	Add unique records to a table. Avoid raising DUP_VAL_ON_INDEX if the record exists.

COMMENTS:	Using the MERGE command to add rows to the table provides three advantages.
		1. It prevents adding duplicate records.
		2. It will update the attributes of existing rows.
		3. The merge does the work of three separate statements in one, i.e.
			a. Check to see if a record exists based on its primary key
			b. Update the record if it exists
			c. Insert the record if it does not exist
***********************************************************************************************/

SET SERVEROUTPUT ON
SET VERIFY OFF


DECLARE
	PROCEDURE add_beatle(
		iv_first_name	IN VARCHAR2,
		iv_last_name	IN VARCHAR2,
		iv_instrument	IN VARCHAR2	DEFAULT 'Guitar'
	)
	IS
		n_rows_merged	NUMBER	:= 0;
	BEGIN
		dbms_output.put_line('==> Adding ' || iv_first_name || ' by ' || iv_last_name);

		MERGE INTO beatles dest
		USING
		(
			SELECT
				iv_first_name	AS first_name,
				iv_last_name	AS last_name,
				iv_instrument	AS main_instrument
			FROM DUAL
		) src
		ON ( dest.first_name = src.first_name AND dest.last_name = src.last_name )
		WHEN MATCHED THEN
			UPDATE SET
				dest.main_instrument	= src.main_instrument
		WHEN NOT MATCHED THEN
			INSERT (     first_name,     last_name,     main_instrument )
			VALUES ( src.first_name, src.last_name, src.main_instrument );

		n_rows_merged := SQL%ROWCOUNT;

		IF n_rows_merged > 0 THEN
			COMMIT;
		ELSE
			dbms_output.put_line('==> Merge failed on: ' iv_first_name || ' ' || iv_last_name || ' ' || iv_main_instrument);
			ROLLBACK;
		END IF;

	EXCEPTION
		WHEN OTHERS THEN
			dbms_output.put_line('!! Something went wrong while adding Beatle ' || iv_first_name || '!!');
			dbms_output.put_line(SQLERRM);
			ROLLBACK;
			RAISE;
	END;
BEGIN
	DBMS_OUTPUT.PUT_LINE('*** Add Beatles ***');

	add_beatle( 'George', 'Harrison',  'Guitar' );
	add_beatle( 'Paul',   'McCartney', 'Piano' );
	add_beatle( 'Ringo',  'Starr',     'Drums' );

	-- Use the procedure's default parameter for instrument.

	add_beatle( 'John',   'Lennon' );

	-- Update Paul's record setting his main instrument to Bass.
	-- Here, the merge will update a previously inserted record.

	add_beatle( 'Paul',   'McCartney', 'Bass' );

	DBMS_OUTPUT.PUT_LINE('*** Finished Adding Beatles ***');
END;
/
