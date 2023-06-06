ALTER TABLE episode ADD 
	CONSTRAINT keine_negativen_rating CHECK( imdb_rating >= 0 );