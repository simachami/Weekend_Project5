CREATE TABLE dealership(
    dealership_id SERIAL PRIMARY key,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(255) NOT NULL
);


CREATE TABLE customer(
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(255) NOT NULL
);


CREATE TABLE car(
    car_id SERIAL PRIMARY KEY,
    car_serial_num INTEGER NOT NULL,
    make VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    "year" INTEGER NOT NULL,
    color VARCHAR(255) NOT NULL,
    price DOUBLE PRECISION NOT NULL,
    "condition" VARCHAR(255) NOT NULL
);

ALTER TABLE car ALTER COLUMN price TYPE VARCHAR(255);

CREATE TABLE salesperson(
    salesperson_id SERIAL PRIMARY KEY,
    dealership_id INTEGER NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(255) NOT NULL,
    "position" VARCHAR(255) NOT NULL,
    FOREIGN KEY (dealership_id) REFERENCES dealership(dealership_id)
);


CREATE TABLE sales_invoice(
    sales_invoice_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    salesperson_id INT NOT NULL,
    car_id INTEGER NOT NULL,
    car_serial_num INTEGER NOT NULL,
    sale_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (car_id) REFERENCES car(car_id),
    FOREIGN KEY (salesperson_id) REFERENCES salesperson(salesperson_id)
);



CREATE TABLE invoice_line_item(
    invoice_line_item_id SERIAL PRIMARY KEY,
    sales_invoice_id int NOT NULL,
    "type" VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    "cost" DECIMAL(8, 2) NOT NULL,
    FOREIGN KEY (sales_invoice_id) REFERENCES sales_invoice(sales_invoice_id)
);

CREATE TABLE service_invoice(
    service_invoice_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    car_id INTEGER NOT NULL,
    car_serial_num INTEGER NOT NULL,
    service_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (car_id) REFERENCES car(car_id)
);

CREATE TABLE service_line_item(
    service_line_item_id SERIAL PRIMARY KEY,
    service_invoice_id INTEGER NOT NULL,
    service_type VARCHAR(255) NOT NULL,
    service_cost DECIMAL(8, 2) NOT NULL,
    FOREIGN KEY (service_invoice_id) REFERENCES service_invoice(service_invoice_id)
);

CREATE TABLE mechanic(
    mechanic_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(255) NOT NULL
);

CREATE TABLE service_mechanics(
    service_mechanics_id SERIAL PRIMARY KEY,
    service_line_item_id INTEGER NOT NULL,
    mechanic_id INTEGER NOT NULL,
    FOREIGN KEY (service_line_item_id) REFERENCES service_line_item(service_line_item_id),
    FOREIGN KEY (mechanic_id) REFERENCES mechanic(mechanic_id)
);


--INSERT Section

INSERT INTO dealership(
	name,
	address,
	phone
)VALUES(
	'Audi Xpress Autos',
	'456 Audi town riverdale UT',
	'123-456-7896'
),(
	'MazdaDrive',
	'789 Mazda town salt lake city UT',
	'258-147-3698'
)

SELECT * FROM dealership d 


INSERT INTO customer(
	first_name,
	last_name,
	email,
	phone
)VALUES(
	'Brian',
	'Tucker',
	'brian@email.com',
	'123-987-7536'
),(
	'Gerry',
	'Kunis',
	'Gerry@email.com',
	'123-456-7896'
),(
	'Otis',
	'Carlson',
	'Otis.c@test.com',
	'456-123-7896'
	
)

SELECT *
FROM customer c 

INSERT INTO salesperson(
	dealership_id,
	first_name,
	last_name,
	email,
	phone,
	"position"
)VALUES(
	'1',
	'Tanner',
	'Gilton',
	'tgilton@dealer.com',
	'888-123-4578',
	'Sales Representative'
), (
	'2',
	'Kelly',
	'Seintown',
	'kseintown@dealer.com',
	'888-456-7896',
	'Sales Representative'
), (
	'2',
	'Frank',
	'Evans',
	'fevans@dealer.com',
	'888-145-3214',
	'Branch Manager'
), (
	'3',
	'Neil',
	'Doty',
	'ndory@dealer.com',
	'888-784-5896',
	'Sales Representative'
	
)

