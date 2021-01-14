USE master;
GO

-- Create the database and switch to it
    IF EXISTS (
        SELECT name
        FROM sys.databases
        WHERE name = N'CoognetTKS'
    ) DROP DATABASE [CoognetTKS];
    CREATE DATABASE [CoognetTKS];
    GO

    USE [CoognetTKS];
    GO

-- Create the tables
    CREATE TABLE Review_Status (
        RvwStatus_ID INT PRIMARY KEY IDENTITY,
        RvwStatus_Name [NVARCHAR](150) UNIQUE NOT NULL
    );

    CREATE TABLE Review_Type (
        Rvw_TypeID INT PRIMARY KEY IDENTITY,
        Rvw_TypeName [NVARCHAR](150) UNIQUE NOT NULL,
        Rvw_Requirements [NVARCHAR](1000)
    );

    CREATE TABLE Customer (
        Cust_ID INT PRIMARY KEY IDENTITY,
        Cust_FirstName [NVARCHAR](100) NOT NULL,
        Cust_LastName [NVARCHAR](100) NOT NULL,
        Cust_Address [NVARCHAR](100) NOT NULL
    );

    CREATE TABLE Job_Proposal (
        JobProp_ID INT PRIMARY KEY IDENTITY,
        Cust_ID INT NOT NULL,
        JobProp_Address [NVARCHAR](100) NOT NULL,
        
        UNIQUE (JobProp_ID, Cust_ID)
    );

    CREATE TABLE Site_Survey (
        Survey_ID INT PRIMARY KEY IDENTITY,
        JobProp_ID INT NOT NULL,
        Survey_Date DATE NOT NULL,
        Survey_Notes [NVARCHAR](1000),
        
        UNIQUE (Survey_ID, JobProp_ID)
    );

    CREATE TABLE Survey_Picture (
        Picture_ID INT PRIMARY KEY IDENTITY,
        Survey_ID INT NOT NULL,
        Picture_Desc [NVARCHAR](1000),
        Picture_URL [NVARCHAR](255),
        
        UNIQUE (Picture_ID, Survey_ID)
    );

    CREATE TABLE Architectural_Review (
        ArchRvw_ID INT PRIMARY KEY IDENTITY,
        Survey_ID INT NOT NULL,
        Rvw_TypeID INT NOT NULL,
        RvwStatus_ID INT NOT NULL,
        
        UNIQUE (Survey_ID, Rvw_TypeID, RvwStatus_ID)
    );

    CREATE TABLE Project (
        Project_ID INT PRIMARY KEY IDENTITY,
        Project_Name [NVARCHAR](100) NOT NULL
    );

    CREATE TABLE Job (
        Job_ID INT PRIMARY KEY IDENTITY,
        JobProp_ID INT NOT NULL,
        Project_ID INT NOT NULL,
        Job_Name [NVARCHAR](100) NOT NULL
        
        UNIQUE (Job_ID, JobProp_ID, Project_ID)
    );

    CREATE TABLE Customer_Invoice (
        Cust_ID INT,
        Job_ID INT,
        Invoice_amt MONEY NOT NULL,
        
        PRIMARY KEY (Cust_ID, Job_ID)
    );

    CREATE TABLE Status (
        Status_ID INT PRIMARY KEY IDENTITY,
        Status_Name [NVARCHAR](100) UNIQUE NOT NULL
    );

    CREATE TABLE Task (
        Task_ID INT PRIMARY KEY IDENTITY,
        Job_ID INT NOT NULL,
        Status_ID INT NOT NULL,
        Task_Name [NVARCHAR](100) NOT NULL,
        
        UNIQUE (Task_ID, Job_ID)
    );

    CREATE TABLE Problem (
        Prblm_ID INT PRIMARY KEY IDENTITY,
        Prblm_Desc [NVARCHAR](100) UNIQUE NOT NULL
    );

    CREATE TABLE Task_Problem (
        Task_ID INT,
        Prblm_ID INT,
        
        PRIMARY KEY (Prblm_ID, Task_ID)
    );

    CREATE TABLE Material_Type (
        MatType_Code INT PRIMARY KEY IDENTITY,
        MatType_Name [NVARCHAR](100) NOT NULL
    );

    CREATE TABLE Material (
        Material_ID INT PRIMARY KEY IDENTITY,
        MatType_Code INT NOT NULL,
        Material_Name [NVARCHAR](100) NOT NULL,
        Material_CostCode CHAR(5) NOT NULL
    );

    CREATE TABLE Job_Material (
        Job_ID INT,
        Material_ID INT,
        
        PRIMARY KEY (Job_ID, Material_ID)
    );

    CREATE TABLE Supplier (
        Supplier_ID INT PRIMARY KEY IDENTITY,
        Supplier_Name [NVARCHAR](100) NOT NULL
    );

    -- Use surrogate key, MaterialSource_ID, instead of composite of foreign keys because we will reference it in other tables
    CREATE TABLE Material_Source (
        MaterialSource_ID INT PRIMARY KEY IDENTITY, 
        Supplier_ID INT NOT NULL,
        Material_ID INT NOT NULL,
        Material_Cost MONEY NOT NULL,
        
        UNIQUE (Supplier_ID, Material_ID)
    );

    CREATE TABLE Department (
        Dept_ID INT PRIMARY KEY IDENTITY,
        Dept_Name [NVARCHAR](100) NOT NULL
    );

    CREATE TABLE Employee_Type (
        EmpType_Code INT PRIMARY KEY IDENTITY,
        EmpType_Name [NVARCHAR](100) NOT NULL
    );

    CREATE TABLE Employee (
        Emp_ID INT PRIMARY KEY IDENTITY,
        Dept_ID INT NOT NULL,
        EmpType_Code INT NOT NULL,
        Emp_FirstName [NVARCHAR](100) NOT NULL,
        Emp_LastName [NVARCHAR](100) NOT NULL,
        Emp_Salary MONEY,
        
        UNIQUE (Emp_ID, Dept_ID)
    );

    CREATE TABLE Dependent (
        Dep_ID INT PRIMARY KEY IDENTITY,
        Emp_ID INT NOT NULL,
        Dep_FirstName [NVARCHAR](100) NOT NULL,
        Dep_LastName [NVARCHAR](100) NOT NULL,
        
        UNIQUE (Dep_ID, Emp_ID)
    );

    CREATE TABLE Employee_History (
        Date_Assign DATE,
        Emp_Id INT,
        Emp_Salary MONEY,
        
        PRIMARY KEY (Emp_ID, Date_Assign)
    );

    CREATE TABLE Employee_Project (
        Emp_ID INT,
        Project_ID INT,
        
        PRIMARY KEY (Emp_ID, Project_ID)
    );

    CREATE TABLE Account (
        Account_ID INT PRIMARY KEY IDENTITY,
        Dept_ID INT NOT NULL,
        Account_Name [NVARCHAR](100) NOT NULL,
        Account_Type [NVARCHAR](100) NOT NULL,
        
        UNIQUE (Account_ID, Dept_ID)
    );

    CREATE TABLE Accounts_Payable (
        AccountsPayable_ID INT PRIMARY KEY IDENTITY,
        Account_ID INT NOT NULL,
        Balance MONEY NOT NULL,
        DueDate DATE NOT NULL,
        
        UNIQUE (AccountsPayable_ID, Account_ID)
    );

    CREATE TABLE Fleet (
        Fleet_ID INT PRIMARY KEY IDENTITY,
        AccountsPayable_ID INT NOT NULL,
        Fleet_VehicleCnt INT NOT NULL,
        
        UNIQUE (Fleet_ID, AccountsPayable_ID)
    );

    CREATE TABLE Vehicle (
        Vehicle_ID INT PRIMARY KEY IDENTITY,
        Fleet_ID INT NOT NULL,
        Vehicle_Make [NVARCHAR](100) NOT NULL,
        Vehicle_Model [NVARCHAR](100) NOT NULL,
        Vehicle_Color [NVARCHAR](100) NOT NULL,
        
        UNIQUE (Vehicle_ID, Fleet_ID)
    );

    CREATE TABLE Maintenance (
        Maintenance_ID INT PRIMARY KEY IDENTITY,
        Vehicle_ID INT NOT NULL,
        Maintenance_Desc [NVARCHAR](1000),
        Maintenance_Cost MONEY NOT NULL,
        Maintenance_Date DATE NOT NULL,
        
        UNIQUE (Maintenance_ID, Vehicle_ID)
    );

    CREATE TABLE Employee_Purchase_Order (
        EPO_ID INT PRIMARY KEY IDENTITY,
        Emp_ID INT NOT NULL,
        AccountsPayable_ID INT NOT NULL,
        EPO_Total MONEY NOT NULL DEFAULT 0,
        EPO_Date DATE NOT NULL,
        
        UNIQUE (EPO_ID, Emp_ID, AccountsPayable_ID)
    );

    CREATE TABLE Employee_Order_Line (
        EOL_ID INT PRIMARY KEY IDENTITY,
        EPO_ID INT NOT NULL,
        MaterialSource_ID INT NOT NULL,
        EOL_Quantity INT NOT NULL,
        
        UNIQUE (EOL_ID, EPO_ID, MaterialSource_ID)
    );

    CREATE TABLE Contractor (
        Cont_ID INT PRIMARY KEY IDENTITY,
        Cont_FirstName [NVARCHAR](100) NOT NULL,
        Cont_LastName [NVARCHAR](100) NOT NULL,
        Cont_Salary MONEY NOT NULL DEFAULT 0
    );

    CREATE TABLE Work_Order (
        Cont_ID INT,
        Project_ID INT,
        
        PRIMARY KEY (Cont_ID, Project_ID)
    );

    CREATE TABLE Contractor_Purchase_Order (
        CPO_ID INT PRIMARY KEY IDENTITY,
        Cont_ID INT NOT NULL,
        AccountsPayable_ID INT NOT NULL,
        CPO_Total MONEY NOT NULL DEFAULT 0,
        CPO_Date DATE NOT NULL,
        
        UNIQUE (CPO_ID, Cont_ID, AccountsPayable_ID)
    );

    CREATE TABLE Contractor_Order_Line (
        COL_ID INT PRIMARY KEY IDENTITY,
        CPO_ID INT NOT NULL,
        MaterialSource_ID INT NOT NULL,
        COL_Quantity INT NOT NULL,
        
        UNIQUE (COL_ID, CPO_ID, MaterialSource_ID)
    );
    GO
    
