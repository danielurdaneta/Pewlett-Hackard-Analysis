# Pewlett-Hackard Analysis

## Overview of the analysis

The purpose of this project was to analyze Pewlett-Hackard database and deliver valuable insight to the manegment. This database contains the company information as employee name, salary, title, department, among others. We did this using SQL in PostgreSQL.

## Results

- In the following code we select the column emp_no (employee number) and the column title from te table "unique_table", then create a table named "retiring_titles" grouping by titles and ordering the table by the count column in a descending order

```
SELECT COUNT(emp_no), title
INTO retiring_titles
FROM unique_table
GROUP BY title
ORDER BY count DESC;

```
This query deliver the amount of employees that are about to retire per position:

![retiring_titles](https://user-images.githubusercontent.com/81272629/121216730-cc8d2480-c846-11eb-8c02-076809d51669.png)

From this query we can extract the following information:

1-  Most of the employees who are about to retire have Senior positions, for this reason, the company must begin to train or hire personnel for these more qualified positions. 

2- There is only 2 employees in a manager position about to retire, for this reason, it may not be worth it to include managers in the mentorship program.

3- Adding up the employees of all departments, we can see there is 90,398 employees about to retire.


- In the following code we create a mentorship_eligibility table which deliver current employees with enough experience to be eligible for a mentorship program, as well as their birth date, title and dates within the company 
```
SELECT DISTINCT ON(e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date, de.from_date, de.to_date, ti.title
INTO mentorship_eligibilty
FROM employees as e
INNER JOIN dept_emp as de 
ON e.emp_no = de.emp_no
INNER JOIN titles as ti
ON e.emp_no = ti.emp_no
WHERE (de.to_date = '9999-01-01') AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;
```
From this query we can extract the following information:

1- In this table are 1549 employees, with this insight the company's management is able to make decision about the nature of the mentoring program they want to set 

## Summary

- How many roles will need to be filled as the "silver tsunami" begins to make an impact?

Adding up the employees of all departments, we can see there is 90,398 employees about to retire.

- Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?
There are 1,549 employees eligibles for the mentoring program and 90,398 employees about to retire, assuming that 100% of all elegible employees accept to enter the mentoring program it would be 58 employees per mentor, which may not be enough. 

For further insight we can evaluate the following questions:

- As the Development department is the one with most retiring employees, how many employees of this department are elegible for the mentoring program?

Using the following code we filter the information we need:
```
SELECT COUNT(me.emp_no), d.dept_name
FROM mentorship_eligibilty as me
INNER JOIN dept_emp as de
ON me.emp_no = de.emp_no
INNER JOIN departments as d 
ON de.dept_no = d.dept_no
GROUP BY d.dept_name
ORDER BY count DESC
```
And retrieve the following table:

![retiring_titles](https://user-images.githubusercontent.com/81272629/121222010-c483b380-c84b-11eb-8dbd-ebb78b6bf3ce.png)

As we can see, the Development department is the one with most employees eligible for the mentoring program, for this reason, they may be enough to satisfy the demand of future vacants

- 



