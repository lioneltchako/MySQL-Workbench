SELECT 
    ar.artist_id, 
    ar.first_name, 
    ar.last_name,
    RANK() OVER (ORDER BY COUNT(a.artwork_id) DESC) AS artist_rank,
    COUNT(a.artwork_id) AS total_artworks
FROM artist ar
JOIN artwork a ON ar.artist_id = a.artist_id
GROUP BY ar.artist_id, ar.first_name, ar.last_name
ORDER BY artist_rank ASC, ar.artist_id ASC;