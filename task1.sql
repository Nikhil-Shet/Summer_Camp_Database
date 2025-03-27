create database task1;

use task1;

CREATE TABLE campers (
    camper_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    personal_phone VARCHAR(15) UNIQUE NOT NULL,
    birth_date DATE NOT NULL
);

CREATE TABLE camps (
    camp_id INT IDENTITY(1,1) PRIMARY KEY,
    camp_title VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    capacity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE camp_visits (
    visit_id INT IDENTITY(1,1) PRIMARY KEY,
    camper_id INT NOT NULL,
    camp_id INT NOT NULL,
    visit_date DATE NOT NULL,
    FOREIGN KEY (camper_id) REFERENCES campers(camper_id),
    FOREIGN KEY (camp_id) REFERENCES camps(camp_id)
);

DECLARE @i INT = 1;

WHILE @i <= 5000
BEGIN
    DECLARE @firstName VARCHAR(50), @lastName VARCHAR(50), @gender CHAR(1), @birthDate DATE, @uniqueID VARCHAR(10);

    SET @gender = CASE WHEN @i <= 3250 THEN 'F' ELSE 'M' END;

    SET @firstName = 'Camper' + CAST(@i AS VARCHAR);

    SET @lastName = 'Test' + CAST(@i AS VARCHAR);

    SET @birthDate = 
        CASE 
            WHEN @i <= 900 THEN DATEADD(YEAR, - (7 + FLOOR(RAND() * 6)), GETDATE())  
            WHEN @i <= 2250 THEN DATEADD(YEAR, - (13 + FLOOR(RAND() * 2)), GETDATE()) 
            WHEN @i <= 3250 THEN DATEADD(YEAR, - (15 + FLOOR(RAND() * 3)), GETDATE()) 
            ELSE DATEADD(YEAR, - (18 + FLOOR(RAND() * 2)), GETDATE()) 
        END;

    SET @uniqueID = CAST(@i AS VARCHAR);

    INSERT INTO campers (first_name, middle_name, last_name, gender, email, personal_phone, birth_date)
    VALUES (
        @firstName,
        'M' + CAST(@i AS VARCHAR),
        @lastName,
        @gender,
        LOWER('camper' + @uniqueID + '@test.com'),  
        '98765' + RIGHT('0000' + CAST(@i AS VARCHAR), 4), 
        @birthDate
    );

    SET @i = @i + 1;
END;


INSERT INTO camps (camp_title, start_date , end_date, capacity, price)
VALUES 
('Adventure Camp', '2024-06-10', '2024-06-20', 50, 300.00),
('Science & Robotics Camp', '2024-07-05', '2024-07-15', 40, 500.00),
('Art & Creativity Camp', '2024-08-01', '2024-08-10', 60, 250.00),
('Sports & Fitness Camp', '2024-06-15', '2024-06-25', 55, 400.00),
('Music & Dance Camp', '2024-07-20', '2024-07-30', 45, 350.00);

INSERT INTO camp_visits (camper_id, camp_id, visit_date)
VALUES 
(1, 1, '2023-06-12'),
(2, 3, '2023-08-05'),
(3, 2, '2024-07-07'),
(4, 1, '2023-06-15'),
(5, 4, '2022-06-18'),
(6, 5, '2024-07-22'),
(7, 2, '2023-07-10'),
(8, 3, '2024-08-02'),
(8, 5, '2023-07-25'),
(9, 4, '2023-06-20');

update campers set first_name = 'Lakshmi' where camper_id =1;

SELECT cv.visit_id, c.first_name, c.last_name, cmp.camp_title, cv.visit_date
FROM camp_visits cv
JOIN campers c ON cv.camper_id = c.camper_id
JOIN camps cmp ON cv.camp_id = cmp.camp_id
WHERE c.first_name = 'Lakshmi'
AND cv.visit_date >= DATEADD(YEAR, -3, CAST(GETDATE() AS DATE));


SELECT 
    CASE 
        WHEN YEAR(GETDATE()) - YEAR(birth_date) BETWEEN 15 AND 18 THEN 'Gen X'
        WHEN YEAR(GETDATE()) - YEAR(birth_date) BETWEEN 13 AND 14 THEN 'Millennials'
        WHEN YEAR(GETDATE()) - YEAR(birth_date) BETWEEN 7 AND 12 THEN 'Gen Z'
        ELSE 'Gen Alpha' 
    END AS Generation,
    ROUND(SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Male_Percentage,
    ROUND(SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Female_Percentage
FROM campers
GROUP BY 
    CASE 
        WHEN YEAR(GETDATE()) - YEAR(birth_date) BETWEEN 15 AND 18 THEN 'Gen X'
        WHEN YEAR(GETDATE()) - YEAR(birth_date) BETWEEN 13 AND 14 THEN 'Millennials'
        WHEN YEAR(GETDATE()) - YEAR(birth_date) BETWEEN 7 AND 12 THEN 'Gen Z'
        ELSE 'Gen Alpha' 
    END
ORDER BY Generation;