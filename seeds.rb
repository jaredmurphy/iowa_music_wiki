
require 'pg'

if ENV["RACK_ENV"] == 'production'
  conn = PG.connect(
    dbname: ENV["POSTGRES_DB"],
    host: ENV["POSTGRES_HOST"],
    password: ENV["POSTGRES_PASS"],
    user: ENV["POSTGRES_USER"]
  )
else
  conn = PG.connect(dbname: "iowa_music_wiki")
end

CREATE TABLE bands(
 id      SERIAL PRIMARY KEY,
 name    VARCHAR,
 img_url VARCHAR,
 genre_one VARCHAR,
 location VARCHAR,
 description VARCHAR,
 website_url VARCHAR
);

CREATE TABLE albums(
 id      SERIAL PRIMARY KEY,
 name    VARCHAR(50),
 band VARCHAR NOT NULL,
 img_url VARCHAR NOT NULL,
 location VARCHAR NOT NULL,
 songs VARCHAR[] NOT NULL,
 listen_url VARCHAR NOT NULL,
 description VARCHAR NOT NULL
);

CREATE TABLE songs(
 id      SERIAL PRIMARY KEY,
 name    VARCHAR(50),
 img_url VARCHAR,
 band VARCHAR,
 album VARCHAR,
 lyrics TEXT,
 description VARCHAR
);

CREATE TABLE labels(
 id      SERIAL PRIMARY KEY,
 name    VARCHAR(50) UNIQUE,
 img_url VARCHAR NOT NULL,
 location VARCHAR NOT NULL,
 description VARCHAR NOT NULL,
 website_url VARCHAR NOT NULL
);

CREATE TABLE venues(
 id      SERIAL PRIMARY KEY,
 name    VARCHAR(50) UNIQUE,
 img_url VARCHAR NOT NULL,
 location VARCHAR NOT NULL,
 description VARCHAR NOT NULL,
 website_url VARCHAR NOT NULL
);

CREATE TABLE genres(
 id      SERIAL PRIMARY KEY,
 name    VARCHAR(50) UNIQUE,
 description VARCHAR
);


CREATE TABLE festivals(
 id      SERIAL PRIMARY KEY,
 name    VARCHAR(50) UNIQUE,
 img_url VARCHAR NOT NULL,
 location VARCHAR NOT NULL,
 description VARCHAR NOT NULL,
 website_url VARCHAR NOT NULL
);

CREATE TABLE studios(
 id      SERIAL PRIMARY KEY,
 name    VARCHAR(50) UNIQUE,
 img_url VARCHAR NOT NULL,
 location VARCHAR NOT NULL,
 description VARCHAR NOT NULL,
 website_url VARCHAR NOT NULL
);

CREATE TABLE record_stores(
 id      SERIAL PRIMARY KEY,
 name    VARCHAR(50) UNIQUE,
 img_url VARCHAR NOT NULL,
 location VARCHAR NOT NULL,
 description VARCHAR NOT NULL,
 website_url VARCHAR NOT NULL,
address VARCHAR NOT NULL
);

CREATE TABLE authors(
 id      SERIAL PRIMARY KEY,
 name    VARCHAR(50) UNIQUE,
 email VARCHAR UNIQUE,
 password VARCHAR,
 img_url VARCHAR NOT NULL,
 articles VARCHAR[] NOT NULL,
 description VARCHAR NOT NULL
);



-- CREATE TABLE musicians(
--   id           SERIAL PRIMARY KEY,
--   fname        VARCHAR NOT NULL,
--   lname        VARCHAR NOT NULL,
--   image_url    VARCHAR,
--   band         VARCHAR,
--   albums       VARCHAR,
--   band_id      INTEGER REFERENCES bands(id)
-- );

-- create bands
INSERT INTO bands
  (name, img_url, genre_one, location, description, website_url)
VALUES
  ('Mighty Shady', 'https://scontent-lga3-1.xx.fbcdn.net/hphotos-xtp1/v/t1.0-9/11703137_881388171896197_2019369173197765871_n.jpg?oh=348ec4f02948f6276fa6572dad3ec0aa&oe=573BFCCB',
    'rock', 'Des Moines', 'Mighty Shady was awesome', 'https://www.facebook.com/mightyshadymusic/'),
  ('Fire Sale', 'http://www.campeuforia.com/wp-content/uploads/2010/02/Firesalepic.jpg',
    'funk', 'Davenport', 'Fire Sale was awesome', 'https://www.facebook.com/firesaleband/'),
  ('Doctor Murdock', 'http://www.campeuforia.com/wp-content/uploads/2010/02/Dr-Murdock.jpg',
    'Progressive-Alt', 'Ames', 'Doctor Murdock is awesome','https://www.facebook.com/doctormurdockband'),
  ('The Candymakers', 'https://scontent-lga3-1.xx.fbcdn.net/hphotos-xta1/v/t1.0-9/12036662_1123911297638969_8377565350024694590_n.jpg?oh=329ffc7046a7abb3df6870d19775239b&oe=5741533F',
    'funk', 'Davenport', 'Ridiculicious', 'http://www.thecandymakers.com/');


INSERT INTO labels
  (name, img_url, location, description, website_url)
VALUES
  ('Nova Labs', 'http://www.desmoinesmc.com/wp-content/uploads/2013/07/902121_230047543808342_1506241622_o-e1374618618224.jpg',
   'Ames', 'Nova Labs is awesome', 'http://www.novalabs.info/'),
  ('Sump Pump Records', 'https://f1.bcbits.com/img/0004459910_10.jpg',
    'Des Moines', 'SP is awesome', 'https://sumppumprecords.bandcamp.com/'),
  ('Maximum Ames', 'https://pbs.twimg.com/profile_images/1422479522/MARLogoforFacebookTwitter_400x400.jpg',
     'Ames', 'Maximum Ames is awesome','http://maximumames.com/');

  INSERT INTO venues
  (name, img_url, location, description, website_url)
VALUES
  ('Woolys', 'http://41.media.tumblr.com/7e9a739702dd44d83b51b696d0a327b6/tumblr_muqdy63uhL1qzxbd5o1_1280.jpg',
   'Des Moines', 'Woolys is awesome', 'http://www.woolysdm.com/'),
  ('Iowa City Yacht Club', 'http://multimedia.jmc.uiowa.edu/caiello/files/2015/10/1.-outside-the-yacht-club-.jpg',
    'Iowa City', 'IC is awesome', 'http://www.iowacityyachtclub.org/'),
  ('DGs Taphouse', 'https://pbs.twimg.com/profile_images/623916040204857344/bnniaFba.jpg',
     'Ames', 'DGs is awesome','http://www.dgstaphouse.com/');
  INSERT INTO genres
  (name)
  VALUES
  ('alternative'), ('folk'), ('reggae'), ('funk'), ('rock'), ('jazz'), ('r&b'), ('metal'), ('indie'), ('jam'), ('ska');
