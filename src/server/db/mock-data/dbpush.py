import pandas as pd
from sqlalchemy import create_engine

# Connect to the MySQL database
engine = create_engine('mysql://root:password@127.0.0.1:3306/a96bdef5-3e7e-411b-9e51-89bc47b4fa62')

# Read the CSV file into a pandas DataFrame
chunksize = 10000
for chunk in pd.read_csv('attendance_data.csv', chunksize=chunksize):
    print(f"Processing {chunksize} rows")
    # Push the chunk of data to the MySQL database table
    chunk.to_sql('attendance', engine, if_exists='append', index=False)

print("Data insertion complete")