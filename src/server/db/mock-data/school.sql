CREATE TABLE school (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  type VARCHAR(255) NOT NULL, /* Primary 1 to 5 class, Secondary 6 to 10 class, Senior Secondary  */
  address VARCHAR(255) NOT NULL,
  city VARCHAR(255) NOT NULL,
  state VARCHAR(255) NOT NULL,
  latitude DECIMAL(10, 6),
  longitude DECIMAL(10, 6)
);

CREATE TABLE class (
  id VARCHAR(255) PRIMARY KEY,
  name INTEGER NOT NULL,
  school_id VARCHAR(255) NOT NULL REFERENCES school(id),
  capacity INTEGER NOT NULL
);

CREATE TABLE student (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  gender VARCHAR(255) NOT NULL,
  fathers_name VARCHAR(255) NOT NULL,
  date_of_birth DATE NOT NULL,
  class_id VARCHAR(255) NOT NULL REFERENCES class(id),
  email VARCHAR(255),
  phone VARCHAR(20),
  address VARCHAR(255)
);

CREATE TABLE subject (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  class_id VARCHAR(255) NOT NULL REFERENCES class(id),
  max_marks INTEGER NOT NULL,
  pass_marks INTEGER NOT NULL
);


CREATE TABLE mark (
  id VARCHAR(255) PRIMARY KEY,
  subject_id VARCHAR(255) NOT NULL,
  student_id VARCHAR(255) NOT NULL,
  assessment_type VARCHAR(255) NOT NULL, /* assessment types can be "UT-1", "UT-2", "UT-3", "HY", "FA" */
  marks_obtained INTEGER NOT NULL,
  CONSTRAINT student_subject_unique UNIQUE (student_id, subject_id, assessment_type),
  FOREIGN KEY (subject_id) REFERENCES subject(id),
  FOREIGN KEY (student_id) REFERENCES student(id)
);


CREATE TABLE attendance (
  id VARCHAR(255) PRIMARY KEY,
  date DATE NOT NULL,
  present BOOLEAN NOT NULL,
  student_id VARCHAR(255) NOT NULL REFERENCES student(id)
);

/* The Mid Day Meal Scheme is a school meal programme in India designed to better the nutritional standing of school-age children nationwide. */ 
CREATE TABLE mid_day_meal (
  id VARCHAR(255) PRIMARY KEY,
  date DATE NOT NULL,
  present BOOLEAN NOT NULL,
  student_id VARCHAR(255) NOT NULL REFERENCES student(id)
);
