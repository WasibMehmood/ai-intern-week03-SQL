--TEMPORARY TABLES

--Create a temp table of all customers from Canada, then select their names.
CREATE TEMPORARY TABLE customer_from_canada AS
SELECT c.first_name,c.last_name,ci.city 
FROM customer c 
JOIN address a 
ON a.address_id = c.address_id
JOIN city ci 
ON ci.city_id = a.city_id
JOIN country co
ON co.country_id = ci.country_id
WHERE co.country = 'Canada';

SELECT CONCAT(first_name,' ',last_name) AS customer_names
FROM customer_from_canada;
------------------------------------------------------------
--Create a temp table of films released after 2005 and list their titles.

CREATE TEMPORARY TABLE films_after_2005 AS
SELECT *
FROM film
WHERE release_year >= 2006;

SELECT title
FROM films_after_2005;

-------------------------------------------------------------------
--Create a temp table that stores total payments per customer,
--then select customers who paid more than 100.
CREATE TEMPORARY TABLE payment_per_customer AS
SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) as customer_name,
SUM(p.amount) as total_payment
FROM customer c
JOIN payment p 
ON p.customer_id = c.customer_id
GROUP BY c.customer_id,c.first_name,c.last_name;

SELECT * FROM payment_per_customer;
SELECT customer_name
FROM payment_per_customer
WHERE total_payment > 100;

----------------------------------------------------------
--Store the number of rentals per film in a temp table,
--then select the film with the maximum rentals.
CREATE TEMPORARY TABLE rental_per_film AS 
SELECT COUNT(r.rental_id) as rental_count,f.title
FROM film f
JOIN inventory i
ON i.film_id = f.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
GROUP BY f.title;

SELECT MAX(rental_count) AS max_rental,title 
FROM rental_per_film
GROUP BY title,rental_count
ORDER BY rental_count DESC
LIMIT 1;


--------------------------------------------------------------
--Create a temp table of staff 
--members and their total payments processed, then rank them by total revenue.
CREATE TEMPORARY TABLE staff_payment AS 
SELECT s.staff_id,CONCAT(s.first_name,' ',s.last_name) as staff_name,
SUM(p.amount) as total_revenue,
RANK() OVER(ORDER BY SUM(p.amount) DESC) AS payment_rank
FROM staff s
JOIN payment p
ON p.staff_id = s.staff_id
GROUP BY s.staff_id,s.first_name,s.last_name;

SELECT * FROM staff_payment;

---------------------------------------------------------
--Create a temp table with film categories and total films,
--then filter to only show categories with more than 65 films.
CREATE TEMPORARY TABLE temp_category AS
SELECT c.name AS category,COUNT(f.film_id) as total_films
FROM film f
JOIN film_category fc 
ON fc.film_id = f.film_id
JOIN category c 
ON c.category_id = fc.category_id
GROUP BY c.name;

SELECT category
FROM temp_category
WHERE total_films > 65;

------------------------------------------------
/*Create a temp table with each customer’s 
running total of payments and query the top 5.*/
CREATE TEMPORARY TABLE cus_runnig_total AS
SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) as customer_name,
p.payment_id,p.payment_date,
SUM(p.amount) OVER(PARTITION BY c.customer_id ORDER BY p.payment_date) AS running_total
FROM customer c
JOIN payment p
ON p.customer_id = c.customer_id
ORDER BY c.customer_id, p.payment_date;

WITH latest_running AS (
SELECT customer_id, customer_name, running_total,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date DESC) AS rn
FROM cus_runnig_total
)
SELECT customer_name, running_total
FROM latest_running
WHERE rn = 1
ORDER BY running_total DESC
LIMIT 5;

-- Function to return top 10 films
CREATE OR REPLACE FUNCTION top_10_films()
RETURNS TABLE(film_id INT, title TEXT, length INT, rental_rate NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT f.film_id, f.title, f.length, f.rental_rate
    FROM film f
    ORDER BY f.rental_rate DESC
    LIMIT 10;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM top_10_films();