-- Add foreign key constraints
    ALTER TABLE Account WITH CHECK
    ADD CONSTRAINT fk_Account__Dept_ID
        FOREIGN KEY(Dept_ID)
        REFERENCES Department(Dept_ID);

    ALTER TABLE Accounts_Payable WITH CHECK
    ADD CONSTRAINT fk_Accounts_Payable__Account_ID
        FOREIGN KEY(Account_ID)
        REFERENCES Account(Account_ID);

    ALTER TABLE Architectural_Review WITH CHECK
    ADD CONSTRAINT fk_Architectural_Review__Survey_ID
        FOREIGN KEY(Survey_ID)
        REFERENCES Site_Survey(Survey_ID),
    CONSTRAINT fk_Architectural_Review__Rvw_TypeID
        FOREIGN KEY(Rvw_TypeID)
        REFERENCES Review_Type(Rvw_TypeID),
    CONSTRAINT fk_Architectural_Review__RvwStatus_ID
        FOREIGN KEY(RvwStatus_ID)
        REFERENCES Review_Status(RvwStatus_ID);

    ALTER TABLE Contractor_Order_Line WITH CHECK
    ADD CONSTRAINT fk_Contractor_Order_Line__CPO_ID
        FOREIGN KEY(CPO_ID)
        REFERENCES Contractor_Purchase_Order(CPO_ID),
    CONSTRAINT fk_Contractor_Order_Line__MaterialSource_ID
        FOREIGN KEY(MaterialSource_ID)
        REFERENCES Material_Source(MaterialSource_ID);

    ALTER TABLE Contractor_Purchase_Order WITH CHECK
    ADD CONSTRAINT fk_Contractor_Purchase_Order__Cont_ID
        FOREIGN KEY(Cont_ID)
        REFERENCES Contractor(Cont_ID),
    CONSTRAINT fk_Contractor_Purchase_Order__AccountsPayable_ID
        FOREIGN KEY(AccountsPayable_ID)
        REFERENCES Accounts_Payable(AccountsPayable_ID);

    ALTER TABLE Customer_Invoice WITH CHECK
    ADD CONSTRAINT fk_Customer_Invoice__Cust_ID
        FOREIGN KEY(Cust_ID)
        REFERENCES Customer(Cust_ID),
    CONSTRAINT fk_Customer_Invoice__Job_ID
        FOREIGN KEY(Job_ID)
        REFERENCES Job(Job_ID);

    ALTER TABLE Dependent WITH CHECK
    ADD CONSTRAINT fk_Dependent__Emp_ID
        FOREIGN KEY(Emp_ID)
        REFERENCES Employee(Emp_ID);

    ALTER TABLE Employee WITH CHECK
    ADD CONSTRAINT fk_Employee__Dept_ID
        FOREIGN KEY(Dept_ID)
        REFERENCES Department(Dept_ID),
    CONSTRAINT fk_Employee__EmpType_Code
        FOREIGN KEY(EmpType_Code)
        REFERENCES Employee_Type(EmpType_Code);

    ALTER TABLE Employee_History WITH CHECK
    ADD CONSTRAINT fk_Employee_History__Emp_Id
        FOREIGN KEY(Emp_Id)
        REFERENCES Employee(Emp_Id);

    ALTER TABLE Employee_Order_Line WITH CHECK
    ADD CONSTRAINT fk_Employee_Order_Line__EPO_ID
        FOREIGN KEY(EPO_ID)
        REFERENCES Employee_Purchase_Order(EPO_ID),
    CONSTRAINT fk_Employee_Order_Line__MaterialSource_ID
        FOREIGN KEY(MaterialSource_ID)
        REFERENCES Material_Source(MaterialSource_ID);

    ALTER TABLE Employee_Project WITH CHECK
    ADD CONSTRAINT fk_Employee_Project__Emp_ID
        FOREIGN KEY(Emp_ID)
        REFERENCES Employee(Emp_ID),
    CONSTRAINT fk_Employee_Project__Project_ID
        FOREIGN KEY(Project_ID)
        REFERENCES Project(Project_ID);

    ALTER TABLE Employee_Purchase_Order WITH CHECK
    ADD CONSTRAINT fk_Employee_Purchase_Order__Emp_ID
        FOREIGN KEY(Emp_ID)
        REFERENCES Employee(Emp_ID),
    CONSTRAINT fk_Employee_Purchase_Order__AccountsPayable_ID
        FOREIGN KEY(AccountsPayable_ID)
        REFERENCES Accounts_Payable(AccountsPayable_ID);

    ALTER TABLE Fleet WITH CHECK
    ADD CONSTRAINT fk_Fleet__AccountsPayable_ID
        FOREIGN KEY(AccountsPayable_ID)
        REFERENCES Accounts_Payable(AccountsPayable_ID);

    ALTER TABLE Job WITH CHECK
    ADD CONSTRAINT fk_Job__JobProp_ID
        FOREIGN KEY(JobProp_ID)
        REFERENCES Job_Proposal(JobProp_ID),
    CONSTRAINT fk_Job__Project_ID
        FOREIGN KEY(Project_ID)
        REFERENCES Project(Project_ID);

    ALTER TABLE Job_Material WITH CHECK
    ADD CONSTRAINT fk_Job_Material__Material_ID
        FOREIGN KEY(Material_ID)
        REFERENCES Material(Material_ID),
    CONSTRAINT fk_Job_Material__Job_ID
        FOREIGN KEY(Job_ID)
        REFERENCES Job(Job_ID);

    ALTER TABLE Job_Proposal WITH CHECK
    ADD CONSTRAINT fk_Job_Proposal__Cust_ID
        FOREIGN KEY(Cust_ID)
        REFERENCES Customer(Cust_ID);

    ALTER TABLE Maintenance WITH CHECK
    ADD CONSTRAINT fk_Maintenance__Vehicle_ID
        FOREIGN KEY(Vehicle_ID)
        REFERENCES Vehicle(Vehicle_ID);

    ALTER TABLE Material WITH CHECK
    ADD CONSTRAINT fk_Material__MatType_Code
        FOREIGN KEY(MatType_Code)
        REFERENCES Material_Type(MatType_Code);

    ALTER TABLE Material_Source WITH CHECK
    ADD CONSTRAINT fk_Material_Source__Supplier_ID
        FOREIGN KEY(Supplier_ID)
        REFERENCES Supplier(Supplier_ID),
    CONSTRAINT fk_Material_Source__Material_ID
        FOREIGN KEY(Material_ID)
        REFERENCES Material(Material_ID);

    ALTER TABLE Site_Survey WITH CHECK
    ADD CONSTRAINT fk_Site_Survey__JobProp_ID
        FOREIGN KEY(JobProp_ID)
        REFERENCES Job_Proposal(JobProp_ID);

    ALTER TABLE Survey_Picture WITH CHECK
    ADD CONSTRAINT fk_Survey_Picture__Survey_ID
        FOREIGN KEY(Survey_ID)
        REFERENCES Site_Survey(Survey_ID);

    ALTER TABLE Task WITH CHECK
    ADD CONSTRAINT fk_Task__Job_ID
        FOREIGN KEY(Job_ID)
        REFERENCES Job(Job_ID),
    CONSTRAINT fk_Task__Status_ID
        FOREIGN KEY(Status_ID)
        REFERENCES Status(Status_ID);

    ALTER TABLE Task_Problem WITH CHECK
    ADD CONSTRAINT fk_Task_Problem__Task_ID
        FOREIGN KEY(Task_ID)
        REFERENCES Task(Task_ID),
    CONSTRAINT fk_Task_Problem__Prblm_ID
        FOREIGN KEY(Prblm_ID)
        REFERENCES Problem(Prblm_ID);

    ALTER TABLE Vehicle WITH CHECK
    ADD CONSTRAINT fk_Vehicle__Fleet_ID
        FOREIGN KEY(Fleet_ID)
        REFERENCES Fleet(Fleet_ID);

    ALTER TABLE Work_Order WITH CHECK
    ADD CONSTRAINT fk_Work_Order__Cont_ID
        FOREIGN KEY(Cont_ID)
        REFERENCES Contractor(Cont_ID),
    CONSTRAINT fk_Work_Order__Project_ID
        FOREIGN KEY(Project_ID)
        REFERENCES Project(Project_ID);
    GO
    
