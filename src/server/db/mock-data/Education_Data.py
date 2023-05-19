#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import numpy as np
import pandas as pd
import random as rnd
from datetime import datetime, timedelta
import random
import os
from faker import Faker
from geopy.geocoders import Nominatim
from geopy.extra.rate_limiter import RateLimiter
from geopy.distance import great_circle
import time

# In[ ]:

def generateId(prefix, df):
    # Load the CSV file with school names
    schools_df = df

    # Generate unique IDs for the schools
    school_ids = []
    for i in range(len(schools_df)):
        school_id = prefix + str(i+1).zfill(6)
        school_ids.append(school_id)
    
    return school_ids

def generateSchoolData(num_schools=10000):
    # Load cities from the CSV file
    cities_data = pd.read_csv("./Datasets/cities.csv")
    cities_data = cities_data[cities_data["country"] == "India"]
    all_cities = cities_data["city_ascii"].str.upper().tolist()

    # Load CBSE and ICSE schools data
    cbse_school = pd.read_csv("./Datasets/cbse_schools_data-master/cbse_school_cleaned.csv")[["name", "state", "city", "address", "latitude", "longitude"]]
    icse_school = pd.read_csv("./Datasets/cisce_schools_data-master/icse_school_cleaned.csv")[["name", "state", "city", "address", "latitude", "longitude"]]

    # Replace newline characters and extra commas in name and address columns
    cbse_school['name'] = cbse_school['name'].str.replace('\n', ' ')
    cbse_school['address'] = cbse_school['address'].str.replace('\n', ' ')
    icse_school['name'] = icse_school['name'].str.replace('\n', ' ')
    icse_school['address'] = icse_school['address'].str.replace('\n', ' ')

    cbse_school['name'] = cbse_school['name'].str.replace('\n ', ' ')
    cbse_school['address'] = cbse_school['address'].str.replace('\n ', ' ')
    icse_school['name'] = icse_school['name'].str.replace('\n ', ' ')
    icse_school['address'] = icse_school['address'].str.replace('\n ', ' ')

    
    # Group the cities by state and get the largest city in each state as a fallback city
    largest_cities = cities_data.groupby('admin_name')['population'].idxmax()
    fallback_cities = dict(zip(cities_data.loc[largest_cities, 'admin_name'], cities_data.loc[largest_cities, 'city_ascii']))

    # Combine CBSE and ICSE schools data
    cbse_school.reset_index(drop=True, inplace=True)
    icse_school.reset_index(drop=True, inplace=True)
    schools = pd.concat([cbse_school, icse_school], ignore_index=True, sort=False)

    if num_schools <= len(schools):
        schools = schools.sample(n=num_schools)
    
    # List of school types
    school_types = ['Primary School', 'Middle School', 'High School', 'Senior Secondary School']

    # Generate a random type for each school
    schools['type'] = [random.choice(school_types) for _ in range(len(schools))]


    # Convert the first letter of each word to uppercase
    schools['name'] = schools['name'].apply(lambda x: x.title() if x else None)
    schools['address'] = schools['address'].apply(lambda x: x.title() if x else None)
    schools['city'] = schools['city'].apply(lambda x: x.title() if x else None)
    schools['state'] = schools['state'].apply(lambda x: x.title() if x else None)

    # Assuming you have a generateId function that takes the prefix and the DataFrame as arguments
    schools["id"] = generateId("SC", schools)
    schools.to_csv("school_data.csv", index=False)


# In[ ]:


import numpy as np
import pandas as pd

def generateNamesAndGender(num_students):
    first_names = pd.read_csv("./Datasets/FirstNames.csv")
    last_names = pd.read_csv("./Datasets/indian_caste_data.csv")
    
    # Generate random names by combining first and last names randomly
    names_and_genders = []
    for _ in range(num_students):
        # randomly choose a row from the first_names DataFrame
        random_row = first_names.sample()
        first_name = random_row['first_name'].values[0]
        gender = "Male" if random_row['Gender'].values[0] == 0 else "Female"
        
        last_name = np.random.choice(last_names['last_name'])
        full_name = first_name + ' ' + last_name
        
        names_and_genders.append((full_name, gender))
    
    return names_and_genders



