-- 1. INNER JOIN
SELECT E.EmpName, D.DeptName
FROM Employee E
INNER JOIN Department D
ON E.DeptID = D.DeptID;


-- 2. LEFT JOIN
SELECT E.EmpName, D.DeptName
FROM Employee E
LEFT JOIN Department D
ON E.DeptID = D.DeptID;


-- 3. SELF-JOIN
SELECT E1.EmpName AS Employee1,
       E1.Salary AS Salary1,
       E2.EmpName AS Employee2,
       E2.Salary AS Salary2
FROM Employee E1
JOIN Employee E2
ON E1.Salary > E2.Salary;


-- 4. THREE-WAY JOIN
SELECT E.EmpName,
       D.DeptName,
       P.ProjectName,
       E.Salary
FROM Employee E
INNER JOIN Department D
ON E.DeptID = D.DeptID
INNER JOIN Project P
ON E.ProjectID = P.ProjectID;


-- 5. CORRELATED SUBQUERY
SELECT E.EmpName,
       E.Salary,
       E.DeptID
FROM Employee E
WHERE E.Salary > (
    SELECT AVG(E2.Salary)
    FROM Employee E2
    WHERE E2.DeptID = E.DeptID
);


-- 6. EXISTS
SELECT D.DeptID,
       D.DeptName
FROM Department D
WHERE EXISTS (
    SELECT 1
    FROM Employee E
    WHERE E.DeptID = D.DeptID
);


-- 7. SIMULATED INTERSECT
SELECT D.DeptID,
       D.DeptName
FROM Department D
WHERE EXISTS (
    SELECT 1
    FROM Employee E
    WHERE E.DeptID = D.DeptID
)
AND EXISTS (
    SELECT 1
    FROM Employee E
    WHERE E.DeptID = D.DeptID
    AND E.Salary > 70000
);


-- 8. SIMULATED EXCEPT
SELECT D.DeptID,
       D.DeptName
FROM Department D
WHERE EXISTS (
    SELECT 1
    FROM Employee E
    WHERE E.DeptID = D.DeptID
)
AND NOT EXISTS (
    SELECT 1
    FROM Employee E
    WHERE E.DeptID = D.DeptID
    AND E.Salary > 70000
);


-- 9.INNER JOIN
EXPLAIN
SELECT E.EmpName, D.DeptName
FROM Employee E
INNER JOIN Department D
ON E.DeptID = D.DeptID;


-- 10.LEFT JOIN
EXPLAIN
SELECT E.EmpName, D.DeptName
FROM Employee E
LEFT JOIN Department D
ON E.DeptID = D.DeptID;

-- 11.THREE-WAY JOIN
EXPLAIN
SELECT E.EmpName,
       D.DeptName,
       P.ProjectName
FROM Employee E
INNER JOIN Department D
ON E.DeptID = D.DeptID
INNER JOIN Project P
ON E.ProjectID = P.ProjectID;