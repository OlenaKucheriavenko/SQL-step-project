CREATE DATABASE IF NOT EXISTS step_project;
USE step_project;
CREATE TABLE IF NOT EXISTS teachers (
    teacher_no INT PRIMARY KEY AUTO_INCREMENT,
    teacher_name VARCHAR(255) NOT NULL,
    phone_no VARCHAR(20) NOT NULL
);
CREATE TABLE IF NOT EXISTS courses (
    course_no VARCHAR(100),
    course_name VARCHAR(255) NOT NULL,
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (course_no, start_date) 
);
CREATE TABLE IF NOT EXISTS students (
    student_no INT PRIMARY KEY AUTO_INCREMENT,
    teacher_no INT NOT NULL,
    course_no VARCHAR(100) NOT NULL ,
    student_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    birth_date DATE,
    FOREIGN KEY (teacher_no) REFERENCES teachers(teacher_no) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (course_no) REFERENCES courses(course_no)
    ON UPDATE CASCADE ON DELETE RESTRICT 
);
SHOW TABLES;

START TRANSACTION;
INSERT INTO teachers (teacher_name, phone_no) VALUES
('John Smith', '+380 67 123 4567'),
('Emily Johnson', '+380 50 987 6543'),
('Michael Brown', '+380 93 234 5678'),
('Olivia Williams', '+380 66 876 5432');

SELECT teacher_name, phone_no
FROM teachers;

INSERT INTO courses (course_no, course_name, start_date, end_date) VALUES
('PRG01','Programming', '2024-01-10', '2024-06-10'),
('DA24','Data Analysis', '2024-02-01', '2024-07-01'),
('WB05','Web Development', '2024-03-01', '2024-08-01'),
('PY28','Python', '2024-04-01', '2024-08-01');

SELECT course_no, course_name, start_date, end_date
FROM courses;


INSERT INTO students (teacher_no, course_no, student_name, email, birth_date) VALUES
(1, 'PRG01', 'Emily Johnson', 'emily.johnson@sample.com', '2002-04-15'),
(1, 'DA24', 'Michael Davis', 'michael.davis@sample.com', '2001-08-22'),
(2, 'PRG01', 'Sophia Miller', 'sophia.miller@sample.com', '2003-02-11'),
(2, 'WB05', 'James Brown', 'james.brown@sample.com', '2000-05-09'),
(3, 'DA24', 'William Wilson', 'william.wilson@sample.com', '2002-10-30'),
(3, 'PY28', 'Olivia Taylor', 'olivia.taylor@sample.com', '2001-12-05'),
(4, 'WB05', 'Ava Anderson', 'ava.anderson@sample.com', '2003-03-21'),
(4, 'PY28', 'Noah Moore', 'noah.moore@sample.com', '2000-07-14'),
(1, 'PRG01', 'Emily Johnson', 'emily.johnson@sample.com', '2002-04-15'),
(1, 'DA24', 'Michael Davis', 'michael.davis@sample.com', '2001-08-22'),
(4, 'WB05', 'Ava Anderson', 'ava.anderson@sample.com', '2003-03-21'); 

SELECT teacher_no, course_no, student_name, email, birth_date
FROM students
LIMIT 3;

COMMIT;

SELECT 
    t.teacher_name, COUNT(s.student_no) AS student_count
FROM teachers t
	LEFT JOIN
    students s ON t.teacher_no = s.teacher_no
GROUP BY t.teacher_name;


SELECT student_name, email, birth_date, COUNT(*)
FROM students
GROUP BY student_name, email, birth_date
HAVING COUNT(*) > 1;