# In[ ]:


def generateFakeAddress(student_count):
    fake = Faker('en_IN') # Set the Faker locale to India

    up_cities = [
        "Agra", "Aligarh", "Allahabad", "Amroha", "Auraiya", "Azamgarh", "Baghpat", "Bahraich",
        "Ballia", "Balrampur", "Banda", "Barabanki", "Bareilly", "Basti", "Bhadohi", "Bijnor",
        "Budaun", "Bulandshahr", "Chandauli", "Chitrakoot", "Deoria", "Etah", "Etawah", "Faizabad",
        "Farrukhabad", "Fatehpur", "Firozabad", "Gautam Buddha Nagar", "Ghaziabad", "Ghazipur",
        "Gonda", "Gorakhpur", "Hamirpur", "Hardoi", "Hathras", "Jalaun", "Jaunpur", "Jhansi",
        "Kannauj", "Kanpur Dehat", "Kanpur Nagar", "Kasganj", "Kaushambi", "Kheri", "Kushinagar",
        "Lalitpur", "Lucknow", "Maharajganj", "Mahoba", "Mainpuri", "Mathura", "Mau", "Meerut",
        "Mirzapur", "Moradabad", "Muzaffarnagar", "Pilibhit", "Pratapgarh", "Raebareli", "Rampur",
        "Saharanpur", "Sambhal", "Sant Kabir Nagar", "Shahjahanpur", "Shamli", "Shrawasti",
        "Siddharthnagar", "Sitapur", "Sonbhadra", "Sultanpur", "Unnao", "Varanasi"
    ]

    # Generate 1000 fake addresses for Uttar Pradesh
    addresses = []
    for i in range(student_count):
        city = random.choice(up_cities)
        address = fake.building_number() + ', ' + fake.street_name() + ', ' + fake.city_name() + ', ' + city + ', Uttar Pradesh, India, ' + fake.postcode()
        addresses.append(address)
    
    return addresses


# In[ ]:


def generatePhoneNo(student_count):
    fake = Faker('en_IN') # Set the Faker locale to India

    # Generate phone numbers for Indian people
    phone_numbers = []
    for i in range(student_count):
        phone_number = '+91' + str(fake.random_int(min=6000000000, max=9999999999))
        phone_numbers.append(phone_number)
    
    return phone_numbers


# In[ ]:


def generateEmailId(names):
    fake = Faker()

    # Generate email addresses based on the names
    emails = []
    for name in names:
        name_arr = name.lower().split()
        first_name = name_arr[0] 
        last_name = name_arr[-1]
        email = first_name + '.' + last_name + '@' + fake.free_email_domain()
        emails.append(email)
    
    return emails


# In[ ]:


def generateFatherName(names):
    # Load the CSV file with male first names
    male_first_names_df = pd.read_csv('./Datasets/Indian-Male-Names.csv')

    # Create a DataFrame with kids names
    kids_names_df = pd.DataFrame(names, columns=['name'])

    # Extract the last names from kids_names_df
    kids_names_df['kid_last_name'] = kids_names_df['name'].apply(lambda x: x.split()[-1])

    # Generate father's names based on the last name of the kid and a random male first name
    father_names = []
    for last_name in kids_names_df['kid_last_name']:
        male_first_name = np.random.choice(male_first_names_df['name'])
        father_name = str(male_first_name) + ' ' + last_name
        father_names.append(father_name)

    return father_names


# In[ ]:


def generateDOB(students_df, class_name):
    # Generate random dates of birth for students based on the class age range
    class_age_map = {
        '1': (5, 6),
        '2': (6, 7),
        '3': (7, 8),
        '4': (8, 9),
        '5': (9, 10),
        '6': (10, 11),
        '7': (11, 12),
        '8': (12, 13),
        '9': (13, 14),
        '10': (14, 15),
        '11': (15, 16),
        '12': (16, 18)
    }

    birth_dates = []
    for i in range(len(students_df)):
        age_range = class_age_map[str(class_name)]
        age = random.randint(age_range[0], age_range[1])
        today = datetime.now()
        start_date = today - timedelta(days=age*365)
        end_date = today - timedelta(days=(age-1)*365)
        random_date = start_date + (end_date - start_date) * random.random()
        birth_date = random_date.strftime('%Y-%m-%d')
        birth_dates.append(birth_date)
    return birth_dates


