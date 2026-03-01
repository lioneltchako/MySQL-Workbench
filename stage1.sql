DROP TABLE IF EXISTS artist ;
CREATE TABLE IF NOT EXISTS artist (
  artist_id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(100) NULL,
  last_name VARCHAR(100) NULL,
  birth_date DATE NULL,
  death_date DATE NULL,
  nationality VARCHAR(50) NULL,
  PRIMARY KEY (artist_id)
) ;

DROP TABLE IF EXISTS artwork;
CREATE TABLE IF NOT EXISTS artwork (
  artwork_id INT NOT NULL AUTO_INCREMENT,
  artist_id INT NOT NULL,
  art_title VARCHAR(255) NULL,
  art_year INT(4) NULL,
  art_genre VARCHAR(100) NULL,
  art_type VARCHAR(100) NULL,
  PRIMARY KEY (artwork_id),
  INDEX fk_artwork_artist_idx (artist_id ASC),
  CONSTRAINT fk_artwork_artist
    FOREIGN KEY (artist_id)
    REFERENCES artist (artist_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ;

DROP TABLE IF EXISTS keyword;
CREATE TABLE IF NOT EXISTS keyword (
  keyword_id INT NOT NULL AUTO_INCREMENT,
  keyword VARCHAR(100) NULL,
  PRIMARY KEY (keyword_id),
  UNIQUE INDEX keyword_UNIQUE (keyword ASC)
) ;

DROP TABLE IF EXISTS artwork_keyword;
CREATE TABLE IF NOT EXISTS artwork_keyword (
  artwork_id INT NOT NULL,
  keyword_id INT NOT NULL,
  PRIMARY KEY (artwork_id, keyword_id),
  INDEX fk_artwork_has_keyword_keyword_idx (keyword_id ASC),
  INDEX fk_artwork_has_keyword_artwork_idx (artwork_id ASC),
  CONSTRAINT fk_artwork_has_keyword_artwork
    FOREIGN KEY (artwork_id)
    REFERENCES artwork (artwork_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_artwork_has_keyword_keyword
    FOREIGN KEY (keyword_id)
    REFERENCES keyword (keyword_id)
    ON DELETE CASCADE
) ;