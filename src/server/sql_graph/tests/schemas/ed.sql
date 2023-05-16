CREATE TABLE school (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL, 
  address VARCHAR(255) NOT NULL,
  city VARCHAR(255) NOT NULL,
  state VARCHAR(255) NOT NULL
);

CREATE TABLE class (
  id VARCHAR(255) PRIMARY KEY,
  name INT NOT NULL,
  school_id VARCHAR(255) NOT NULL,
  capacity INT NOT NULL,
  FOREIGN KEY (school_id) REFERENCES school(id)
);

CREATE TABLE student (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL, 
  fathers_name VARCHAR(255) NOT NULL,
  date_of_birth DATE NOT NULL,
  class_id VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE,
  phone VARCHAR(20),
  address VARCHAR(255),
  FOREIGN KEY (class_id) REFERENCES class(id)
);

CREATE TABLE subject (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  class_id VARCHAR(255) NOT NULL,
  max_marks INT NOT NULL,
  pass_marks INT NOT NULL,
  FOREIGN KEY (class_id) REFERENCES class(id)
);

CREATE TABLE mark (
  id VARCHAR(255) PRIMARY KEY,
  subject_id VARCHAR(255) NOT NULL,
  student_id VARCHAR(255) NOT NULL,
  assessment_type VARCHAR(255) NOT NULL,
  marks_obtained INT NOT NULL,
  CONSTRAINT student_subject_unique UNIQUE (student_id, subject_id, assessment_type),
  FOREIGN KEY (subject_id) REFERENCES subject(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE
);

CREATE TABLE attendance (
  id VARCHAR(255) PRIMARY KEY,
  date DATE NOT NULL,
  present BOOLEAN NOT NULL,
  student_id VARCHAR(255) NOT NULL,
  FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE
);

CREATE TABLE mid_day_meal (
  id VARCHAR(255) PRIMARY KEY,
  date DATE NOT NULL,
  present BOOLEAN NOT NULL,
  student_id VARCHAR(255) NOT NULL,
  FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE
);
