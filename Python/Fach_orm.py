from sqlalchemy import *
from sqlalchemy.orm import *

user = "emsa"
password = "saem8bYte"
dbname = "stsagraef" # postgres.fbi.h-da.de
server = "141.100.232.166"

# engine = create_engine("sqlite://", echo=True)
#engine = create_engine(f"postgresql+psycopg2://{user}:{password}@{server}/{dbname}", echo=False)
engine = create_engine("postgresql+psycopg2://emsa:saem8bYte@141.100.232.166/stsagraef", echo=False)

class Base(DeclarativeBase):
    pass


# This is the connection table for the M:N relationship between schliessfach and person.
sf_berechtigte = Table("tab_sf_berechtigte", Base.metadata,
                     Column("fach", ForeignKey(
                         "tab_schliessfach.sid"), primary_key=True),
                     Column("berechtigter", ForeignKey(
                         "tab_person.pid"), primary_key=True),
                     )


class Eigentuemer(Base):
    __tablename__ = "tab_eigentuemer"
    unternehmensname: Mapped[str] = mapped_column(String(50), primary_key=True)
    laendercode: Mapped[str] = mapped_column(String(5), nullable=False)

    eigentuemer_von: Mapped[list["Schliessfach"]] = relationship(
        back_populates="eigentuemer")

    def __init__(self, uname, land):
        self.unternehmensname = uname
        self.laendercode = land

    def __repr__(self) -> str:
        return f"{self.laendercode} - {self.unternehmensname}"


class Schliessfach(Base):
    __tablename__ = "tab_schliessfach"
    sid: Mapped[int] = mapped_column(primary_key=True)
    erstellungsdatum: Mapped[Date] = mapped_column(Date(), nullable=False)
    unternehmen: Mapped[str] = mapped_column(
        ForeignKey("tab_eigentuemer.unternehmensname"))

    eigentuemer: Mapped["Eigentuemer"] = relationship(
        back_populates="eigentuemer_von")

    berechtigte: Mapped[list["Person"]] = relationship(
        secondary=sf_berechtigte, back_populates="schliessfach")

    def __init__(self, datum, uname):
        self.erstellungsdatum = datum
        self.unternehmen = uname

    def __repr__(self) -> str:
        return f"{self.sid}, erstellt am: {self.erstellungsdatum}"


class Person(Base):
    __tablename__ = "tab_person"
    pid: Mapped[int] = mapped_column(primary_key=True)
    vorname: Mapped[str] = mapped_column(String(50), nullable=False)
    nachname: Mapped[str] = mapped_column(String(50), nullable=False)

    schliessfach: Mapped[list["Schliessfach"]] = relationship(
        secondary=sf_berechtigte, back_populates="berechtigte")

    def __init__(self, vname, nname):
        self.vorname = vname
        self.nachname = nname

    def __repr__(self) -> str:
        return f"{self.pid}: {self.vorname} {self.nachname}"

def db_fill():

    with Session(engine) as session:
        # 2 Eigentümer
        h_da = Eigentuemer("HS DA", "DEU")
        h_da_die = Eigentuemer("HS DA Dieburg", "DEU")
        tu = Eigentuemer("TU DA", "DEU")
        #
        session.add_all([h_da, h_da_die, tu])

        # 4 Schließfächer, min. 1 an mehrere Personen
        fach1 = Schliessfach("01-01-2010", "h_da")
        fach2 = Schliessfach("02-02-2020", "h_da")
        fach3 = Schliessfach("03-03-2003", "tu")
        fach4 = Schliessfach("04-04-2014", "tu")
        #
        h_da.eigentuemer_von.append(fach1)
        h_da.eigentuemer_von.append(fach2)
        tu.eigentuemer_von.append(fach3)
        tu.eigentuemer_von.append(fach4)

        # 3 Personen
        albus = Person("Albus", "Dumbledore")
        bellatrix = Person("Bellatrix", "Lestrange")
        charles = Person("Charles", "Dickens")
        donald = Person("Donald", "Duck")
        katniss = Person("Katniss", "Everdeen")
        #
        session.add_all([albus, bellatrix, charles, donald, katniss])

        fach1.berechtigte.append(albus)
        fach1.berechtigte.append(bellatrix)
        fach1.berechtigte.append(charles)
        #
        fach2.berechtigte.append(bellatrix)
        fach2.berechtigte.append(charles)
        #
        fach3.berechtigte.append(charles)
        #
        fach4.berechtigte.append(albus)
        #
        donald.schliessfach.append(fach4)
        #
        session.add_all([fach1, fach2, fach3, fach4])

        session.commit()

def print_menu():
    print(f"\n1: Ausgabe aller Eigentümer")
    print(f"2: Ausgabe aller Schließfächer eines Eigentümers (Eigentümer wird eingegeben)")
    print(f"3: Ausgabe aller Personen")
    print(f"4: Ausgabe aller Schließfächer eines Berechtigten (PersonenID wird eingegeben)")
    print(f"beliebige Taste: Programm beenden\n")

if __name__ == "__main__":
    # Drops all tables which belong to Entity classes which inherit from Base
    Base.metadata.drop_all(engine)

    # Create all tables which belong to Entity classes which inherit from Base
    Base.metadata.create_all(engine)

    db_fill()

    with Session(engine) as session:
        all_eigentuemer = select(Eigentuemer)
        all_Personen = select(Person)

        while true:
            print_menu()

            menu_input = input("Wähle aus (1-4): ")

            if menu_input == '1': # alle Eigentuemer
                eigentuemers = session.execute(all_eigentuemer)
                for eigentuemer in eigentuemers:
                    print(eigentuemer)

            elif menu_input == '2': # Faecher eines Eigentuemers(name string)
                eigentuemer_input = input("Gib den Unternehmensnamen ein: ")
                faecher = session.scalars(select(Schliessfach).where(Schliessfach.unternehmen == str(eigentuemer_input)))

                for fach in faecher:
                    print(fach)

            elif menu_input == '3': # alle Personen
                personen = session.execute(all_Personen)

                for person in personen:
                    print(person)

            elif menu_input == '4': # Faecher eines Berechtigten(id int)
                id_input = input("Gib eine Personen-ID ein: ")
                """
                # nicht vollständig
                faecher = session.scalars(select(Schliessfach.sid, Schliessfach.erstellungsdatum).
                                          join(Schliessfach.berechtigte).

                                          join(Person.schliessfach).
                                          where(Person.pid == int(id_input)))
                """

                # SELECT tab_schliessfach.sid, tab_schliessfach.erstellungsdatum FROM tab_schliessfach WHERE tab_schliessfach.sid IN (SELECT tab_sf_berechtigte.fach FROM tab_sf_berechtigte WHERE tab_sf_berechtigte.berechtigter = 6);

                sql_statement = text("SELECT tab_schliessfach.sid, tab_schliessfach.erstellungsdatum "
                         "FROM tab_schliessfach "
                         "WHERE tab_schliessfach.sid "
                         "IN (SELECT tab_sf_berechtigte.fach FROM tab_sf_berechtigte WHERE tab_sf_berechtigte.berechtigter = :input_pid)").bindparams(input_pid=id_input)
                faecher = session.execute(sql_statement)
                print(faecher.fetchall())
                

                for fach in faecher:
                    print(fach)

            else:
                break

