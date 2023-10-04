/*This Project is about a Music Store which sells Music Albums. In this imaginary project the client(Music Store) asks for various amounts of information
for solving their problem. Given below is a query in PostgreSQL to provide required information as per client's specific need
Note: The dataset is collected from a Youtuber's GitHub */

/*Who is the senior most employee based on Job title*/
SELECT *
FROM employee
ORDER BY levels desc
LIMIT 1


/*Which countires have the most Invoices */
SELECT COUNT(*) AS c, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY c DESC


/*What are the top 3 values of total invoice*/
SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 1


/*Which city has the best customers? We would like to throw a promotional Music festival in the 
City we made the most money. Write a query that returns one city that has the highest sum of invoice totals.
Return both the city name & sum of all invoice total*/
SELECT SUM(total) as invice_total, billing_city
FROM invoice
GROUP BY billing _city
ORDER BY invoice_total DESC


/*Who is the best customer? The customer who has spent the most money will be declared the best customer*/
SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) AS total
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total DESC
LIMIT 1


/*List of email, first name, last name and Genre of all Rock music listeners. Return your ordered
alphabetically by email*/
SELECT DISTINCE email, first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoiceline ON invoice.invoice_id = invoiceline.invoice_id
WHERE track_id IN(
    SELECT track_id
    FROM track
    JOIN genre ON track.genre_id = genre.genre_id
    WHERE genre.name LIKE 'ROCK'
)
ORDER BY email


/* Let's invite the artists who have wrtitten the most rock music in the dataset . A query
for the Artist name and total track count of the top 10 bands*/
SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS number _of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artis.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY number_of_songs DESC
LIMIT 10

    
/* Return all the track names that have a song length longer than the average song leght.
return the name and milliseconds for each track. Order by the song length with lingest songs
listed firs*/
SELECT name, milliseconds
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds)  AS avg_track_length
FROM track)
ORDER BY milliseconds DESC


/*Let's invite the asrtists who have written the most rock music in
our dataset. Write a query that returns the Artist name and total
trackk count of the top 10 bands*/
SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id =track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10

  
/*Find how much amount spent by each customers on highest selling artist? wrtie a
query to return customer name, artist name and total spent*/
WITH best_selling_artist AS(
SELECT artist.artist_id AS artist_id, artist.name AS artist_name,
SUM(invoice_line.unit_price*invoice_line.quantity)AS total_sales
FROM invoice_line
JOIN track ON track.track_id = invoice_line.track_id
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 1
)
SELECT c.customer_id, c.first_name,c.last_name, bsa.artist_id,
SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id =i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id =t.album_id
JOIN best_selling_artist bsa on bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC


/*Find out the most popular Genre in each country. We determine the most popular genre as the genre
with highest amount of purchases*/
WITH RECURSIVE
sales_per_country AS (
    SELECT COUNT(*) AS purchase_per_genre, customer.country, genre.name, genre.genre_id
    FROM invoice_line
    JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
    JOIN customer ON custommer.customer_id = invoice.customer_id
    JOIN track ON track.track_id = invoice_line.tracck_id
    JOIN genre ON genre.genre_id = track.genre_id
    GROUP BY 2,3,4
    ORDER BY 2
),
max_genre_per_country AS (SELECT MAX(purchase_per_genre) AS max_genre_number), country
FROM sales_per_country
GROUP BY 2
ORDER BY 2


/* Query determing the customer that has spent the most on music for each country.The information
needed for the query is country, name of customer, amount spent*/
WITH RECURSIVE
    customer_with_country AS (
    SELECT customer.customer_id, first_name, last_name, billing_country, SUM(total) AS total_spending
    FROM invoice
    JOIN customer ON customer.customer_id = invoice.customer_id
    GROUP BY 1,2,3,4),
  country_max_spending AS(
    SELECT billing_country, MAX(total_spending) AS max_spending
    FROM customer_with_country
    GROUP BY billing_country)

SELECT cc.billing_country, cc.total_spending, cc.first_name, cc.last_name
FROM customer_withcountry cc
JOIN country_max_spending ms
ON cc.billing_country = ms.billing_country
WHERE cc.total_spending = ms.max_spending
ORDER BY 1
