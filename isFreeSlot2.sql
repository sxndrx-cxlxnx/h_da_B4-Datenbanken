CREATE OR REPLACE FUNCTION isSlotFree() returns trigger as $$
DECLARE

	c1 cursor for SELECT sendername, startzeit, endzeit FROM ausgestrahlt;
	row1 record;

BEGIN
	raise notice 'Trigger aktiviert';

	raise notice 'NEW Werte %', NEW.sendername;
	raise notice 'NEW Werte %', NEW.startzeit;
	raise notice 'NEW Werte %', NEW.endzeit;

	for row1 in c1 loop

		raise notice 'For-Schleife aktiviert %', row1;

		if(row1.sendername LIKE NEW.sendername)
		then

			if((NEW.startzeit < row1.endzeit AND NEW.startzeit > row1.startzeit) OR (NEW.endzeit > row1.startzeit AND NEW.endzeit < row1.endzeit))
			then
				raise exception 'Ausstrahlung ueberschneidet sich mit anderer Austrahlung';
				return NULL;
			end if;
		end if;
		
	end loop;

	raise notice 'Trigger beendet';
	return NEW;

END;
$$ LANGUAGE plpgsql;

create OR REPLACE trigger isSlotFreeTrigger before insert on ausgestrahlt
	for each row execute function isSlotFree();