SELECT *
FROM salesperson s 



INSERT INTO car(
	car_serial_num,
	make,
	model,
	"year",
	color,
	price,
	"condition"
)VALUES (
	'12547858',
	'Mazda',
	'CX-5',
	'2020',
	'Silver',
	'22,000',
	'New'
), (
	'96541236',
	'Honda',
	'Civic',
	'2019',
	'Black',
	'20,000',
	'New'
),(	
	'85469325',
	'Mitsubishi',
	'Mirage',
	'2015',
	'White',
	'12,599',
	'New'
), (
	'85698742',
	'Audi',
	'Q7',
	'2017',
	'Black',
	'33,599',
	'Used'
)

SELECT * FROM car

INSERT INTO sales_invoice(
	customer_id,
	salesperson_id,
	car_id,
	car_serial_num,
	sale_date
)VALUES(
	2,
	1,
	1,
	12547858,
	'2021-11-20'
)


SELECT * FROM sales_invoice si 

INSERT INTO invoice_line_item (
	sales_invoice_id,
	"type",
	description,
	"cost"
)VALUES(
	1,
	'car sale',
	'purchase of Honda Civic',
	24459.00
), (
	'1',
	'warranty',
	'3 years warranty',
	500.00
)

INSERT INTO invoice_line_item (
	sales_invoice_id,
	"type",
	description,
	"cost"
)VALUES(
	3,
	'car sale',
	'purchase of Mazda CX-5',
	27559.00
), (
	'1',
	'warranty',
	'5 years/100 miles warranty',
	700.00
)


SELECT * FROM invoice_line_item 


CREATE OR REPLACE FUNCTION addInfo(
	customerId INT,
	carId INT,
	carSerialNum INT,
	serviceDate DATE
)
RETURNS INT
LANGUAGE plpgsql AS $$
BEGIN
	INSERT INTO service_invoice(
		customer_id,
		car_id,
		car_serial_num,
		service_date
	)VALUES(
		customerId,
		carId,
		carSerialNum,
		serviceDate
	);
	RETURN customerId;
END
$$

SELECT addInfo (3,4,85698742,'2021-09-15'), (3,4,85698742,'2021-12-20')

SELECT addInfo (3,4,85698742,'2021-12-20')

SELECT addInfo (3,4,85698742,'2021-09-15'), (3,4,85698742,'2021-12-20')

SELECT addInfo (2,1,12547858,'2020-11-15')

SELECT * FROM service_invoice si 

CREATE OR REPLACE FUNCTION serviceLineInfo(
	serviceInvoiceId INT,
	serviceType varchar,
	serviceCost decimal
)
RETURNS INT
LANGUAGE plpgsql AS $$
BEGIN
	INSERT INTO service_line_item(
		service_invoice_id,
		service_type,
		service_cost
	)VALUES(
		serviceInvoiceId,
		serviceType,
		serviceCost
	);
	RETURN serviceInvoiceId;
END
$$

SELECT serviceLineInfo (1,'Oil Change', '89.00')

SELECT serviceLineInfo (2,'Oil Change', '89.00')

SELECT serviceLineInfo (3,'Oil Change', '89.00')

SELECT serviceLineInfo (4,'Tire rotation', '130.00')

SELECT * FROM service_line_item sli 

INSERT INTO mechanic(
	name,
	phone
)VALUES (
	'Kyle Cruz',
	'222-365-1478'
), (
	'Sean Green',
	'541-258-3698'
), (
	'Monica Wright',
	'801-456-7896'
)

SELECT * FROM mechanic m 

INSERT INTO service_mechanics (
	service_line_item_id,
	mechanic_id 
)VALUES (
	1,
	2
), (
	2,
	3
), (
	4,
	2
)

SELECT * FROM service_mechanics sm 



