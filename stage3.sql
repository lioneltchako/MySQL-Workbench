SELECT AVG(keyword_count) AS avg_keywords
FROM (
    SELECT a.artwork_id, COUNT(ak.keyword_id) AS keyword_count
    FROM artist ar
    JOIN artwork a ON ar.artist_id = a.artist_id
    LEFT JOIN artwork_keyword ak ON a.artwork_id = ak.artwork_id
    WHERE ar.nationality = 'Dutch'
    GROUP BY a.artwork_id
) AS dutch_artwork_counts;