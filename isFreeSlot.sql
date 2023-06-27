CREATE OR REPLACE FUNCTION isFreeSlot(varchar(20), timestamp without time zone, timestamp without time zone) returns boolean as $isfreeslot$
DECLARE

	c1 cursor for SELECT startzeit, endzeit FROM ausgestrahlt WHERE sendername LIKE $1;
	row1 record;

BEGIN
	for row1 in c1 loop

		if(($2 <= row1.endzeit AND $2 >= row1.startzeit) OR ($3 >= row1.startzeit AND $3 <= row1.endzeit))
		then
			return false;
		end if;
		
	end loop;

	return true;
END;
$isfreeslot$ LANGUAGE plpgsql;