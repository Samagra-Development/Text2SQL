import pandas as pd
from sqlalchemy import create_engine
import sys

database = sys.argv[1]
print(database)

# Connect to the MySQL database
engine = create_engine(f'mysql+pymysql://root:password@localhost:3306/{database}')

files_table_config = {
    "school_data.csv" : "school",
    "class_data.csv" : "class",
    "subject_data.csv" : "subject",
    "student_data.csv" : "student",
    "marks_data.csv" : "mark",
    "attendance_data.csv" : "attendance",
    "mid_day_meal_data.csv" : "mid_day_meal"
}

# Read the CSV file into a pandas DataFrame
for key, value in files_table_config.items():
    print(key, value)
    chunksize = 10000
    for chunk in pd.read_csv(key, chunksize=chunksize):
        print(f"Processing {chunksize} rows")
        # Push the chunk of data to the MySQL database table
        chunk.to_sql(value, engine, if_exists='append', index=False)

    print("Data insertion completed for ", value)