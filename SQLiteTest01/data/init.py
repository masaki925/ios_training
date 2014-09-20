import sqlite3;
from datetime import datetime, date;

conn = sqlite3.connect('banklist.sqlite3')
c = conn.cursor()
c.execute('DROP TABLE IF EXISTS failed_banks')
c.execute('CREATE TABLE failed_banks(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, city TEXT, state TEXT, zip INTEGER, acq_institution TEXT, close_date TEXT, updated_date TEXT)')

def mysplit (string):
  quote = False
  retval = []
  current = ""
  for char in string:
    if char == '"':
      quote = not quote
    elif char == ',' and not quote:
      retval.append(current)
      current = ""
    else:
      current += char
  retval.append(current)
  return retval


data = open("banklist.csv", "r").readlines()[1:]
for entry in data:
  vals = mysplit(entry.strip())
  vals[5] = datetime.strptime(vals[5], "%d-%b-%y")
  vals[6] = datetime.strptime(vals[6], "%d-%b-%y")
  print "Inserting %s..." % (vals[0])
  sql = "INSERT INTO failed_banks VALUES(NULL, ?, ?, ?, ?, ?, ?, ?)"
  c.execute(sql, vals)

conn.commit()

