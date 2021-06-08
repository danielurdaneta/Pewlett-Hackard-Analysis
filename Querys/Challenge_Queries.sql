-- Create a table with retirement employees and their title
SELECT e.emp_no, e.first_name, e.last_name, ti.title, ti.from_date, ti.to_date
INTO Retirement_titles
FROM employees as e
INNER JOIN titles as ti 
ON ti.emp_no = e.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY e.emp_no 

SELECT * FROM retirement_titles

-- Create a table with unique employees with most recent job title 
SELECT DISTINCT ON(emp_no) emp_no, first_name, last_name, title
INTO unique_table
FROM retirement_titles
ORDER BY emp_no, to_date DESC

-- Count number of employees per title
SELECT COUNT(emp_no), title
INTO retiring_titles
FROM unique_table
GROUP BY title
ORDER BY count DESC

-- Create a table with current employees elegibles for mentorship
SELECT DISTINCT ON(e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date, de.from_date, de.to_date, ti.title
INTO mentorship_eligibilty
FROM employees as e
INNER JOIN dept_emp as de 
ON e.emp_no = de.emp_no
INNER JOIN titles as ti
ON e.emp_no = ti.emp_no
WHERE (de.to_date = '9999-01-01') AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

-- Get unique emp_no values from the dept_emp table

SELECT DISTINCT ON(emp_no) emp_no, dept_no
INTO unique_table2
FROM dept_emp
ORDER BY emp_no, to_date DESC

-- Get the eligible employees by department

SELECT COUNT(me.emp_no), d.dept_name
FROM mentorship_eligibilty as me
INNER JOIN unique_table2 as de
ON me.emp_no = de.emp_no
INNER JOIN departments as d 
ON de.dept_no = d.dept_no
GROUP BY d.dept_name
ORDER BY count DESC