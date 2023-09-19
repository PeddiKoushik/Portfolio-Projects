/* Q1: Return all the track names that have a song length longer than the average song leght.
return the name and milliseconds for each track. Order by the song length with lingest songs
listed firs*/
SELECT name, milliseconds
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds)  AS avg_track_length
FROM track)
ORDER BY milliseconds DESC




/* Q2: Let's invite the asrtists who have written the most rock music in
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



  
/* Q3: Find how much amount spent by each customers on artists? wrtie a
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
