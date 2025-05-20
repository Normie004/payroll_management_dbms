-- TABLES
CREATE TABLE Department (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(255),
    Dept_Budget INT,
    Salary_ID INT,
    Dept_Manager_ID INT,
    Dept_Email VARCHAR(255),
    Dept_Phone_Number VARCHAR(15),
    Dept_Creation_Date DATE,
    Dept_Hierarchy_Level INT,
    Dept_Status VARCHAR(10),
    CHECK (Dept_Status IN ('Active', 'Inactive'))
);

CREATE TABLE Employee (
    Emp_ID INT PRIMARY KEY,
    Dept_ID INT,
    Emp_Name VARCHAR(255),
    Gender VARCHAR(50),
    Pronoun VARCHAR(50),
    Date_Of_Birth DATE,
    Marital_Status VARCHAR(50),
    Phone_Number VARCHAR(15),
    Email VARCHAR(255),
    Address VARCHAR(255),
    Position_Title VARCHAR(100),
    Bank_Account_No VARCHAR(50),
    Emp_Username VARCHAR(100),
    Emp_Password VARCHAR(100),
    Emp_Status VARCHAR(10),
    Emp_Emergency_Contact VARCHAR(255),
    CHECK (Emp_Status IN ('Active', 'Inactive')),
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
);

CREATE TABLE Leave (
    Leave_ID INT PRIMARY KEY,
    Emp_ID INT,
    Leave_Date DATE,
    FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID)
);

CREATE TABLE Payroll (
    Transaction_ID INT PRIMARY KEY,
    Emp_ID INT,
    Dept_ID INT,
    Sal_ID INT,
    Gross_Total FLOAT,
    Bank_Account_No VARCHAR(50),
    Date_of_Issue DATE,
    Payroll_Report VARCHAR(255),
    FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID),
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID),
    FOREIGN KEY (Sal_ID) REFERENCES Salary(Sal_ID)
);

CREATE TABLE Salary (
    Sal_ID INT PRIMARY KEY,
    Emp_ID INT,
    Dept_ID INT,
    Sal_Amount FLOAT,
    Bonus FLOAT,
    Vacation_Pay FLOAT,
    Gross_Total FLOAT,
    CHECK (Sal_Amount >= 0),  -- Ensure non-negative salary amount
    CHECK (Bonus >= 0),       -- Ensure non-negative bonus
    CHECK (Vacation_Pay >= 0), -- Ensure non-negative vacation pay
    FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID),
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
);

-- DATA INSERTIONS
-- Insert data into Department table
INSERT INTO Department (Dept_ID, Dept_Name, Dept_Budget, Salary_ID, Dept_Manager_ID, Dept_Email, Dept_Phone_Number, Dept_Creation_Date, Dept_Hierarchy_Level, Dept_Status)
VALUES 
(1, 'Engineering', 500000, 1, 101, 'eng-dept@example.com', '555-1234', '2022-01-01', 2, 'Active'),
(2, 'HR', 200000, 2, 102, 'hr-dept@example.com', '555-5678', '2021-05-10', 1, 'Active'),
(3, 'Finance', 300000, 3, 103, 'fin-dept@example.com', '555-9012', '2020-08-15', 3, 'Inactive');

-- Insert data into Employee table
INSERT INTO Employee (Emp_ID, Dept_ID, Emp_Name, Gender, Pronoun, Date_Of_Birth, Marital_Status, Phone_Number, Email, Address, Position_Title, Bank_Account_No, Emp_Username, Emp_Password, Emp_Status, Emp_Emergency_Contact)
VALUES 
(101, 1, 'John Doe', 'Male', 'He/Him', '1990-05-15', 'Single', '123-456-7890', 'johndoe@example.com', '1234 Main St, City, Country', 'Software Engineer', '9876543210', 'johndoe', 'password123', 'Active', 'Jane Doe, 987-654-3210'),
(102, 2, 'Jane Smith', 'Female', 'She/Her', '1985-07-22', 'Married', '987-654-3210', 'janesmith@example.com', '4321 Main St, City, Country', 'HR Manager', '1234567890', 'janesmith', 'password456', 'Active', 'John Smith, 123-456-7890'),
(103, 3, 'Michael Brown', 'Male', 'He/Him', '1975-09-30', 'Married', '456-789-0123', 'michaelbrown@example.com', '5678 Main St, City, Country', 'Financial Analyst', '2345678901', 'michaelbrown', 'password789', 'Inactive', 'Mary Brown, 456-789-0123');