# In[ ]:


# df = pd.DataFrame(columns = ["id", "name", "fathers_name", "date_of_birth", "class_id", "email", "phone", "address"])
# # Define a function to generate a random number of students between 25 and the capacity of the class
# def generateStudentCount(row):
#     return random.randint(25, row['capacity'])

# def generateStudentData():
#     # Load the class data from the CSV file
#     class_df = pd.read_csv('class_data.csv')
#     for index, row in class_df.iterrows():
#         student_count = generateStudentCount(row)
#         class_id = row['id']
#         class_name = row['name']
#         school_id = row['school_id']
#         print(f'Generating {student_count} students for {class_name} ({class_id}) at school {school_id}...')
#         names = generateNames(student_count)
#         df["name"] = pd.Series(names)
#         df["fathers_name"] = pd.Series(generateFatherName(names))
#         df["email"] = pd.Series(generateEmailId(names))
#         df["phone"] = pd.Series(generatePhoneNo(student_count))
#         df["address"] = pd.Series(generateFakeAddress(student_count))
#         df["id"] = pd.Series(generateId("ST", df))
#         df["date_of_birth"] = pd.Series(generateDOB(df, class_name))
#     df.to_csv("student_data.csv", index=False)


# In[ ]:


def generateClassData():
    # Load the CSV file with school data
    schools_df = pd.read_csv('school_data.csv')
    
    # Create a list to store class data
    class_data = []

    # Loop through each school in schools_df
    for i, row in schools_df.iterrows():
        school_type = row['type']
        class_range = None
        
        # Determine the class range based on the school type
        if school_type == 'Primary School':
            class_range = range(1, 6)  # 1 to 5
        elif school_type == 'Middle School':
            class_range = range(1, 9)  # 1 to 8
        elif school_type == 'High School':
            class_range = range(1, 11)  # 1 to 10
        elif school_type == 'Senior Secondary School':
            class_range = range(1, 13)  # 1 to 12
        
        # Create class data for each class in the determined range
        if class_range:
            for class_num in class_range:
                class_dict = {
                    'name': str(class_num),
                    'school_id': row['id'],
                    'capacity': 50
                }
                class_data.append(class_dict)

    # Create a DataFrame with class data
    class_df = pd.DataFrame(class_data)
    
    # Assuming you have a generateId function that takes the prefix and the DataFrame as arguments
    class_df["id"] = generateId("CL", class_df)
    
    # Save the class DataFrame to a new CSV file
    class_df.to_csv('class_data.csv', index=False)


# In[ ]:


def generateSubjectData():
    # Load the CSV file with class data
    class_df = pd.read_csv('class_data.csv')

    # Create a list of subjects for classes <= 3
    subjects_3 = ['HINDI', 'ENGLISH', 'MATHS']

    # Create a list of subjects for classes > 3
    subjects_4 = ['HINDI', 'ENGLISH', 'MATHS', 'SCIENCE', 'SOCIAL SCIENCE']

    # Create a list to store subject data
    subject_data = []

    # Loop through each class in class_df
    for i, row in class_df.iterrows():
        # Get the class name and convert it to an integer
        class_name = int(row['name'])

        # Assign subjects based on the class name
        if class_name <= 3:
            subjects = subjects_3
        else:
            subjects = subjects_4

        # Loop through each subject and create a dictionary with subject data
        for subject in subjects:
            subject_dict = {
                'name': subject,
                'class_id': row['id'],
                'max_marks': 100,
                'pass_marks': 35
            }
            # Append the subject data to subject_data list
            subject_data.append(subject_dict)

    # Create a DataFrame with subject data
    subject_df = pd.DataFrame(subject_data)
    subject_df["id"] = generateId("SB", subject_df)
    # Save the subject DataFrame to a new CSV file
    subject_df.to_csv('subject_data.csv', index=False)


