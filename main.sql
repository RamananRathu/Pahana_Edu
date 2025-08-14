-- Pahana Edu Database Schema
-- MySQL Database Setup

DROP DATABASE IF EXISTS pahana_edu;
CREATE DATABASE pahana_edu CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE pahana_edu;

-- Users table for authentication
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'manager', 'staff', 'user') DEFAULT 'user',
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL
);

-- Customers table with enhanced fields
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address_line1 VARCHAR(100),
    address_line2 VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50) DEFAULT 'USA',
    date_of_birth DATE,
    gender ENUM('male', 'female', 'other'),
    units_consumed INT DEFAULT 0,
    credit_limit DECIMAL(10,2) DEFAULT 1000.00,
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Categories for better item organization
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_id INT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES categories(id)
);

-- Publishers table
CREATE TABLE publishers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(255),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Authors table
CREATE TABLE authors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    biography TEXT,
    birth_date DATE,
    nationality VARCHAR(50),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Enhanced items table
CREATE TABLE items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    item_code VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(200) NOT NULL,
    subtitle VARCHAR(200),
    isbn VARCHAR(20) UNIQUE,
    category_id INT,
    publisher_id INT,
    publication_date DATE,
    edition VARCHAR(50),
    pages INT,
    language VARCHAR(50) DEFAULT 'English',
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    cost_price DECIMAL(10,2),
    stock_quantity INT DEFAULT 0,
    min_stock_level INT DEFAULT 5,
    max_stock_level INT DEFAULT 100,
    status ENUM('active', 'inactive', 'discontinued') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (publisher_id) REFERENCES publishers(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Item-Author relationship (many-to-many)
CREATE TABLE item_authors (
    item_id INT,
    author_id INT,
    role ENUM('author', 'co-author', 'editor', 'translator') DEFAULT 'author',
    PRIMARY KEY (item_id, author_id),
    FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE
);

-- Bills table with enhanced tracking
CREATE TABLE bills (
    id INT PRIMARY KEY AUTO_INCREMENT,
    bill_number VARCHAR(20) UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    bill_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    due_date DATE,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0,
    tax_rate DECIMAL(5,2) DEFAULT 8.25,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    paid_amount DECIMAL(10,2) DEFAULT 0,
    balance_amount DECIMAL(10,2) DEFAULT 0,
    status ENUM('draft', 'sent', 'paid', 'overdue', 'cancelled') DEFAULT 'draft',
    payment_method ENUM('cash', 'credit_card', 'debit_card', 'check', 'bank_transfer') NULL,
    payment_date TIMESTAMP NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Bill items for detailed billing
CREATE TABLE bill_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    bill_id INT NOT NULL,
    item_id INT,
    description VARCHAR(200) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    line_total DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (bill_id) REFERENCES bills(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES items(id)
);

-- Customer units consumption tracking
CREATE TABLE unit_consumption (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    consumption_date DATE NOT NULL,
    units_consumed INT NOT NULL,
    rate_per_unit DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    meter_reading_previous INT,
    meter_reading_current INT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Inventory transactions
CREATE TABLE inventory_transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT NOT NULL,
    transaction_type ENUM('purchase', 'sale', 'adjustment', 'return') NOT NULL,
    quantity INT NOT NULL,
    unit_cost DECIMAL(10,2),
    reference_number VARCHAR(50),
    notes TEXT,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (item_id) REFERENCES items(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- System settings
CREATE TABLE settings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    description TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by INT,
    FOREIGN KEY (updated_by) REFERENCES users(id)
);

-- Audit log for tracking changes
CREATE TABLE audit_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    action ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    old_values JSON,
    new_values JSON,
    user_id INT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create indexes for better performance
CREATE INDEX idx_customers_account_number ON customers(account_number);
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_customers_status ON customers(status);
CREATE INDEX idx_items_code ON items(item_code);
CREATE INDEX idx_items_category ON items(category_id);
CREATE INDEX idx_items_status ON items(status);
CREATE INDEX idx_bills_customer ON bills(customer_id);
CREATE INDEX idx_bills_date ON bills(bill_date);
CREATE INDEX idx_bills_status ON bills(status);
CREATE INDEX idx_unit_consumption_customer ON unit_consumption(customer_id);
CREATE INDEX idx_unit_consumption_date ON unit_consumption(consumption_date);
CREATE INDEX idx_inventory_item ON inventory_transactions(item_id);
CREATE INDEX idx_inventory_date ON inventory_transactions(transaction_date);
CREATE INDEX idx_audit_table_record ON audit_log(table_name, record_id);
CREATE INDEX idx_audit_user ON audit_log(user_id);




















-- Sample Data for Pahana Edu Database
USE pahana_edu;

-- Insert Users
INSERT INTO users (username, password, email, full_name, role, status) VALUES
('admin', 'admin123', 'admin@pahanaedu.com', 'System Administrator', 'admin', 'active'),
('manager', 'manager123', 'manager@pahanaedu.com', 'John Manager', 'manager', 'active');

-- Insert Categories
INSERT INTO categories (name, description, parent_id) VALUES
('Programming', 'Programming and Software Development Books', NULL),
('Web Development', 'Web Development Technologies', 1),
('Mobile Development', 'Mobile App Development', 1),
('Database', 'Database Design and Management', 1),
('Science', 'Science and Mathematics Books', NULL),
('Mathematics', 'Mathematics and Statistics', 5),
('Physics', 'Physics and Applied Sciences', 5),
('Business', 'Business and Management Books', NULL),
('Fiction', 'Fiction and Literature', NULL),
('Non-Fiction', 'Non-Fiction Books', NULL);

-- Insert Publishers
INSERT INTO publishers (name, address, phone, email, website) VALUES
('Tech Publications Inc.', '123 Tech Street, Silicon Valley, CA 94000', '555-0101', 'info@techpub.com', 'www.techpublications.com'),
('Academic Press', '456 University Ave, Boston, MA 02101', '555-0102', 'contact@academicpress.com', 'www.academicpress.com'),
('Science World Publishers', '789 Research Blvd, Austin, TX 73301', '555-0103', 'info@scienceworld.com', 'www.scienceworld.com'),
('Business Books Ltd.', '321 Commerce St, New York, NY 10001', '555-0104', 'sales@businessbooks.com', 'www.businessbooks.com'),
('Educational Resources', '654 Learning Lane, Chicago, IL 60601', '555-0105', 'info@eduresources.com', 'www.educationalresources.com'),
('Modern Literature Press', '987 Story Ave, Portland, OR 97201', '555-0106', 'contact@modernlit.com', 'www.modernliterature.com');

-- Insert Authors
INSERT INTO authors (first_name, last_name, biography, birth_date, nationality) VALUES
('Robert', 'Martin', 'Software engineer and author known for Clean Code principles', '1952-12-05', 'American'),
('Joshua', 'Bloch', 'Software engineer at Google, former Sun Microsystems architect', '1961-08-28', 'American'),
('Kathy', 'Sierra', 'Co-creator of Head First series, software developer and trainer', '1957-03-15', 'American'),
('Bert', 'Bates', 'Software developer and co-author of Head First Java', '1960-07-22', 'American'),
('Martin', 'Fowler', 'British software developer, author and international speaker', '1963-12-18', 'British'),
('Eric', 'Freeman', 'Computer scientist and author of Head First Design Patterns', '1965-04-10', 'American'),
('Elisabeth', 'Robson', 'Software engineer and co-author of Head First HTML and CSS', '1968-09-14', 'American'),
('David', 'Flanagan', 'Programmer and author of JavaScript: The Definitive Guide', '1965-01-20', 'American'),
('Jon', 'Duckett', 'Web designer and author of HTML & CSS and JavaScript & jQuery books', '1970-05-30', 'British'),
('Steve', 'Krug', 'Usability consultant and author of Don\'t Make Me Think', '1950-02-28', 'American');

-- Insert Items (Books)
INSERT INTO items (item_code, title, subtitle, isbn, category_id, publisher_id, publication_date, edition, pages, price, cost_price, stock_quantity, min_stock_level, max_stock_level, created_by) VALUES
('B001', 'Clean Code', 'A Handbook of Agile Software Craftsmanship', '978-0132350884', 1, 1, '2008-08-01', '1st Edition', 464, 42.99, 25.99, 25, 5, 50, 1),
('B002', 'Effective Java', 'Programming Language Guide', '978-0134685991', 1, 1, '2017-12-27', '3rd Edition', 416, 54.99, 32.99, 30, 5, 50, 1),
('B003', 'Head First Java', 'A Brain-Friendly Guide', '978-0596009205', 1, 2, '2005-02-09', '2nd Edition', 720, 49.99, 29.99, 20, 5, 40, 1),
('B004', 'JavaScript: The Definitive Guide', 'Master the World\'s Most-Used Programming Language', '978-1491952023', 2, 1, '2020-05-14', '7th Edition', 706, 59.99, 35.99, 15, 3, 30, 1),
('B005', 'HTML and CSS', 'Design and Build Websites', '978-1118008188', 2, 2, '2011-11-08', '1st Edition', 490, 39.99, 23.99, 35, 10, 60, 1),
('B006', 'Learning Web Design', 'A Beginner\'s Guide to HTML, CSS, JavaScript, and Web Graphics', '978-1491960202', 2, 1, '2018-08-14', '5th Edition', 808, 54.99, 32.99, 18, 5, 35, 1),
('B007', 'Database System Concepts', 'Comprehensive Database Theory and Practice', '978-0078022159', 4, 3, '2019-02-05', '7th Edition', 1376, 89.99, 53.99, 12, 3, 25, 1),
('B008', 'MySQL Cookbook', 'Solutions for Database Developers and Administrators', '978-1449374020', 4, 1, '2014-08-25', '3rd Edition', 868, 64.99, 38.99, 22, 5, 40, 1),
('B009', 'Calculus: Early Transcendentals', 'Mathematical Analysis and Applications', '978-1285741550', 6, 3, '2015-01-01', '8th Edition', 1344, 94.99, 56.99, 8, 2, 20, 1),
('B010', 'Physics for Scientists and Engineers', 'Comprehensive Physics Textbook', '978-1133947271', 7, 3, '2013-01-01', '9th Edition', 1312, 99.99, 59.99, 6, 2, 15, 1),
('B011', 'Introduction to Algorithms', 'Comprehensive Algorithms Textbook', '978-0262033848', 1, 2, '2009-07-31', '3rd Edition', 1292, 89.99, 53.99, 10, 3, 20, 1),
('B012', 'Design Patterns', 'Elements of Reusable Object-Oriented Software', '978-0201633612', 1, 2, '1994-10-21', '1st Edition', 395, 54.99, 32.99, 14, 3, 25, 1),
('B013', 'The Pragmatic Programmer', 'Your Journey to Mastery', '978-0135957059', 1, 2, '2019-09-13', '2nd Edition', 352, 49.99, 29.99, 28, 5, 45, 1),
('B014', 'React: Up & Running', 'Building Web Applications', '978-1491931820', 2, 1, '2016-06-25', '1st Edition', 222, 39.99, 23.99, 20, 5, 35, 1),
('B015', 'Node.js in Action', 'Server-Side JavaScript Development', '978-1617292576', 2, 1, '2017-08-16', '2nd Edition', 392, 49.99, 29.99, 16, 4, 30, 1);

-- Insert Item-Author relationships
INSERT INTO item_authors (item_id, author_id, role) VALUES
(1, 1, 'author'),
(2, 2, 'author'),
(3, 3, 'author'),
(3, 4, 'co-author'),
(4, 8, 'author'),
(5, 9, 'author'),
(6, 7, 'author'),
(11, 1, 'co-author'),
(12, 5, 'author'),
(13, 1, 'co-author'),
(14, 6, 'author'),
(15, 7, 'author');

-- Insert Customers
INSERT INTO customers (account_number, first_name, last_name, email, phone, address_line1, address_line2, city, state, postal_code, date_of_birth, gender, units_consumed, credit_limit, created_by) VALUES
('ACC001001', 'John', 'Smith', 'john.smith@email.com', '555-1001', '123 Main Street', 'Apt 4B', 'New York', 'NY', '10001', '1985-03-15', 'male', 150, 2000.00, 1),
('ACC001002', 'Sarah', 'Johnson', 'sarah.johnson@email.com', '555-1002', '456 Oak Avenue', '', 'Los Angeles', 'CA', '90210', '1990-07-22', 'female', 200, 2500.00, 1),
('ACC001003', 'Michael', 'Brown', 'michael.brown@email.com', '555-1003', '789 Pine Road', 'Suite 12', 'Chicago', 'IL', '60601', '1988-11-08', 'male', 175, 1800.00, 1),
('ACC001004', 'Emily', 'Davis', 'emily.davis@email.com', '555-1004', '321 Elm Street', '', 'Houston', 'TX', '77001', '1992-04-30', 'female', 125, 1500.00, 1),
('ACC001005', 'David', 'Wilson', 'david.wilson@email.com', '555-1005', '654 Maple Drive', 'Unit 8', 'Phoenix', 'AZ', '85001', '1987-09-12', 'male', 300, 3000.00, 1),
('ACC001006', 'Lisa', 'Anderson', 'lisa.anderson@email.com', '555-1006', '987 Cedar Lane', '', 'Philadelphia', 'PA', '19101', '1991-12-03', 'female', 180, 2200.00, 1),
('ACC001007', 'Robert', 'Taylor', 'robert.taylor@email.com', '555-1007', '147 Birch Street', 'Apt 3A', 'San Antonio', 'TX', '78201', '1986-06-18', 'male', 220, 2800.00, 1),
('ACC001008', 'Jennifer', 'Martinez', 'jennifer.martinez@email.com', '555-1008', '258 Spruce Avenue', '', 'San Diego', 'CA', '92101', '1989-01-25', 'female', 160, 1900.00, 1),
('ACC001009', 'Christopher', 'Garcia', 'chris.garcia@email.com', '555-1009', '369 Willow Road', 'Suite 5', 'Dallas', 'TX', '75201', '1984-08-14', 'male', 190, 2300.00, 1),
('ACC001010', 'Amanda', 'Rodriguez', 'amanda.rodriguez@email.com', '555-1010', '741 Aspen Drive', '', 'San Jose', 'CA', '95101', '1993-05-07', 'female', 140, 1700.00, 1),
('ACC001011', 'James', 'Lee', 'james.lee@email.com', '555-1011', '852 Poplar Street', 'Unit 12', 'Austin', 'TX', '73301', '1990-10-20', 'male', 210, 2600.00, 1),
('ACC001012', 'Michelle', 'White', 'michelle.white@email.com', '555-1012', '963 Hickory Lane', '', 'Jacksonville', 'FL', '32099', '1988-02-28', 'female', 170, 2100.00, 1),
('ACC001013', 'Daniel', 'Harris', 'daniel.harris@email.com', '555-1013', '159 Walnut Avenue', 'Apt 7C', 'San Francisco', 'CA', '94101', '1985-12-11', 'male', 250, 2900.00, 1),
('ACC001014', 'Jessica', 'Clark', 'jessica.clark@email.com', '555-1014', '357 Chestnut Road', '', 'Columbus', 'OH', '43085', '1991-07-04', 'female', 135, 1600.00, 1),
('ACC001015', 'Matthew', 'Lewis', 'matthew.lewis@email.com', '555-1015', '486 Sycamore Drive', 'Suite 9', 'Fort Worth', 'TX', '76101', '1987-04-16', 'male', 195, 2400.00, 1);

-- Insert Unit Consumption records
INSERT INTO unit_consumption (customer_id, consumption_date, units_consumed, rate_per_unit, total_amount, meter_reading_previous, meter_reading_current, created_by) VALUES
(1, '2024-01-01', 50, 2.50, 125.00, 1000, 1050, 1),
(1, '2024-02-01', 55, 2.50, 137.50, 1050, 1105, 1),
(1, '2024-03-01', 45, 2.50, 112.50, 1105, 1150, 1),
(2, '2024-01-01', 75, 2.50, 187.50, 2000, 2075, 1),
(2, '2024-02-01', 70, 2.50, 175.00, 2075, 2145, 1),
(2, '2024-03-01', 55, 2.50, 137.50, 2145, 2200, 1),
(3, '2024-01-01', 60, 2.50, 150.00, 1500, 1560, 1),
(3, '2024-02-01', 58, 2.50, 145.00, 1560, 1618, 1),
(3, '2024-03-01', 57, 2.50, 142.50, 1618, 1675, 1),
(4, '2024-01-01', 40, 2.50, 100.00, 800, 840, 1),
(4, '2024-02-01', 42, 2.50, 105.00, 840, 882, 1),
(4, '2024-03-01', 43, 2.50, 107.50, 882, 925, 1),
(5, '2024-01-01', 100, 2.50, 250.00, 3000, 3100, 1),
(5, '2024-02-01', 105, 2.50, 262.50, 3100, 3205, 1),
(5, '2024-03-01', 95, 2.50, 237.50, 3205, 3300, 1);

-- Insert Bills
INSERT INTO bills (bill_number, customer_id, bill_date, due_date, subtotal, tax_rate, tax_amount, total_amount, status, created_by) VALUES
('BILL-2024-001', 1, '2024-01-31', '2024-02-29', 125.00, 8.25, 10.31, 135.31, 'paid', 1),
('BILL-2024-002', 1, '2024-02-29', '2024-03-30', 137.50, 8.25, 11.34, 148.84, 'paid', 1),
('BILL-2024-003', 1, '2024-03-31', '2024-04-30', 112.50, 8.25, 9.28, 121.78, 'sent', 1),
('BILL-2024-004', 2, '2024-01-31', '2024-02-29', 187.50, 8.25, 15.47, 202.97, 'paid', 1),
('BILL-2024-005', 2, '2024-02-29', '2024-03-30', 175.00, 8.25, 14.44, 189.44, 'paid', 1),
('BILL-2024-006', 2, '2024-03-31', '2024-04-30', 137.50, 8.25, 11.34, 148.84, 'sent', 1),
('BILL-2024-007', 3, '2024-01-31', '2024-02-29', 150.00, 8.25, 12.38, 162.38, 'paid', 1),
('BILL-2024-008', 3, '2024-02-29', '2024-03-30', 145.00, 8.25, 11.96, 156.96, 'paid', 1),
('BILL-2024-009', 3, '2024-03-31', '2024-04-30', 142.50, 8.25, 11.76, 154.26, 'sent', 1),
('BILL-2024-010', 4, '2024-01-31', '2024-02-29', 100.00, 8.25, 8.25, 108.25, 'paid', 1),
('BILL-2024-011', 4, '2024-02-29', '2024-03-30', 105.00, 8.25, 8.66, 113.66, 'paid', 1),
('BILL-2024-012', 4, '2024-03-31', '2024-04-30', 107.50, 8.25, 8.87, 116.37, 'sent', 1),
('BILL-2024-013', 5, '2024-01-31', '2024-02-29', 250.00, 8.25, 20.63, 270.63, 'paid', 1),
('BILL-2024-014', 5, '2024-02-29', '2024-03-30', 262.50, 8.25, 21.66, 284.16, 'paid', 1),
('BILL-2024-015', 5, '2024-03-31', '2024-04-30', 237.50, 8.25, 19.59, 257.09, 'sent', 1);

-- Insert Bill Items
INSERT INTO bill_items (bill_id, item_id, description, quantity, unit_price, line_total) VALUES
(1, NULL, 'Units Consumed - January 2024', 50, 2.50, 125.00),
(2, NULL, 'Units Consumed - February 2024', 55, 2.50, 137.50),
(3, NULL, 'Units Consumed - March 2024', 45, 2.50, 112.50),
(4, NULL, 'Units Consumed - January 2024', 75, 2.50, 187.50),
(5, NULL, 'Units Consumed - February 2024', 70, 2.50, 175.00),
(6, NULL, 'Units Consumed - March 2024', 55, 2.50, 137.50),
(7, NULL, 'Units Consumed - January 2024', 60, 2.50, 150.00),
(8, NULL, 'Units Consumed - February 2024', 58, 2.50, 145.00),
(9, NULL, 'Units Consumed - March 2024', 57, 2.50, 142.50),
(10, NULL, 'Units Consumed - January 2024', 40, 2.50, 100.00),
(11, NULL, 'Units Consumed - February 2024', 42, 2.50, 105.00),
(12, NULL, 'Units Consumed - March 2024', 43, 2.50, 107.50),
(13, NULL, 'Units Consumed - January 2024', 100, 2.50, 250.00),
(14, NULL, 'Units Consumed - February 2024', 105, 2.50, 262.50),
(15, NULL, 'Units Consumed - March 2024', 95, 2.50, 237.50);

-- Insert Inventory Transactions
INSERT INTO inventory_transactions (item_id, transaction_type, quantity, unit_cost, reference_number, notes, created_by) VALUES
(1, 'purchase', 50, 25.99, 'PO-2024-001', 'Initial stock purchase', 1),
(2, 'purchase', 50, 32.99, 'PO-2024-002', 'Initial stock purchase', 1),
(3, 'purchase', 40, 29.99, 'PO-2024-003', 'Initial stock purchase', 1),
(4, 'purchase', 30, 35.99, 'PO-2024-004', 'Initial stock purchase', 1),
(5, 'purchase', 60, 23.99, 'PO-2024-005', 'Initial stock purchase', 1),
(1, 'sale', -5, 42.99, 'SALE-001', 'Customer purchase', 1),
(2, 'sale', -3, 54.99, 'SALE-002', 'Customer purchase', 1),
(3, 'sale', -2, 49.99, 'SALE-003', 'Customer purchase', 1),
(5, 'sale', -8, 39.99, 'SALE-004', 'Bulk customer order', 1),
(1, 'adjustment', -2, 0.00, 'ADJ-001', 'Damaged books adjustment', 1);

-- Insert System Settings
INSERT INTO settings (setting_key, setting_value, description, updated_by) VALUES
('company_name', 'Pahana Edu', 'Company name for billing and reports', 1),
('company_address', '123 Education Street, Learning City, LC 12345', 'Company address for billing', 1),
('company_phone', '555-EDU-LEARN', 'Company phone number', 1),
('company_email', 'info@pahanaedu.com', 'Company email address', 1),
('default_tax_rate', '8.25', 'Default tax rate percentage', 1),
('default_unit_rate', '2.50', 'Default rate per unit for consumption billing', 1),
('currency_symbol', '$', 'Currency symbol for billing', 1),
('bill_due_days', '30', 'Default number of days for bill due date', 1),
('low_stock_threshold', '5', 'Minimum stock level for low stock alerts', 1),
('session_timeout', '30', 'Session timeout in minutes', 1);

-- Update paid amounts for paid billsz
UPDATE bills SET paid_amount = total_amount, balance_amount = 0.00, payment_method = 'credit_card', payment_date = bill_date + INTERVAL 15 DAY WHERE status = 'paid';
UPDATE bills SET balance_amount = total_amount WHERE status = 'sent';


select * from items i ;
