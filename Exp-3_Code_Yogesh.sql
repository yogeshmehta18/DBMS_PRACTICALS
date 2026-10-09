-- 1. CREATE DATABASE
CREATE DATABASE CompanyDB;
USE CompanyDB;

-- 2. CREATE DEPARTMENT TABLE
CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL UNIQUE
);

-- 3. CREATE PROJECT TABLE
CREATE TABLE Project (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    Budget DECIMAL(12,2) NOT NULL
);

-- 4. CREATE EMPLOYEE TABLE
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    DeptID INT,
    ProjectID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);

-- 5.1 INSERT DEPARTMENT DATA
INSERT INTO Department (DeptID, DeptName) VALUES
(101, 'Computer Science'),
(102, 'Human Resources'),
(103, 'Finance'),
(104, 'Marketing'),
(105, 'Research and Development');

-- 5.2 INSERT PROJECT DATA
INSERT INTO Project (ProjectID, ProjectName, Budget) VALUES
(201, 'AI Chatbot', 800000),
(202, 'E-Commerce Platform', 1200000),
(203, 'Payroll Automation', 500000),
(204, 'Cyber Security System', 950000),
(205, 'Mobile Application', 700000),
(206, 'Data Analytics', 900000),
(207, 'Cloud Migration', 1100000),
(208, 'Research Portal', 650000);

-- 5.3 INSERT EMPLOYEE DATA
INSERT INTO Employee (EmpID, EmpName, Salary, DeptID, ProjectID) VALUES
(1, 'Aarav Sharma', 72000, 101, 201),
(2, 'Priya Singh', 65000, 101, 202),
(3, 'Rohan Verma', 58000, 101, 204),
(4, 'Ananya Gupta', 61000, 101, 206),
(5, 'Kunal Mehta', 55000, 101, 207),
(6, 'Neha Kapoor', 48000, 102, 203),
(7, 'Rahul Yadav', 52000, 102, 203),
(8, 'Sneha Jain', 60000, 102, 205),
(9, 'Amit Kumar', 45000, 102, 208),
(10, 'Ishita Roy', 57000, 102, 201),
(11, 'Vikas Gupta', 68000, 103, 206),
(12, 'Simran Kaur', 62000, 103, 202),
(13, 'Aditya Mishra', 59000, 103, 207),
(14, 'Pooja Agarwal', 51000, 103, 203),
(15, 'Mohit Tiwari', 73000, 103, 204),
(16, 'Nisha Sharma', 56000, 104, 205),
(17, 'Arjun Singh', 49000, 104, 201),
(18, 'Riya Malhotra', 63000, 104, 202),
(19, 'Varun Saxena', 54000, 104, 208),
(20, 'Tanya Bansal', 67000, 104, 206),
(21, 'Dev Patel', 75000, 105, 204),
(22, 'Meera Joshi', 66000, 105, 206),
(23, 'Sahil Khan', 58000, 105, 207),
(24, 'Kavya Nair', 70000, 105, 208),
(25, 'Manish Jain', 53000, 105, 201),
(26, 'Isha Verma', 46000, 101, 205),
(27, 'Yash Thakur', 50000, 102, 207),
(28, 'Aditi Sinha', 64000, 103, 208),
(29, 'Harsh Vardhan', 57000, 104, 204),
(30, 'Diya Agarwal', 69000, 105, 202);

-- 6.1 SELECTION
SELECT *
FROM Employee
WHERE Salary > 60000;

-- 6.2 PROJECTION
SELECT EmpName, Salary
FROM Employee;

-- 6.3 AGGREGATE FUNCTIONS
SELECT
    COUNT(*) AS TotalEmployees,
    SUM(Salary) AS TotalSalary,
    AVG(Salary) AS AverageSalary,
    MIN(Salary) AS MinimumSalary,
    MAX(Salary) AS MaximumSalary
FROM Employee;

-- 6.4 GROUP BY
SELECT DeptID, COUNT(*) AS EmployeeCount
FROM Employee
GROUP BY DeptID;

-- 6.5 GROUP BY WITH AVG()
SELECT DeptID, AVG(Salary) AS AverageSalary
FROM Employee
GROUP BY DeptID;

-- 6.6 HAVING
SELECT DeptID, AVG(Salary) AS AverageSalary
FROM Employee
GROUP BY DeptID
HAVING AVG(Salary) > 60000;

-- 6.7 CASE EXPRESSION
SELECT EmpName, Salary,
    CASE
        WHEN Salary >= 65000 THEN 'High'
        WHEN Salary >= 55000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryCategory
FROM Employee;

-- 6.8 ORDER BY
SELECT EmpName, Salary
FROM Employee
ORDER BY Salary DESC;