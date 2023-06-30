---Requirement 1: Entity Relationship Diagram: https://app.quickdatabasediagrams.com/#/d/Yt9uKR

--- Create table of departments
CREATE TABLE departments (
	dept_no VARCHAR(30) NOT NULL,
	dept_name VARCHAR(30) NOT NULL
);

--- Check to make sure that dept_nos are unique
SELECT COUNT(distinct dept_no), COUNT(dept_no)
FROM departments;

--- Use dept_no as index
ALTER TABLE departments
ADD PRIMARY KEY (dept_no);

--- Create table of dept_emp
CREATE TABLE dept_emp (
	emp_no integer NOT NULL,
	dept_no VARCHAR(30) NOT NULL
);

--- Check to make sure that emp_nos are unique
SELECT COUNT(distinct emp_no), COUNT(emp_no)
FROM dept_emp;

--- Because emp_nos are not unique, create a composite key of emp_no and dept_no
ALTER TABLE dept_emp
ADD PRIMARY KEY (emp_no, dept_no);

--- Create table of dept_manager
CREATE TABLE dept_manager (
	dept_no VARCHAR(30) NOT NULL,
	emp_no integer NOT NULL
);

--- Check to make sure that emp_nos are unique
SELECT COUNT(distinct emp_no), COUNT(emp_no)
FROM dept_manager;

--- Use emp_no as index
ALTER TABLE dept_manager
ADD PRIMARY KEY (emp_no);

--- Create table of employees; reading in dates as string for now
CREATE TABLE employees (
	emp_no integer NOT NULL,
	emp_title VARCHAR(30) NOT NULL,
	birth_date date NOT NULL,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	sex VARCHAR(30) NOT NULL,
	hire_date date NOT NULL
);

--- Check to make sure that emp_nos are unique
SELECT COUNT(distinct emp_no), COUNT(emp_no)
FROM employees;

--- Use emp_no as index
ALTER TABLE employees
ADD PRIMARY KEY (emp_no);

--- Create table of salaries
CREATE TABLE salaries (
	emp_no integer NOT NULL,
	salary integer NOT NULL
);

--- Check to be sure emp_no is unique
SELECT COUNT(distinct emp_no), COUNT(emp_no)
FROM salaries;

--- Create table of titles
CREATE TABLE titles (
	title_id VARCHAR(30) NOT NULL,
	title VARCHAR(30) NOT NULL
);

--- Check to make sure that title_ids are unique
SELECT COUNT(distinct title_id), COUNT(title_id)
FROM titles;

--- Use title_id as index
ALTER TABLE titles
ADD PRIMARY KEY (title_id);

---Add in foreign keys
ALTER TABLE salaries
ADD CONSTRAINT FK_emp_no
FOREIGN KEY (emp_no) REFERENCES employees(emp_no);

ALTER TABLE employees
ADD CONSTRAINT FK_emp_title
FOREIGN KEY (emp_title) REFERENCES titles(title_id);

ALTER TABLE dept_manager
ADD CONSTRAINT FK_dept_no
FOREIGN KEY (dept_no) REFERENCES departments(dept_no);

ALTER TABLE dept_manager
ADD CONSTRAINT FK_emp_no
FOREIGN KEY (emp_no) REFERENCES employees(emp_no);

ALTER TABLE dept_emp
ADD CONSTRAINT FK_dept_no
FOREIGN KEY (dept_no) REFERENCES departments(dept_no);

--- Step 1 of challenge: employee number, last name, first name, sex, salary
--- Join employee and salary tables matching on emp_no
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary 
FROM employees
INNER JOIN salaries ON employees.emp_no=salaries.emp_no;

--- Step 2 of challenge: first name, last name, hire date for employees hired in 1986
SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986;

/*Step 3 of challenge: 
department manager, department number, department name, employee number, last name, first name*/
SELECT 
	dept_manager.dept_no, 
	departments.dept_name, 
	employees.emp_no, 
	employees.last_name, 
	employees.first_name
FROM dept_manager
	INNER JOIN departments 
		ON dept_manager.dept_no=departments.dept_no
		INNER JOIN employees
			ON dept_manager.emp_no=employees.emp_no;

/*Step 4 of challenge:
List the department number for each employee along with 
that employee’s employee number, last name, first name, and department name.*/
SELECT 
	dept_emp.dept_no,
	dept_emp.emp_no,
	employees.last_name,
	employees.first_name,
	departments.dept_name
FROM dept_emp
	INNER JOIN employees
		ON dept_emp.emp_no=employees.emp_no
		INNER JOIN departments
			ON dept_emp.dept_no=departments.dept_no;

/*Step 5 of challenge:
List first name, last name, and sex of each employee 
whose first name is Hercules and whose last name begins with the letter B.*/
SELECT
	first_name,
	last_name,
	sex
FROM employees
	WHERE
		first_name IN ('Hercules') AND last_name LIKE('B%');

/*Step 6 of challenge:
List each employee in the Sales department, including their employee number, last name, and first name.*/
--- With inner join
SELECT
	employees.emp_no,
	employees.last_name,
	employees.first_name
FROM employees
	INNER JOIN dept_emp
		ON employees.emp_no=dept_emp.emp_no
		INNER JOIN departments
			ON dept_emp.dept_no=departments.dept_no
			WHERE departments.dept_name='Sales';

--- With subqueries
SELECT
	employees.emp_no,
	employees.last_name,
	employees.first_name
FROM employees
WHERE emp_no IN 
(
	SELECT emp_no 
	FROM dept_emp
	WHERE dept_no IN
	(
		SELECT dept_no 
		FROM departments
		WHERE dept_name = 'Sales'
	)
)	

/*Step 7 of challenge:
List each employee in the Sales and Development departments, 
including their employee number, last name, first name, and department name.*/
--- With inner join
SELECT
	employees.emp_no,
	employees.last_name,
	employees.first_name
FROM employees
	INNER JOIN dept_emp
		ON employees.emp_no=dept_emp.emp_no
		INNER JOIN departments
			ON dept_emp.dept_no=departments.dept_no
			WHERE 
				departments.dept_name='Sales'
				OR
				departments.dept_name='Development';

--- With subqueries
SELECT
	employees.emp_no,
	employees.last_name,
	employees.first_name
FROM employees
WHERE emp_no IN (
	SELECT emp_no FROM dept_emp WHERE dept_no IN(
		SELECT dept_no FROM departments WHERE 
		dept_name IN ('Sales', 'Development')
	)
)

/*Step 8 of challenge:
List the frequency counts, in descending order, of all the employee last names 
(that is, how many employees share each last name).*/
SELECT 
	last_name, 
	COUNT(last_name)
FROM employees
GROUP by last_name
ORDER by COUNT(last_name) DESC;


