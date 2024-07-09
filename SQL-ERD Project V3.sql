create table "Salesperson_ND"  (
	salesperson_id VARCHAR(100) primary key,
	salesperson_name VARCHAR(100)
);


create table "Customer_ND" (
	customer_id VARCHAR (100) primary key,
	customer_name VARCHAR (100)
);

create table "Car_ND" (
	car_id VARCHAR (100) primary key,
	car_model VARCHAR (100),
	car_type VARCHAR (100),
	car_price DECIMAL (10, 2)
);

create table "Invoice_ND" (
	invoice_id VARCHAR(100) primary key,
	invoice_number VARCHAR(100),
	salesperson_id VARCHAR(100),
	customer_id VARCHAR(100),
	car_id VARCHAR(100),
	FOREIGN KEY (salesperson_id) REFERENCES "Salesperson_ND"(salesperson_id),
    FOREIGN KEY (customer_id) REFERENCES "Customer_ND"(customer_id),
    FOREIGN KEY (car_id) references "Car_ND" (car_id)
);

create table "Ticket_ND" (
	ticket_id VARCHAR (100) primary key,
	customer_id VARCHAR (100),
	car_id VARCHAR (100),
	FOREIGN KEY (customer_id) REFERENCES "Customer_ND"(customer_id),
	FOREIGN KEY (car_id) REFERENCES "Car_ND"(car_id)
);

create table "Mechanic_ND"(
 	mechanic_id VARCHAR (100) primary key,
 	mechanic_name VARCHAR (100)
);

create table "Parts_ND" (
	part_id VARCHAR (100) primary key,
	part_type VARCHAR (100),
	part_price DECIMAL (10, 2)
);

create table "ServiceHistory_ND" (
	history_id VARCHAR(100) primary key,
	car_id VARCHAR(100),
	service_description VARCHAR(250),
	FOREIGN KEY (car_id) references "Car_ND"(car_id)
);

--insert data into tables
insert into "Salesperson_ND" (salesperson_id, salesperson_name)
values ('SP100', 'Jayden'), ('SP101', 'AShton');

insert into "Customer_ND" (customer_id, customer_name)
values ('CUSHR1', 'Henry Roberts'), ('CUSGP2', 'Grace Price');

insert into "Car_ND" (car_id, car_model, car_Type, car_price)
values ('JW123', 'Wrangler', 'Jeep', '75000.00'), ('CEQ234','Equinox','Chevrolet','65000.00');

insert into "Invoice_ND" (invoice_id, invoice_number, salesperson_id, customer_id, car_id)
values ('INV001', '001', 'SP100', 'CUSHR1', 'JW123'), ('INV002', '002', 'SP101', 'CUSGP2', 'CEQ234');

insert into "Ticket_ND" (ticket_id, customer_id, car_id)
values ('TIC001','CUSHR1','JW123'), ('TIC002', 'CUSGP2', 'CEQ234');

insert into "Mechanic_ND" (mechanic_id, mechanic_name)
values ('MECH256', 'Paul Miller'), ('MECH038', 'Jacob Brown');

insert into "Parts_ND" (part_id, part_type, part_price)
values ('par001','brake','200.00'), ('par200','battery testing','45.00');

insert into "ServiceHistory_ND" (history_id, car_id, service_description)
values ('HIS456', 'JW123', 'Brake Replacement'), ('HIS567', 'CEQ234','Battery Testing');

--Function to calculate cost of break replacement
CREATE OR REPLACE FUNCTION calculate_brake_replacement_cost(car_id VARCHAR)
RETURNS DECIMAL AS $$
DECLARE
    brake_price DECIMAL;
BEGIN
    SELECT part_price INTO brake_price
    FROM "Parts_ND"
    WHERE part_type = 'brake';
    RETURN brake_price;
END;
$$ LANGUAGE plpgsql;


--Function to calculate the revenue amount for a salesperson
CREATE OR REPLACE FUNCTION calculate_salesperson_revenue(salesperson_id VARCHAR)
RETURNS DECIMAL AS $$
DECLARE
    total_revenue DECIMAL;
BEGIN
    SELECT SUM("Car_ND".car_price) INTO total_revenue
    FROM "Invoice_ND"
    JOIN "Car_ND" ON "Invoice_ND".car_id = "Car_ND".car_id
    WHERE "Invoice_ND".salesperson_id = calculate_salesperson_revenue.salesperson_id;
    
    RETURN total_revenue;
END;
$$ LANGUAGE plpgsql;




