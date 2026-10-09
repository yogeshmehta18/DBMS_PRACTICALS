-- 1. ADD ManagerID TO EMPLOYEE TABLE
ALTER TABLE Employee
ADD ManagerID INT NULL;

-- 2. ADD SELF-REFERENCING FOREIGN KEY
ALTER TABLE Employee
ADD CONSTRAINT fk_manager
FOREIGN KEY (ManagerID) REFERENCES Employee(EmpID);

-- 3. ASSIGN MANAGERS
SET ManagerID = CASE
    WHEN EmpID IN (1, 6, 11, 16, 21) THEN NULL

    WHEN EmpID BETWEEN 2 AND 5 THEN 1

    WHEN EmpID BETWEEN 7 AND 10 THEN 6

    WHEN EmpID BETWEEN 12 AND 15 THEN 11

    WHEN EmpID BETWEEN 17 AND 20 THEN 16

    WHEN EmpID BETWEEN 22 AND 25 THEN 21

     WHEN EmpID = 26 THEN 1

    WHEN EmpID = 27 THEN 6

    WHEN EmpID = 28 THEN 11

    WHEN EmpID = 29 THEN 16

    WHEN EmpID = 30 THEN 21
END;

-- 4. DISPLAY EMPLOYEE-MANAGER RELATIONSHIP
SELECT EmpID, EmpName, ManagerID
FROM Employee
ORDER BY EmpID;

-- 5. CREATE DEPARTMENT SALARY SUMMARY VIEW
CREATE VIEW DepartmentSalarySummary AS
SELECT
    DeptID,
    COUNT(*) AS TotalEmployees,
    SUM(Salary) AS TotalSalary,
    AVG(Salary) AS AverageSalary
FROM Employee
GROUP BY DeptID;

-- 6. DISPLAY DEPARTMENT SALARY SUMMARY
SELECT *
FROM DepartmentSalarySummary;

-- 7. CREATE EMPLOYEE HIERARCHY VIEW
CREATE VIEW EmployeeHierarchy AS
SELECT
    E.EmpID,
    E.EmpName,
    E.ManagerID,
    M.EmpName AS ManagerName
FROM Employee E
LEFT JOIN Employee M
    ON E.ManagerID = M.EmpID;

-- 8. DISPLAY EMPLOYEE HIERARCHY
SELECT *
FROM EmployeeHierarchy
ORDER BY EmpID;

-- 9. CREATE SIMPLE EMPLOYEE SALARY VIEW
CREATE VIEW EmployeeSalaryView AS
SELECT
    EmpID,
    EmpName,
    Salary
FROM Employee;

-- 10. UPDATE THE UPDATABLE VIEW
UPDATE EmployeeSalaryView
SET Salary = Salary + 1000
WHERE EmpID = 2;

-- 11. VERIFY UPDATED DATA
SELECT *
FROM EmployeeSalaryView
WHERE EmpID = 2;

-- 12. TEST DEPARTMENT SALARY SUMMARY VIEW
UPDATE DepartmentSalarySummary
SET AverageSalary = AverageSalary + 1000
WHERE DeptID = 101;

-- 13. RECURSIVE CTE FOR REPORTING LEVEL
WITH RECURSIVE EmployeeChain AS (

    -- Anchor query
    SELECT
        EmpID,
        EmpName,
        ManagerID,
        0 AS Level
    FROM Employee
    WHERE ManagerID IS NULL
    
    UNION ALL

    -- Recursive query
    SELECT
        E.EmpID,
        E.EmpName,
        E.ManagerID,
        EC.Level + 1
    FROM Employee E
    INNER JOIN EmployeeChain EC
        ON E.ManagerID = EC.EmpID
)

SELECT
    EmpID,
    EmpName,
    ManagerID,
    Level
FROM EmployeeChain
ORDER BY Level, EmpID;

-- 14. RECURSIVE CTE WITH REPORTING CHAIN
WITH RECURSIVE EmployeeChain AS (

    -- Anchor query:
    -- Start with top-level managers.
    SELECT
        EmpID,
        EmpName,
        ManagerID,
        CAST(EmpName AS CHAR(500)) AS ReportingChain
    FROM Employee
    WHERE ManagerID IS NULL

    UNION ALL

    SELECT
        E.EmpID,
        E.EmpName,
        E.ManagerID,
        CONCAT(
            EC.ReportingChain,
            ' -> ',
            E.EmpName
        )
    FROM Employee E
    INNER JOIN EmployeeChain EC
        ON E.ManagerID = EC.EmpID
)

SELECT
    EmpID,
    EmpName,
    ManagerID,
    ReportingChain
FROM EmployeeChain
ORDER BY EmpID;