-- Create logins, roles, etc
    CREATE OR ALTER PROCEDURE CREATE_ADMIN AS 
    BEGIN
        CREATE LOGIN TKSAdmin WITH PASSWORD = '{REDACTED}', DEFAULT_DATABASE=[CoognetTKS];
        ALTER SERVER ROLE sysadmin ADD MEMBER TKSAdmin;
    END;
    GO
    
    IF NOT EXISTS (
        SELECT 1 FROM sys.sql_logins WHERE [name] = 'TKSAdmin'
    ) EXEC CREATE_ADMIN;
    GO

-- Insert sample data 
    BULK INSERT [Account] FROM 'C:\FinalProject\Data\Account.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Accounts_Payable] FROM 'C:\FinalProject\Data\Accounts_Payable.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Architectural_Review] FROM 'C:\FinalProject\Data\Architectural_Review.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Contractor] FROM 'C:\FinalProject\Data\Contractor.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Contractor_Order_Line] FROM 'C:\FinalProject\Data\Contractor_Order_Line.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Contractor_Purchase_Order] FROM 'C:\FinalProject\Data\Contractor_Purchase_Order.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Customer] FROM 'C:\FinalProject\Data\Customer.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Customer_Invoice] FROM 'C:\FinalProject\Data\Customer_Invoice.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Department] FROM 'C:\FinalProject\Data\Department.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Dependent] FROM 'C:\FinalProject\Data\Dependent.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Employee] FROM 'C:\FinalProject\Data\Employee.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Employee_History] FROM 'C:\FinalProject\Data\Employee_History.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Employee_Order_Line] FROM 'C:\FinalProject\Data\Employee_Order_Line.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Employee_Project] FROM 'C:\FinalProject\Data\Employee_Project.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Employee_Purchase_Order] FROM 'C:\FinalProject\Data\Employee_Purchase_Order.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Employee_Type] FROM 'C:\FinalProject\Data\Employee_Type.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Fleet] FROM 'C:\FinalProject\Data\Fleet.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Job] FROM 'C:\FinalProject\Data\Job.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Job_Material] FROM 'C:\FinalProject\Data\Job_Material.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Job_Proposal] FROM 'C:\FinalProject\Data\Job_Proposal.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Maintenance] FROM 'C:\FinalProject\Data\Maintenance.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Material] FROM 'C:\FinalProject\Data\Material.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Material_Source] FROM 'C:\FinalProject\Data\Material_Source.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Material_Type] FROM 'C:\FinalProject\Data\Material_Type.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Problem] FROM 'C:\FinalProject\Data\Problem.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Project] FROM 'C:\FinalProject\Data\Project.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Review_Status] FROM 'C:\FinalProject\Data\Review_Status.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Review_Type] FROM 'C:\FinalProject\Data\Review_Type.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Site_Survey] FROM 'C:\FinalProject\Data\Site_Survey.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Status] FROM 'C:\FinalProject\Data\Status.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Supplier] FROM 'C:\FinalProject\Data\Supplier.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Survey_Picture] FROM 'C:\FinalProject\Data\Survey_Picture.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Task] FROM 'C:\FinalProject\Data\Task.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Task_Problem] FROM 'C:\FinalProject\Data\Task_Problem.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Vehicle] FROM 'C:\FinalProject\Data\Vehicle.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);
    BULK INSERT [Work_Order] FROM 'C:\FinalProject\Data\Work_Order.csv' WITH (FORMAT='CSV', FIELDTERMINATOR='\t', KEEPIDENTITY);