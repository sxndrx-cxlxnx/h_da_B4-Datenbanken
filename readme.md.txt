# Aufgabenbeschreibung zu den SQL-SELECTs

Diese readme.md dient als **Template** für Ihre SQL-SELECT Statements für Praktikum 3.
 
Sobald Ihre SQL-SELECT Statements das erwartete Ergebnis (siehe bereitgestellte Lösungen in Moodle) liefern, fügen Sie diese SQL Statements hier in die entsprechenden Felder unter [SQL-SELECT Statements](#sql-select-statements) ein. Diese Statements werden geprüft und Gegenstand des Praktikums sein. 

Die Musterlösungen zu den einzelnen SQL-Statements werden Ihnen ausgehändigt, sodass Sie vor der Einreichung selbst kontrollieren können, ob Ihr Ergebnis korrekt ist. 

<br>

# Zu beachtende Regeln!
Beachten Sie bei der Bearbeitung dieser Aufgabe folgendes:

### Regel Nr. 1 
Formatieren sie die SQL-SELECT Statements so, dass es einfach ist diese zu lesen. Das bedeutet, schreiben Sie die SELECT-Statements **NICHT** in eine einzige Zeile, wie z.B.:    
```sql
SELECT  a.col1, b.col2, AVG(b.col3) AS avg, FROM table_a a, table_b b WHERE a.col1 = b.col2 GROUP BY a.col1, b.col2 ORDER BY avg HAVING (avg > (SELECT max(col1) FROM table_c)); 
```    
    
Schreiben Sie die Statements stattdessen mit den einzelnen SQL Key-Fragmenten (SELECT, FROM, WHERE, etc.) pro Zeile und mit den nötigen Indents (Einrückungen) auf, wie z.B. hier:
```sql
SELECT a.col1, b.col2, AVG(b.col3) AS avg
    FROM table_a a, table_b b
    WHERE a.col1 = b.col2
    GROUP BY a.col1, b.col2
    ORDER BY avg
    HAVING (avg < 
        (SELECT max(col1)
            FROM table_c));       
```  

<br>

### Regel Nr. 2 (WICHTIG!!!)
Machen Sie sich klar, dass Ihr SQL-Statement nicht dadurch automatisch korrekt ist, dass es die gleichen
Ausgaben liefert, wie sie in der Lösung stehen! Ihr Statement sollte die gestellte Frage beantworten, und nicht „rein zufällig“ die gleiche Ausgabe liefern.

Als Beispiel folgende **Aufgabe 0**:<br>
"Für welche Flugnummern haben Passagiere $200 für einen Platz bezahlt?"<br>
Das richtige Ergebnis ist die Projektion von Flugnummer mit dem einzigen Eintrag "**LH-200**". 

Ihre SQL-Abfrage darf **NICHT** folgendermaßen lauten:
```sql
SELECT flugnr
    FROM Buchung
    WHERE flugnr = "LH-200";
``` 
Das wäre eine vollkommen falsche Abfrage mit der zufällig gleichen Ausgabe. Durch solche SQL-Statements gefährden Sie die Erteilung eines Testats enorm! 

Korrekt wäre die Abfrage:
```sql
SELECT flugnr
    FROM Buchung
    WHERE Preis = "$200";
```

Zusätzlich können Sie auch gerne Erklärungen zu Ihren SQL-Select Statements schreiben, um zu erklären was da genau passiert, oder warum Sie sich für diese Query entschieden haben

<br>

Und nun viel Spaß bei der Generierung der SQL-Statements :-)

<br>

# SQL-SELECT Statements

1. Welche Serien haben ein "a" im Namen ?
    ```sql

	SELECT * 
		FROM serie 
		WHERE serienname LIKE '%a%';
    ```
2. Geben Sie die Namen der Sender aus, welche aktuell ein Fernsehprogramm haben.
    ```sql

	SELECT DISTINCT sender.sendername 
		FROM sender 
			JOIN ausgestrahlt 
				ON sender.sendername = ausgestrahlt.sendername;

	SELECT DISTINCT sender.sendername  
		FROM sender NATURAL JOIN ausgestrahlt;

	SELECT sendername 
		FROM sender 
		WHERE sendername IN 
			(SELECT sendername 
				FROM ausgestrahlt);

	SELECT DISTINCT s.sendername 
		FROM sender s, ausgestrahlt a 
		WHERE s.sendername = a.sendername; 
    ```
