SELECT 
    CONCAT(a1.first_name, ' ', a1.last_name) AS artist_name,
    MONTHNAME(a1.birth_date) AS birth_month
FROM artist a1
INNER JOIN artist a2 
    ON MONTH(a1.birth_date) = MONTH(a2.birth_date) 
    AND a1.artist_id <> a2.artist_id
GROUP BY a1.artist_id
ORDER BY MONTH(a1.birth_date), artist_name;