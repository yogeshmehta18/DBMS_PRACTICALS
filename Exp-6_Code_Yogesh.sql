-- 1. CREATE SALARY AUDIT TABLE
CREATE TABLE SalaryAudit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    EmpID INT NOT NULL,
    OldSalary DECIMAL(10,2),
    NewSalary DECIMAL(10,2),
    ChangedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. CREATE SALARY VALIDATION TRIGGER FOR INSERT
DELIMITER //

CREATE TRIGGER ValidateEmployeeSalary
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.Salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be greater than zero';
    END IF;
END //

DELIMITER ;

-- 3. CREATE SALARY VALIDATION TRIGGER FOR UPDATE
DELIMITER //

CREATE TRIGGER ValidateSalaryUpdate
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.Salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be greater than zero';
    END IF;
END //

DELIMITER ;

-- 4. CREATE SALARY AUDIT TRIGGER
DELIMITER //

CREATE TRIGGER SalaryAuditTrigger
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF OLD.Salary <> NEW.Salary THEN
        INSERT INTO SalaryAudit
            (EmpID, OldSalary, NewSalary)
        VALUES
            (NEW.EmpID, OLD.Salary, NEW.Salary);
    END IF;
END //

DELIMITER ;


-- 5. CREATE STORED PROCEDURE
DELIMITER //

CREATE PROCEDURE transfer_employee(
    IN emp_id INT,
    IN new_dept_id INT
)
BEGIN
    DECLARE emp_count INT DEFAULT 0;
    DECLARE dept_count INT DEFAULT 0;

    -- Check whether the employee exists.
     SELECT COUNT(*)
    INTO emp_count
    FROM Employee
    WHERE EmpID = emp_id;

    -- Check whether the destination department exists.
    SELECT COUNT(*)
    INTO dept_count
    FROM Department
    WHERE DeptID = new_dept_id;
      -- Reject the transfer if the employee does not exist.
    IF emp_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee does not exist';

    -- Reject the transfer if the department does not exist.
    ELSEIF dept_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Department does not exist';

    -- Transfer the employee to the new department.
      ELSE
        UPDATE Employee
        SET DeptID = new_dept_id
        WHERE EmpID = emp_id;
    END IF;
END //

DELIMITER ;

-- 6. DISPLAY EMPLOYEE BEFORE TRANSFER
SELECT EmpID, EmpName, DeptID
FROM Employee
WHERE EmpID = 2;

-- 7. EXECUTE EMPLOYEE TRANSFER
CALL transfer_employee(2, 103);

-- 8. VERIFY EMPLOYEE TRANSFER
SELECT EmpID, EmpName, DeptID
FROM Employee
WHERE EmpID = 2;

-- 9. TEST INVALID EMPLOYEE
CALL transfer_employee(999, 103);

-- 10. TEST INVALID DEPARTMENT
CALL transfer_employee(2, 999);

-- 11. TEST SALARY VALIDATION ON INSERT
INSERT INTO Employee
    (EmpID, EmpName, Salary, DeptID, ProjectID)
VALUES
    (101, 'Test Employee', -5000, 101, 201);

-- 12. TEST SALARY VALIDATION ON UPDATE
UPDATE Employee
SET Salary = -1000
WHERE EmpID = 2;

-- 13. TEST SALARY AUDIT LOGGING
UPDATE Employee
SET Salary = Salary + 2000
WHERE EmpID = 2;

-- Displays all salary audit records.
SELECT *
FROM SalaryAudit;