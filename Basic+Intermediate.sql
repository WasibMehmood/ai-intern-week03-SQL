--List all films released in 2006.

SELECT title 
FROM film 
WHERE release_year = 2006;


--Find the first and last name of customers who live in Canada.

SELECT first_name, last_name
FROM customer 
WHERE 

--Get the titles of films with a rental rate greater than $4.

SELECT title
FROM film
WHERE rental_rate > 4.00;

--Show the full name of all staff members and their email addresses.

SELECT (first_name,last_name) AS full_name, email
FROM staff;

--List the 10 longest films (by length in minutes).

SELECT title, "length"
FROM film
ORDER BY "length" DESC
LIMIT 10;

--Find the total number of customers in each city.

SELECT COUNT(customer_id) as count_of_customers
FROM customer
GROUP BY count(custom);

--Which category has the most films?

SELECT c.name AS category,
COUNT(fc.film_id) AS film_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY film_count DESC
LIMIT 1;

--Get all actors who have acted in the film “ACADEMY DINOSAUR”.

SELECT (a.first_name,a.last_name) AS actor_names
FROM actor a
JOIN film_actor fa
ON fa.actor_id = a.actor_id
JOIN film f
ON f.film_id = fa.film_id
WHERE f.title  = 'Academy Dinosaur';

--Find customers who have never made a payment.

SELECT c.first_name,c.last_name
FROM customer c
LEFT JOIN payment p
ON p.customer_id = c.customer_id
WHERE p.payment_id IS NULL;

--List all films that are rated ‘PG-13’.

SELECT title
FROM film
WHERE rating = 'PG-13';

--Show the top 5 customers by total payments.

SELECT c.first_name,c.last_name,SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p
ON p.customer_id = c.customer_id
GROUP BY c.customer_id,c.first_name,c.last_name
ORDER BY total_payment DESC
LIMIT 5;

--Find the average rental duration of all films.

SELECT title,ROUND(AVG(rental_duration),2) as avg_rental_duration
FROM film
GROUP BY title;

--List customers whose last name starts with ‘S’.

SELECT first_name,last_name
FROM customer
WHERE last_name LIKE 'S%';

--How many films are available in inventory for each store?

SELECT s.store_id,
COUNT(i.inventory_id) AS films_available
FROM store s
JOIN inventory i ON s.store_id = i.store_id
GROUP BY s.store_id;

--Get all payments made in the month of Feburary 2007.
SELECT payment_id, customer_id, amount, payment_date
FROM payment
WHERE EXTRACT(MONTH FROM payment_date) = 2
AND EXTRACT(YEAR FROM payment_date) = 2007;

--List all first names from customers and staff.

SELECT first_name
FROM customer
UNION
SELECT first_name 
FROM staff;

--List all email addresses from customers and staff.
SELECT email 
FROM customer
UNION 
SELECT email
FROM staff;
--Show all cities and countries in one column.
SELECT city AS combined_city_country
FROM city
UNION ALL
SELECT country
FROM country;
--List all film titles and category names in a single column.
SELECT title
FROM film
UNION ALL
SELECT 'name'
FROM category;
--Show all customer IDs and staff IDs together.
SELECT customer_id
FROM customer
UNION
SELECT staff_id
FROM staff;
--List all customer last names and actor last names.
SELECT last_name
FROM customer
UNION
SELECT last_name
FROM actor;
--Show all store IDs and staff IDs in one result.
SELECT store_id
FROM store
UNION ALL
SELECT staff_id
FROM staff;

--Show all actor first names and customer first names.
SELECT first_name
FROM customer
UNION
SELECT first_name
FROM actor;
--List all addresses from customers and from staff.

SELECT address 
FROM address a
JOIN customer c
ON c.address_id = a.address_id
WHERE c.address_id = a.address_id
UNION ALL
SELECT address 
FROM address a
JOIN staff s
ON s.address_id = a.address_id
WHERE s.address_id = a.address_id;