-- Insert data into Salary table
INSERT INTO Salary (Sal_ID, Emp_ID, Dept_ID, Sal_Amount, Bonus, Vacation_Pay, Gross_Total)
VALUES 
(1, 101, 1, 75000, 5000, 3000, 83000),
(2, 102, 2, 60000, 4000, 2000, 66000),
(3, 103, 3, 90000, 7000, 3500, 100500);

-- Insert data into Payroll table
INSERT INTO Payroll (Transaction_ID, Emp_ID, Dept_ID, Sal_ID, Gross_Total, Bank_Account_No, Date_of_Issue, Payroll_Report)
VALUES 
(1, 101, 1, 1, 83000, '9876543210', '2023-06-30', 'Payroll for June 2023'),
(2, 102, 2, 2, 66000, '1234567890', '2023-06-30', 'Payroll for June 2023'),
(3, 103, 3, 3, 100500, '2345678901', '2023-06-30', 'Payroll for June 2023');

-- Insert data into Leave table
INSERT INTO Leave (Leave_ID, Emp_ID, Leave_Date)
VALUES 
(1, 101, '2023-01-15'),
(2, 102, '2023-02-10'),
(3, 103, '2023-03-05');

-- QUERIES

-- Query to list all active departments
SELECT * FROM Department WHERE Dept_Status = 'Active';

-- Query to list employees by department
SELECT Emp_Name, Position_Title FROM Employee WHERE Dept_ID = 1 AND Emp_Status = 'Active';

-- Query to get all payroll transactions for active employees
SELECT * FROM Payroll WHERE Dept_ID = 1;

-- Query using DISTINCT and ORDER BY
SELECT DISTINCT Emp_Name FROM Employee ORDER BY Emp_Name ASC;

-- New Query using GROUP BY (Simple Query Requirement)
SELECT Dept_ID, COUNT(Emp_ID) AS Employee_Count
FROM Employee
GROUP BY Dept_ID;

-- Advanced Join Query for Employee Pay Details
SELECT 
    E.Emp_Name AS 'Employee Name', 
    D.Dept_Name AS 'Department Name', 
    P.Gross_Total AS 'Total Pay',
    S.Bonus AS 'Bonus'
FROM Employee E
JOIN Department D ON E.Dept_ID = D.Dept_ID
JOIN Payroll P ON E.Emp_ID = P.Emp_ID
JOIN Salary S ON E.Emp_ID = S.Emp_ID
WHERE E.Emp_Status = 'Active' AND P.Gross_Total > 10000;

-- Query for Leave table (Added to cover all tables)
SELECT Emp_ID, Leave_Date FROM Leave WHERE Leave_Date BETWEEN '2023-01-01' AND '2023-12-31';

-- Join query for Avg Salary
SELECT 
    D.Dept_Name AS 'Department Name', 
    AVG(S.Sal_Amount) AS 'Average Salary'
FROM Department D
JOIN Employee E ON D.Dept_ID = E.Dept_ID
JOIN Salary S ON E.Emp_ID = S.Emp_ID
GROUP BY D.Dept_Name;


-- VIEWS

-- View for active employees
CREATE VIEW Active_Employees AS
SELECT Emp_Name, Position_Title, Dept_ID
FROM Employee
WHERE Emp_Status = 'Active';

-- View for department budgets
CREATE VIEW Department_Budgets AS
SELECT Dept_Name, Dept_Budget
FROM Department
WHERE Dept_Status = 'Active';

-- View for payroll report
CREATE VIEW Payroll_Report_View AS
SELECT E.Emp_Name, P.Gross_Total, P.Date_of_Issue
FROM Employee E
JOIN Payroll P ON E.Emp_ID = P.Emp_ID
WHERE E.Emp_Status = 'Active';