3. Geben Sie die Namen der Sender aus, welche aktuell ein Fernsehprogramm mit Ausstrahlungsbeginn nach 17.30 haben
    ```sql
    SELECT ...

	SELECT DISTINCT sender.sendername 
		FROM sender 
			JOIN ausgestrahlt 
				ON sender.sendername = ausgestrahlt.sendername 
		WHERE startzeit > '2023-05-01 17:30:00';

	SELECT DISTINCT sender.sendername  
		FROM sender 
			NATURAL JOIN ausgestrahlt 
		WHERE startzeit > '2023-05-01 17:30:00';

	SELECT sendername 
		FROM sender 
		WHERE sender.sendername IN 
			(SELECT sendername 
				FROM ausgestrahlt 
				WHERE startzeit > '2023-05-01 17:30:00');

	SELECT DISTINCT s.sendername 
		FROM sender s, ausgestrahlt a 
		WHERE s.sendername = a.sendername 
			AND a.startzeit > '2023-05-01 17:30:00';

    ```
4.  Geben Sie die Namen der Serien aus, bei denen Aaron Paul mitspielt.
    ```sql

	SELECT serienname 
		FROM hauptschauspieler 
		WHERE hauptschauspieler_id IN
			(SELECT kuenstler_id 
				FROM kuenstler 
				WHERE vorname = 'Aaron' 
					AND nachname = 'Paul');

	SELECT serienname 
		FROM hauptschauspieler h 
			JOIN kuenstler k 
				ON h.hauptschauspieler_id = k.kuenstler_id 
		WHERE k.vorname = 'Aaron' 
			AND k.nachname = 'Paul';

	SELECT h.serienname 
		FROM hauptschauspieler h, kuenstler k 
		WHERE h.hauptschauspieler_id = k.kuenstler_id 
			AND k.vorname = 'Aaron' 
			AND k.nachname = 'Paul';
    ```
5. Geben Sie die Gesamtsumme aus, welche die Pilsstube Herkules monatlich für Streamingabos ausgibt.
     ```sql

	SELECT SUM (monatspreis) 
		FROM vertrag 
		WHERE e_mail = 'peter.feldmann@awo.de';
    ```
   
6. Geben Sie die nach durchschnittlichem Rating absteigend sortierten Episodenstaffeln aus.
     ```sql
	
	SELECT AVG(imdb_rating) as durchschnitt, serienname, staffel 
		FROM episode 
		GROUP BY serienname, staffel 
		ORDER BY durchschnitt DESC;
    ```

7. Geben Sie aus, welche Serien aktuell nicht im TV ausgestrahlt werden.
     ```sql

	SELECT serienname 
		FROM serie s 
		WHERE s.serienname NOT IN 
			(SELECT serienname 
				FROM ausgestrahlt);
    ```

8. Bei welchen Serien ist der selbe Künstler Schauspieler und Stoffentwickler?
     ```sql

	SELECT s.serienname 
		FROM hauptschauspieler h JOIN serie s ON stoffentwickler_id = h.hauptschauspieler_id;
    ```

9. Geben Sie alle Schauspieler aus, welche in mehreren Serien mitspielen.
     ```sql

	SELECT COUNT(h.hauptschauspieler_id) AS anzahl, h.hauptschauspieler_id, k.vorname, k.nachname   
		FROM hauptschauspieler h 
			JOIN kuenstler k 
				ON h.hauptschauspieler_id = k.kuenstler_id 
		GROUP BY h.hauptschauspieler_id, k.vorname, k.nachname 
		HAVING COUNT(h.hauptschauspieler_id) > 1;
    ```

10. Geben Sie für jede Episode den Unterschied im Rating zur Vorgängerepisode (nur innerhalb der jeweiligen Staffel) an.
    ```sql

SELECT e2.serienname, e2.staffel, e2.episodennr,e2.titel, e2.imdb_rating, e2.imdb_rating - e1.imdb_rating AS vergleich  
		FROM episode e1, episode e2 
		WHERE e1.serienname = e2.serienname 
			AND e1.staffel = e2.staffel 
			AND (e2.episodennr -1 = e1.episodennr OR e2.episodennr = 1 AND e1.episodennr = 1 ) 
		ORDER BY e1.serienname, e1.staffel, e1.episodennr, e2.serienname, e2.staffel, e2.episodennr ASC;


/*zum nachvollziehen
	SELECT e1.serienname, e1.staffel, e1.episodennr,e2.titel, e2.episodennr, e1.imdb_rating, e2.imdb_rating, e2.imdb_rating - e1.imdb_rating AS vergleich  
		FROM episode e1, episode e2 
		WHERE e1.serienname = e2.serienname 
			AND e1.staffel = e2.staffel 
			AND (e2.episodennr -1 = e1.episodennr OR e2.episodennr = 1 AND e1.episodennr = 1 ) 
		ORDER BY e1.serienname, e1.staffel, e1.episodennr, e2.serienname, e2.staffel, e2.episodennr ASC;
*/
		
    ```
