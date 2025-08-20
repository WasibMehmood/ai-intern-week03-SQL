--WINDOWS FUNCTIONS
/* Show each customer’s 
total payments along with the average payment amount across all customers.
*/
SELECT c.customer_id,CONCAT(c.first_name, ' ',c.last_name) AS customer_name,
SUM(p.amount) AS total_payment,
AVG(SUM(p.amount)) OVER() AS avg_payment_all_customers
FROM customer c
JOIN payment p
ON p.customer_id = c.customer_id
GROUP BY c.customer_id,c.first_name,c.last_name
ORDER BY total_payment DESC;

/*For each film, 
display the film title and 
its rental duration, plus the maximum rental duration of all films.*/
SELECT f.title,f.rental_duration,
MAX(f.rental_duration) OVER() AS max_rental
FROM film f 
ORDER BY max_rental DESC;


/*
List each payment and show the running total (cumulative sum) of payments per customer.
*/

SELECT c.customer_id,CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
p.payment_id,
p.payment_date,
p.amount,
SUM(p.amount) OVER ( PARTITION BY c.customer_id ORDER BY p.payment_date) AS running_total
FROM customer c
JOIN payment p 
    ON p.customer_id = c.customer_id
ORDER BY c.customer_id, p.payment_date;

/*
Show each rental and the previous rental date for the same customer.
*/

SELECT r.rental_id,r.customer_id,CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
r.rental_date,
LAG(r.rental_date) OVER (PARTITION BY r.customer_id ORDER BY r.rental_date)
AS previous_rental_date
FROM rental r
JOIN customer c
    ON c.customer_id = r.customer_id
ORDER BY r.customer_id, r.rental_date;

/*For each customer, show their payments with a row number in order of payment date.*/

SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name,p.payment_id,p.payment_date,
ROW_NUMBER() OVER(PARTITION BY c.customer_id ORDER BY p.payment_date) AS row_num
FROM customer c
JOIN payment p 
ON p.customer_id = c.customer_id
ORDER BY c.customer_id,p.payment_date;

/*
Find each film’s length and its rank in length compared to other films.*/
SELECT title,length, 
RANK() OVER(ORDER BY length DESC) as len_rank
FROM film;

/*Show each category and the average rental rate for films in that category.*/

SELECT c.name AS category,AVG(f.rental_rate) AS avg_rental_per_category
FROM film f
JOIN film_category fc 
ON fc.film_id = f.film_id
JOIN category c
ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY avg_rental_per_category DESC;

/*Display each staff member’s payments along with the percentage
contribution of each payment compared to their total.*/

SELECT s.staff_id,CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
p.payment_id,p.amount,
ROUND((p.amount * 100.0 / SUM(p.amount) OVER (PARTITION BY s.staff_id))2) 
AS percentage_contribution
FROM staff s
JOIN payment p 
ON s.staff_id = p.staff_id
ORDER BY s.staff_id, p.payment_id;
