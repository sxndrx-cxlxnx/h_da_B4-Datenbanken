# This is a sample Python script.
from sqlalchemy import *

# Press Umschalt+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.


def print_hi(name):
    # Use a breakpoint in the code line below to debug your script.
    print(f'Hi, {name}')  # Press Strg+F8 to toggle the breakpoint.


# Press the green button in the gutter to run the script.
if __name__ == '__main__':

    engine = create_engine("postgresql+psycopg2://user:pass@141.100.70.93/dbname", echo=False)
    with engine.connect() as con:  # ensures Connection gets properly closed at the end of the block
        s = text("Select * from buch")  # creates sqlalchemy query object
    result = con.execute(s)
    for row in result:
        print(row)  # prints the whole row as a tuple
    s = text("Select isbn, titel from buch")
    result = con.execute(s)
    print(result.fetchall())  # fetches all rows as a list and prints it
    s = text("Select * from buch where verlegt_Name = 'Verlag 4'")
    result = con.execute(s)
    for row in result:
        print(row.isbn)  # prints only isbn
