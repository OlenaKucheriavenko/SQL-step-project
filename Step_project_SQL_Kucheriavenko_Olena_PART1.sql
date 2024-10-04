/* 1. Покажіть середню зарплату співробітників за кожен рік, до 2005 року. */
SELECT 
    YEAR(from_date) AS report_year, 
    ROUND(AVG(salary),2) AS average_salary
FROM 
    salaries 
GROUP BY 
    report_year
HAVING 
    report_year BETWEEN MIN(report_year) AND 2005
ORDER BY 
    report_year;
    
/* 2. Покажіть середню зарплату співробітників по кожному відділу. Примітка: потрібно розрахувати по поточній зарплаті, та поточному відділу співробітників */
SELECT 
    d.dept_name AS department_name,
    ROUND(AVG(s.salary),2) AS average_salary
FROM 
    salaries s
INNER JOIN 
    dept_emp de ON s.emp_no = de.emp_no
INNER JOIN 
    departments d ON de.dept_no = d.dept_no
WHERE 
    CURRENT_DATE() BETWEEN s.from_date AND s.to_date
    AND CURRENT_DATE() BETWEEN de.from_date AND de.to_date
GROUP BY 
    d.dept_name
ORDER BY 
    average_salary DESC;
    
/* 3. Покажіть середню зарплату співробітників по кожному відділу за кожний рік */
SELECT 
    d.dept_name AS department_name,
    YEAR(s.from_date) AS year_,
    ROUND(AVG(s.salary), 2) AS average_salary
FROM 
    salaries s
INNER JOIN 
    dept_emp de ON s.emp_no = de.emp_no
INNER JOIN 
    departments d ON de.dept_no = d.dept_no
GROUP BY 
    d.dept_name, year_
ORDER BY 
    department_name, year_;
    
/* 4. Покажіть відділи в яких зараз працює більше 15000 співробітників. */
SELECT 
    d.dept_name AS department_name,
    COUNT(de.emp_no) AS employee_count
FROM 
    dept_emp de
INNER JOIN 
    departments d ON de.dept_no = d.dept_no
WHERE 
    CURRENT_DATE() BETWEEN de.from_date AND de.to_date
GROUP BY 
    d.dept_name
HAVING 
    employee_count > 15000
ORDER BY 
    employee_count;
    
/* 5. Для менеджера який працює найдовше покажіть його номер, відділ, дату прийому на роботу, прізвище */

SELECT dm.emp_no, d.dept_name, e.hire_date, e.last_name

FROM employees.employees AS e

INNER JOIN employees.dept_manager AS dm

ON (e.emp_no = dm.emp_no) AND (CURRENT_DATE() BETWEEN dm.from_date AND dm.to_date)

INNER JOIN employees.departments AS d 

ON (dm.dept_no = d.dept_no)

ORDER BY TIMESTAMPDIFF(DAY, e.hire_date, CURRENT_DATE()) DESC

LIMIT 1;

/* 6. Покажіть топ-10 діючих співробітників компанії з найбільшою різницею між їх зарплатою і середньою зарплатою в їх відділі.*/
-- Перший CTE для обчислення середньої зарплати по кожному відділу
 WITH DepartmentAvgSalaries AS (
    SELECT 
        de.dept_no,                     
        AVG(s.salary) AS avg_salary    
    FROM 
        dept_emp de
    INNER JOIN 
        salaries s ON de.emp_no = s.emp_no 
    WHERE 
        CURRENT_DATE() BETWEEN de.from_date AND de.to_date  -- умова по даті для dept_emp
        AND CURRENT_DATE() BETWEEN s.from_date AND s.to_date  -- умова по даті для salaries    
    GROUP BY 
        de.dept_no                     
),
-- Другий CTE для обчислення зарплат і різниці від середньої зарплати
EmployeeSalaryDifferences AS (
    SELECT 
        e.emp_no,                        
		CONCAT(e.first_name, ' ', e.last_name) AS full_name,                   
        s.salary,                        
        de.dept_no,                      
        ds.avg_salary,                   
        ROUND(s.salary - ds.avg_salary,2) AS difference 
    FROM 
        employees e
    INNER JOIN 
        dept_emp de ON e.emp_no = de.emp_no  
    INNER JOIN 
        salaries s ON e.emp_no = s.emp_no    
    INNER JOIN 
        DepartmentAvgSalaries ds ON de.dept_no = ds.dept_no 
    WHERE 
        CURRENT_DATE() BETWEEN de.from_date AND de.to_date  -- умова по даті для dept_emp
        AND CURRENT_DATE() BETWEEN s.from_date AND s.to_date  -- умова по даті для salaries           
)
SELECT -- Основний запит для вибору топ-10 співробітників з найбільшою різницею в зарплатах
    emp_no,                            
    full_name,                        
    salary,                            
    difference                               
FROM 
    EmployeeSalaryDifferences
ORDER BY 
    difference DESC                         
LIMIT 10; 

/*  7. Для кожного відділу покажіть другого по порядку менеджера. Необхідно вивести відділ, прізвище ім’я менеджера, 
дату прийому на роботу менеджера і дату коли він став менеджером відділу*/
WITH scnd_mng AS (
  SELECT dm.dept_no, dm.emp_no, dm.from_date, 
           ROW_NUMBER() OVER (PARTITION BY dm.dept_no ORDER BY dm.from_date) AS rnk
  FROM employees.dept_manager AS dm
)
SELECT sm.emp_no, sm.dept_no, CONCAT(e.first_name, ' ', e.last_name) AS full_name, e.hire_date, sm.from_date AS 'Became manager'
FROM scnd_mng AS sm
INNER JOIN employees.employees AS e 
    ON (sm.emp_no = e.emp_no)
WHERE rnk = 2;
