require 'pg'

if ENV["RACK_ENV"] == 'production'
  conn = PG.connect(
    dbname: ENV["POSTGRES_DB"],
    host: ENV["POSTGRES_HOST"],
    password: ENV["POSTGRES_PASS"],
    user: ENV["POSTGRES_USER"]
  )
else
  conn = PG.connect(dbname: "iowa_music_wiki_db")
end

conn.exec("CREATE TABLE albums(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50),
	 band VARCHAR,
	 img_url VARCHAR,
	 location VARCHAR,
	 songs VARCHAR[],
	 listen_url VARCHAR,
	 description VARCHAR
	 )"
)

conn.exec("CREATE TABLE articles(
	id SERIAL PRIMARY KEY,
	category VARCHAR,
	author VARCHAR
	)"
)

conn.exec("CREATE TABLE bands(
   id      SERIAL PRIMARY KEY,
   name    VARCHAR(50) UNIQUE,
   img_url VARCHAR,
   genre_one VARCHAR,
   location VARCHAR,
   description VARCHAR,
   website_url VARCHAR
  )"
)

	conn.exec("INSERT INTO bands (name, img_url, genre_one, location, description, website_url) VALUES (
	      'Mighty Shady',
	      'https://scontent-lga3-1.xx.fbcdn.net/hphotos-xtp1/v/t1.0-9/11703137_881388171896197_2019369173197765871_n.jpg?oh=348ec4f02948f6276fa6572dad3ec0aa&oe=573BFCCB',
	      'rock', 
	      'Des Moines', 
	      'Mighty Shady was awesome', 
	      'https://www.facebook.com/mightyshadymusic/'
		  )"
	)

	conn.exec("INSERT INTO bands (name, img_url, genre_one, location, description, website_url) VALUES (
	    'Fire Sale', 
	    'http://www.campeuforia.com/wp-content/uploads/2010/02/Firesalepic.jpg',
	    'funk', 
	    'Davenport', 
	    'Fire Sale was awesome', 
	    'https://www.facebook.com/firesaleband/'
		)"
	)

	conn.exec("INSERT INTO bands (name, img_url, genre_one, location, description, website_url) VALUES (
	    'The Candymakers', 
	    'https://scontent-lga3-1.xx.fbcdn.net/hphotos-xta1/v/t1.0-9/12036662_1123911297638969_8377565350024694590_n.jpg?oh=329ffc7046a7abb3df6870d19775239b&oe=5741533F',
	    'funk', 
	    'Davenport', 
	    'Ridiculicious', 
	    'http://www.thecandymakers.com/'
		)"
	)

conn.exec("CREATE TABLE edits(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50) UNIQUE,
	 date TIMESTAMP,
	 author VARCHAR,
	 description VARCHAR
	)"
)

conn.exec("CREATE TABLE festivals(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50) UNIQUE,
	 img_url VARCHAR NOT NULL,
	 location VARCHAR NOT NULL,
	 description VARCHAR NOT NULL,
	 website_url VARCHAR NOT NULL
	)"
)

conn.exec("CREATE TABLE genres(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50) UNIQUE,
	 description VARCHAR
	)"
)

conn.exec("CREATE TABLE labels(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50),
	 img_url VARCHAR,
	 bands VARCHAR,
	 albums VARCHAR,
	 location VARCHAR,
	 website_url VARCHAR,
	 description VARCHAR
	 )"
)

conn.exec("CREATE TABLE record_stores(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50) UNIQUE,
	 img_url VARCHAR,
	 location VARCHAR,
	 description VARCHAR,
	 website_url VARCHAR,
	 address VARCHAR
	)"
)

conn.exec("CREATE TABLE songs(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50),
	 img_url VARCHAR,
	 band VARCHAR,
	 album VARCHAR,
	 lyrics TEXT,
	 description VARCHAR
	 )"
)

conn.exec("CREATE TABLE studios(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50) UNIQUE,
	 img_url VARCHAR,
	 location VARCHAR,
	 description VARCHAR,
	 website_url VARCHAR
	)"
)

conn.exec("CREATE TABLE venues(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50) UNIQUE,
	 img_url VARCHAR,
	 location VARCHAR,
	 description VARCHAR,
	 address VARCHAR,
	 website_url VARCHAR
	)"
)




