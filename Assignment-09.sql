CREATE TABLE departments (
  dept_no VARCHAR(255) PRIMARY KEY NOT NULL,
  dept_name VARCHAR(255)
);

COPY departments(dept_no,dept_name) 
FROM '/Users/victordituro/class/Columbia/COLNYC20190716DATA/02-Homeworks/09-SQL/Instructions/data/departments.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM departments;

CREATE TABLE employees (
  emp_no INT PRIMARY KEY NOT NULL,
  birth_date DATE,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  gender CHAR,
  hire_date DATE);

COPY employees(emp_no,birth_date,first_name,last_name,gender,hire_date) 
FROM '/Users/victordituro/class/Columbia/COLNYC20190716DATA/02-Homeworks/09-SQL/Instructions/data/employees.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM employees;

CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR(255),
  from_date DATE,
  to_date DATE,
  FOREIGN KEY (emp_no) REFERENCES employees(emp_no));

COPY titles(emp_no, title, from_date, to_date) 
FROM '/Users/victordituro/class/Columbia/COLNYC20190716DATA/02-Homeworks/09-SQL/Instructions/data/titles.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM titles;

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(255),
	from_date DATE,
	to_date DATE,
  	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
  	FOREIGN KEY (dept_no) REFERENCES departments(dept_no));

COPY dept_emp(emp_no, dept_no, from_date, to_date) 
FROM '/Users/victordituro/class/Columbia/COLNYC20190716DATA/02-Homeworks/09-SQL/Instructions/data/dept_emp.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM dept_emp;

CREATE TABLE dept_manager (
	dept_no VARCHAR(255),
	emp_no INT NOT NULL,
	from_date DATE,
	to_date DATE,
  	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
  	FOREIGN KEY (dept_no) REFERENCES departments(dept_no));

COPY dept_manager(dept_no, emp_no, from_date, to_date) 
FROM '/Users/victordituro/class/Columbia/COLNYC20190716DATA/02-Homeworks/09-SQL/Instructions/data/dept_manager.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM dept_manager;

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE,
	to_date DATE,
  	FOREIGN KEY (emp_no) REFERENCES employees(emp_no));
	
COPY salaries(emp_no, salary, from_date, to_date) 
FROM '/Users/victordituro/class/Columbia/COLNYC20190716DATA/02-Homeworks/09-SQL/Instructions/data/salaries.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM salaries;

# 1. List the following details of each employee: employee number, last name, first name, geneder, and salary

SELECT e.emp_no, e.last_name, e.first_name, e.gender, s.salary FROM employees e, salaries s WHERE e.emp_no = s.emp_no;

# 2. List employees who were hired in 1986

SELECT e.emp_no, e.last_name, e.first_name, e.gender, e.hire_date, s.salary FROM employees e, salaries s WHERE e.emp_no = s.emp_no AND e.hire_date >= '1986-01-01' AND e.hire_date <= '1986-12-31';

# 3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.

SELECT d.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name, dm.from_date, dm.to_date
FROM departments d, dept_manager dm, employees e 
WHERE d.dept_no = dm.dept_no AND dm.emp_no = e.emp_no

# 4. List the department of each employee with the following information: employee number, last name, first name, and department name.

SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e, departments d, dept_emp de
WHERE de.to_date = '9999-01-01' AND de.emp_no = e.emp_no AND de.dept_no = d.dept_no
ORDER BY e.last_name, e.first_name

# 5. List all employees whose first name is "Hercules" and last names begin with "B"

SELECT e.last_name, e.first_name
FROM employees e
WHERE e.first_name = 'Hercules' AND SUBSTRING(e.last_name, 1, 1 ) = 'B'

# 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.

SELECT de.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e, departments d, dept_emp de
WHERE  de.to_date = '9999-01-01' AND de.dept_no = d.dept_no AND d.dept_name = 'Sales' AND de.emp_no = e.emp_no
ORDER BY e.last_name, e.first_name

# 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

SELECT de.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e, departments d, dept_emp de
WHERE  de.to_date = '9999-01-01' AND de.dept_no = d.dept_no AND d.dept_name IN('Sales','Development') AND de.emp_no = e.emp_no
ORDER BY d.dept_name, e.last_name, e.first_name

# 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

SELECT e.last_name, COUNT(e.last_name)
  FROM employees e
 GROUP BY e.last_name
 ORDER BY COUNT(e.last_name) DESC