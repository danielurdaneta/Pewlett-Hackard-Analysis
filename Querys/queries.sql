-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	emp_no INTEGER NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY(emp_no));
	
CREATE TABLE dept_manager (
	dept_no VARCHAR NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE  NOT NULL,
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
PRIMARY KEY (emp_no)
);

-- Change titles primary key
ALTER TABLE public.titles
    ADD CONSTRAINT pk_titles PRIMARY KEY (emp_no, title, to_date);
SELECT * FROM employees;

-- Make queries
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


SELECT first_name, last_name, emp_no
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create current employees table
SELECT r.first_name, r.last_name, r.emp_no, d.to_date
INTO current_emp
FROM retirement_info as r
LEFT JOIN dept_emp as d 
ON r.emp_no = d.emp_no
WHERE d.to_date = ('9999-01-01');


-- Joining departments and dept_manager tables
SELECT de.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as de
INNER JOIN dept_manager as dm
ON de.dept_no = dm.dept_no;

SELECT count(ce.emp_no), de.dept_no
INTO ret_emp_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no

-- Create employee info table
SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON e.emp_no = s.emp_no
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- Create manager info table
SELECT ma.dept_no, de.dept_name, ma.emp_no, ce.first_name, ce.last_name, ma.from_date, ma.to_date
INTO manager_info
FROM current_emp AS ce
INNER JOIN dept_manager AS ma
ON ce.emp_no = ma.emp_no
INNER JOIN departments AS de
ON ma.dept_no = de.dept_no

-- Create current retiring employees per department table
SELECT de.emp_no, ce.first_name, ce.last_name, d.dept_name
INTO ce_departments
FROM dept_emp as de
INNER JOIN current_emp as ce 
ON de.emp_no = ce.emp_no
INNER JOIN departments as d
ON de.dept_no = d.dept_no
ORDER BY dept_name

-- Create current retiring employees for sales and development department
SELECT *
INTO sales_devel_info
FROM ce_departments
WHERE dept_name IN ('Sales', 'Development'); 