# In[ ]:


def generateStudents():
    class_df = pd.read_csv("class_data.csv")
    students_df = pd.DataFrame(columns=['name', 'gender', 'fathers_name', 'date_of_birth', 'class_id', 'email', 'phone', 'address'])
    class_age_map = {
        '1': (5, 6),
        '2': (6, 7),
        '3': (7, 8),
        '4': (8, 9),
        '5': (9, 10),
        '6': (10, 11),
        '7': (11, 12),
        '8': (12, 13),
        '9': (13, 14),
        '10': (14, 15),
        '11': (15, 16),
        '12': (16, 18)
    }
    for index, row in class_df.iterrows():
        class_name = row['name']
        class_id = row['id']
        capacity = row['capacity']
        num_students = random.randint(25, capacity)

        # Generate fake names and addresses for students
        names_and_genders = generateNamesAndGender(num_students)
        names, genders = zip(*names_and_genders)
        addresses = generateFakeAddress(num_students)

        # Generate fathers names based on kids names
        fathers_names = generateFatherName(names)

        # Generate date of birth for students based on class age range
        class_age_range = class_age_map[str(class_name)]
        birth_dates = generateDOB(names, str(class_name))

        # Generate fake email IDs and phone numbers for students
        email_ids = generateEmailId(names)
        phone_nos = generatePhoneNo(num_students)
        
        # Create a DataFrame for the students of this class
        students = pd.DataFrame({
            'name': names,
            'gender': genders,
            'fathers_name': fathers_names,
            'date_of_birth': birth_dates,
            'class_id': class_id,
            'email': email_ids,
            'phone': phone_nos,
            'address': addresses
        })

        students_df = pd.concat([students_df, students], ignore_index=True)
    
    students_df["id"] = pd.Series(generateId("ST", students_df))
    students_df.to_csv("student_data.csv", index=False)
    return students_df


# In[ ]:


def generateMarksData():

    # read class data
    class_data = pd.read_csv('class_data.csv')

    # read subject data
    subject_data = pd.read_csv('subject_data.csv')

    # read student data
    student_data = pd.read_csv('student_data.csv')

    # create a dictionary mapping subject name and class id to subject id
    subject_id_map = {}
    for i, row in subject_data.iterrows():
        subject_id_map[(row['name'], row['class_id'])] = row['id']

    # set batch size
    batch_size = 1000

    # generate marks data for each batch of students
    for i in range(0, len(student_data), batch_size):
        # get batch of students
        students_batch = student_data.iloc[i:i+batch_size]

        # create empty dataframe for marks data
        marks_data = pd.DataFrame(columns=['subject_id', 'student_id', 'assessment_type', 'marks_obtained'])

        # generate marks data for each subject in the batch
        for j, student in students_batch.iterrows():
            class_id = student['class_id']
            subjects = ['HINDI', 'ENGLISH', 'MATHS', 'SCIENCE', 'SOCIAL SCIENCE'] \
                if int(class_data[class_data['id'] == class_id]['name'].iloc[0]) > 3 \
                else ['HINDI', 'ENGLISH', 'MATHS']
            for subject_name in subjects:
                if subject_id_map.get((subject_name, class_id)) is None:
                    continue
                subject_id = subject_id_map[(subject_name, class_id)]
                max_marks = subject_data[(subject_data['name'] == subject_name) & (subject_data['class_id'] == class_id)]['max_marks'].iloc[0]
                for assessment_type in ["UT-1", "UT-2", "UT-3", "HY", "FA"]:
                    marks = np.random.randint(0, max_marks+1)
                    marks_data = marks_data.append({
                        'subject_id': subject_id,
                        'student_id': student['id'],
                        'assessment_type': assessment_type,
                        'marks_obtained': marks
                    }, ignore_index=True)

        # write marks data for batch to csv
        marks_data.to_csv('marks_data.csv', mode='a', index=False, header=(i == 0))

        # clear marks data from memory
        del marks_data
    marks_data = pd.read_csv("marks_data.csv")
    marks_data["id"] = pd.Series(generateId("MR", marks_data))
    marks_data.to_csv('marks_data.csv', index=False)


