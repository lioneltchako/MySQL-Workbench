# The Data Modeler: Generative AI + MySQL Workbench Project

## Project Overview

This project demonstrates how to integrate **Generative AI chatbots** (e.g., ChatGPT, Gemini) with **MySQL Workbench** for **data modeling, population, and analysis**.

You will:

1. Design a database in **Third Normal Form (3NF)**.
2. Populate it with art data.
3. Perform analytical queries using **subqueries, aggregate functions, self-joins, and window functions**.

Generative AI is used as an **assistant** for generating SQL statements, but **MySQL Workbench remains the authoritative tool** for model validation and execution.

---

## Stage 1 – Data Modeling

### Objective

Create a **robust 3NF data model** and transform it into a functional database schema.

### Tables

* **artist**: Stores artist information; one-to-many with `artwork`.
* **artwork**: Stores artworks; belongs to one artist.
* **keyword**: Lookup table for artwork keywords.
* **artwork_keyword**: Bridge table for many-to-many relationships between `artwork` and `keyword`.

### Key Points

* Use `DATE` for `birth_date` and `death_date`.
* Use `INT(4)` for `art_year` to accommodate years outside `1901–2155`.
* Remove database names (`art`) and system variables (`ENGINE = InnoDB`) from generated SQL before submission.

### Example SQL

```sql
DROP TABLE IF EXISTS artist;
CREATE TABLE artist (
  artist_id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  birth_date DATE NOT NULL,
  death_date DATE NULL,
  nationality VARCHAR(45) NOT NULL,
  PRIMARY KEY (artist_id)
);

DROP TABLE IF EXISTS artwork;
CREATE TABLE artwork (
  artwork_id INT NOT NULL AUTO_INCREMENT,
  artist_id INT NOT NULL,
  art_title VARCHAR(255) NULL,
  art_year INT(4) NULL,
  art_genre VARCHAR(100) NULL,
  art_type VARCHAR(100) NULL,
  PRIMARY KEY (artwork_id),
  INDEX fk_artwork_artist_idx (artist_id ASC),
  CONSTRAINT fk_artwork_artist FOREIGN KEY (artist_id) REFERENCES artist (artist_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS keyword;
CREATE TABLE keyword (
  keyword_id INT NOT NULL AUTO_INCREMENT,
  keyword VARCHAR(100) NULL,
  PRIMARY KEY (keyword_id),
  UNIQUE INDEX keyword_UNIQUE (keyword ASC)
);

DROP TABLE IF EXISTS artwork_keyword;
CREATE TABLE artwork_keyword (
  artwork_id INT NOT NULL,
  keyword_id INT NOT NULL,
  PRIMARY KEY (artwork_id, keyword_id),
  INDEX fk_artwork_has_keyword_keyword_idx (keyword_id ASC),
  INDEX fk_artwork_has_keyword_artwork_idx (artwork_id ASC),
  CONSTRAINT fk_artwork_has_keyword_artwork FOREIGN KEY (artwork_id) REFERENCES artwork (artwork_id) ON DELETE CASCADE,
  CONSTRAINT fk_artwork_has_keyword_keyword FOREIGN KEY (keyword_id) REFERENCES keyword (keyword_id) ON DELETE CASCADE
);
```

---

## Stage 2 – Let Generative AI Be Your Assistant

### Objective

Populate the database using **INSERT statements**, assisted by Generative AI or MySQL Workbench.

### Key Points

* AI can generate INSERT statements for `artist`, `artwork`, `keyword`, and `artwork_keyword`.
* Carefully **verify AI-generated data** before insertion.
* Remove the database name from the generated INSERTs before submitting.

### Example SQL

```sql
INSERT INTO artist (first_name, last_name, birth_date, death_date, nationality) VALUES
('Leonardo', 'da Vinci', '1452-04-15', '1519-05-02', 'Italian'),
('Vincent', 'van Gogh', '1853-03-30', '1890-07-29', 'Dutch'),
('Pablo', 'Picasso', '1881-10-25', '1973-04-08', 'Spanish');

INSERT INTO keyword (keyword) VALUES
('Portrait'), ('Smile'), ('Iconic');

INSERT INTO artwork_keyword (artwork_id, keyword_id) VALUES
(1, 1), (1, 2), (1, 3);
```

---

## Stage 3 – Keywords Used by Dutch Artists

### Objective

Find the **average number of keywords** associated with artworks by Dutch artists.

### Key Concepts

* **Subqueries**: Nested queries for counting keywords per artwork.
* **Aggregate functions**: `COUNT()` and `AVG()` to summarize data.
* **LEFT JOIN**: Ensures artworks with no keywords are counted.

### SQL Query

```sql
SELECT AVG(keyword_count) AS avg_keywords
FROM (
    SELECT a.artwork_id, COUNT(ak.keyword_id) AS keyword_count
    FROM artist ar
    JOIN artwork a ON ar.artist_id = a.artist_id
    LEFT JOIN artwork_keyword ak ON a.artwork_id = ak.artwork_id
    WHERE ar.nationality = 'Dutch'
    GROUP BY a.artwork_id
) AS dutch_artwork_counts;
```

---

## Stage 4 – Artists That Share a Birth Month

### Objective

List all artists **born in the same month** using a **self-join**.

### Key Concepts

* **Self-join**: Table joined to itself to compare rows.
* **MONTH() / MONTHNAME()**: Extract numeric or textual month.
* **Exclusion**: Avoid matching an artist with themselves (`a1.artist_id <> a2.artist_id`).

### SQL Query

```sql
SELECT 
    CONCAT(a1.first_name, ' ', a1.last_name) AS artist_name,
    MONTHNAME(a1.birth_date) AS birth_month
FROM artist a1
INNER JOIN artist a2 
    ON MONTH(a1.birth_date) = MONTH(a2.birth_date) 
    AND a1.artist_id <> a2.artist_id
GROUP BY a1.artist_id
ORDER BY MONTH(a1.birth_date), artist_name;
```

---

## Stage 5 – Artists Rankings

### Objective

Rank artists based on the **number of artworks** they have created using **window functions**.

### Key Concepts

* **Window function**: `RANK() OVER (ORDER BY COUNT(a.artwork_id) DESC)` assigns a rank per artist.
* **Grouping**: Aggregate artworks per artist before ranking.
* **Ties**: Artists with the same count share the same rank.

### SQL Query

```sql
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
```

---

## Outcome

By completing all five stages, you will have:

1. Designed a **3NF-compliant data model**.
2. Populated it with **art data**.
3. Learned to **analyze data** using:

   * Subqueries
   * Aggregate functions
   * Self-joins
   * Window functions
4. Integrated **Generative AI** as an **assistant** for SQL generation.
5. Gained hands-on experience with **MySQL Workbench** from **modeling to analytics**.

---

## Notes

* Always validate **AI-generated SQL** in MySQL Workbench.
* Remove unnecessary **database names** or system variables from generated scripts.
* For analytics, break queries into **inner and outer components** for easier debugging.
* Keep outputs **ordered and grouped** for readability.



If you want, I can also **add a small “Getting Started” section with setup instructions** to make it fully GitHub-ready. Do you want me to do that?
