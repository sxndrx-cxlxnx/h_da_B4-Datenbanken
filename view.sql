CREATE VIEW sender_programm AS

SELECT DISTINCT sender.sendername 
		FROM sender 
			JOIN ausgestrahlt 
				ON sender.sendername = ausgestrahlt.sendername