# In[ ]:


def generateAttendanceData():
    # Load student data and class data
    student_data = pd.read_csv("student_data.csv")
    class_data = pd.read_csv("class_data.csv")

    # Academic year start and end dates
    start_date = datetime(2022, 4, 4)
    end_date = datetime(2023, 2, 15)

    # Generate dates for the academic year excluding Sundays
    dates = []
    current_date = start_date
    while current_date <= end_date:
        if current_date.weekday() != 6:  # Exclude Sunday
            dates.append(current_date)
        current_date += timedelta(days=1)

    # Generate attendance records
    attendance_records = []

    for student_id in student_data['id']:
        for date in dates:
            attendance = {
                'date': date,
                'present': random.choice([True, False]),
                'student_id': student_id
            }
            attendance_records.append(attendance)

    # Create DataFrame from attendance records
    attendance_df = pd.DataFrame(attendance_records)
    attendance_df["id"] = pd.Series(generateId("AT", attendance_df))
    # Save the attendance data to a CSV file
    attendance_df.to_csv('attendance_data.csv', index=False)


# In[ ]:


def generate_mid_day_meal_data():
    # Set the paths to the input and output CSV files
    school_data = 'school_data.csv'
    class_data = 'class_data.csv'
    student_data = 'student_data.csv'
    attendance_data = 'attendance_data.csv'
    output_file = 'mid_day_meal_data.csv'
    
    # Read the CSV files
    schools_df = pd.read_csv(school_data)
    classes_df = pd.read_csv(class_data)
    students_df = pd.read_csv(student_data)
    attendance_df = pd.read_csv(attendance_data)
    
    # Choose schools for mid_day_meal
    selected_schools = random.sample(list(schools_df['id']), k=int(0.525 * len(schools_df)))
    
    # Filter classes and students based on selected schools
    selected_classes = classes_df[classes_df['school_id'].isin(selected_schools)]
    selected_students = students_df[students_df['class_id'].isin(selected_classes['id'])]
    
    # Merge attendance and selected students data
    attendance_student = attendance_df.merge(selected_students, left_on='student_id', right_on='id', how='inner')
    
    # Create mid_day_meal data based on attendance
    attendance_student['mid_day_meal'] = attendance_student['present']
    
    # Create mid_day_meal_data.csv
    mid_day_meal_data = attendance_student[['id_x', 'date', 'mid_day_meal', 'student_id']]
    mid_day_meal_data.columns = ['id', 'date', 'present', 'student_id']
    mid_day_meal_data['id'] = pd.Series(generateId("MD", mid_day_meal_data))
    mid_day_meal_data.to_csv(output_file, index=False)


# In[ ]:

startTime = time.time()
generateSchoolData(50)
generateClassData()
generateSubjectData()
generateStudents()
generateMarksData()
generateAttendanceData()
generate_mid_day_meal_data()
endTime = time.time()
print(endTime - startTime)

# In[ ]:


import pandas as pd

def create_insert_statements(df, table_name):
    insert_statements = []
    for index, row in df.iterrows():
        columns = ', '.join(df.columns)
        values = ', '.join([f"'{value}'" if isinstance(value, str) else str(value) for value in row])
        insert_statement = f"INSERT INTO {table_name} ({columns}) VALUES ({values});"
        insert_statements.append(insert_statement)
    return insert_statements

# Load the CSV file into a DataFrame
# attendance_df = pd.read_csv('attendance_data.csv')

# Create INSERT INTO statements
# table_name = 'attendance'
# insert_statements = create_insert_statements(attendance_df, table_name)

# Write the INSERT INTO statements to a file
# with open('attendance_insert_statements.sql', 'w') as f:
#     for statement in insert_statements:
#         f.write(statement + '\n')


# In[ ]:




