--ADVANCE SQL

--List the top 10 customers by total payments, and also show their rank.
SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) AS customer_name,
	SUM(p.amount) AS total_payment,
	RANK() OVER(ORDER BY SUM(p.amount) DESC) AS payment_rank
FROM customer c
JOIN payment p
ON p.customer_id = c.customer_id
GROUP BY c.customer_id,c.first_name,c.last_name
LIMIT 10;

--For each film category, rank films by rental count (most rented first).
SELECT f.title AS film_title,c.name AS category, COUNT(r.rental_id) AS rental_count,
    RANK() OVER (
        PARTITION BY c.name 
        ORDER BY COUNT(r.rental_id) DESC
    ) AS rental_rank
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON f.film_id = fc.film_id
JOIN inventory i 
ON i.film_id = f.film_id
JOIN rental r 
ON r.inventory_id = i.inventory_id
GROUP BY c.name,f.title,f.rental_rate
ORDER BY c.name,rental_rate DESC;

--Find the top 5 customers by total payments using a CTE.
WITH CTE AS
(
SELECT c.customer_id,CONCAT(c.first_name, ' ',c.last_name) AS customer_name,
SUM(p.amount) as total_payment
FROM customer c
JOIN payment p
ON p.customer_id = c.customer_id
GROUP BY c.customer_id,c.first_name,c.last_name
)
SELECT customer_name,total_payment
FROM CTE
ORDER BY total_payment DESC
LIMIT 5;

---List films longer than the average film length.
WITH avg_films_len AS
(
SELECT ROUND(AVG(length),2) as avg_len
FROM film
)
SELECT film_id,title,length,avg_len
FROM film f
CROSS JOIN avg_films_len a
WHERE f.length > a.avg_len
ORDER BY a.avg_len DESC;

--Find customers who rented more than 30 films.
WITH customer_rental AS
(
SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) as customer_name,
COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r
ON r.customer_id = c.customer_id
GROUP BY c.customer_id,c.first_name,c.last_name
)
SELECT customer_name,rental_count
FROM customer_rental
WHERE rental_count >= 30
ORDER BY rental_count DESC;

--Show each city with total customers.
WITH CTE AS
(SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) AS customer_name,ci.city
FROM customer c
	JOIN address a
ON a.address_id = c.address_id
	JOIN city ci
ON ci.city_id = a.city_id
GROUP BY c.customer_id,c.first_name,c.last_name,ci.city
)
SELECT COUNT(customer_id) AS total_customer,city
FROM CTE
GROUP BY city

/*List all categories with their total film count*/
WITH film_counts AS (
SELECT c.name AS category, COUNT(fc.film_id) AS total_films
FROM category c 
JOIN film_category fc 
ON c.category_id = fc.category_id
GROUP BY c.name
)
SELECT *
FROM film_counts
ORDER BY total_films DESC;
