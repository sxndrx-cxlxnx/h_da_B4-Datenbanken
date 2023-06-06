ALTER TABLE vertrag ADD 
	CONSTRAINT checkMonatspreis CHECK( monatspreis >= '$10.00' );
	