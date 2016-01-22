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

conn.exec("DROP TABLE IF EXISTS albums")
conn.exec("CREATE TABLE albums(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50),
	 band VARCHAR,
	 img_url VARCHAR,
	 listen_url VARCHAR,
	 description VARCHAR
	 )"
)

conn.exec("DROP TABLE IF EXISTS articles")
conn.exec("CREATE TABLE articles(
	id SERIAL PRIMARY KEY,
	category VARCHAR,
	author_id VARCHAR

	)"
)

conn.exec("DROP TABLE IF EXISTS authors")
conn.exec("CREATE TABLE authors(
	id SERIAL PRIMARY KEY,
	username VARCHAR NOT NULL UNIQUE,
	email VARCHAR NOT NULL UNIQUE,
	password_digest VARCHAR NOT NULL,
	edit_count INTEGER
	)"
)

conn.exec("DROP TABLE IF EXISTS bands")
conn.exec("CREATE TABLE bands(
   id      SERIAL PRIMARY KEY,
   name    VARCHAR(50) UNIQUE,
   img_url VARCHAR,
   genre_one VARCHAR,
   location VARCHAR,
   description VARCHAR,
   author_id VARCHAR,
   website_url VARCHAR,
   edited TIMESTAMP
  )"
)


conn.exec("DROP TABLE IF EXISTS edits")
conn.exec("CREATE TABLE edits(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50) UNIQUE,
	 date TIMESTAMPTZ default current_timestamp,
	 author VARCHAR,
	 description VARCHAR
	)"
)

conn.exec("DROP TABLE IF EXISTS festivals")
conn.exec("CREATE TABLE festivals(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50) UNIQUE,
	 img_url VARCHAR NOT NULL,
	 location VARCHAR NOT NULL,
	 description VARCHAR NOT NULL,
	 website_url VARCHAR NOT NULL
	)"
)

conn.exec("DROP TABLE IF EXISTS genres")
conn.exec("CREATE TABLE genres(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50) UNIQUE,
	 description VARCHAR
	)"
)

conn.exec("DROP TABLE IF EXISTS labels")
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

conn.exec("DROP TABLE IF EXISTS record_stores")
conn.exec("CREATE TABLE record_stores(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50) UNIQUE,
	 img_url VARCHAR,
	 location VARCHAR,
	 description VARCHAR,
	 website_url VARCHAR
	)"
)

conn.exec("DROP TABLE IF EXISTS songs")
conn.exec("CREATE TABLE songs(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50),
	 band VARCHAR,
	 album VARCHAR,
	 lyrics TEXT,
	 description VARCHAR
	 )"
)

conn.exec("DROP TABLE IF EXISTS studios")
conn.exec("CREATE TABLE studios(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50) UNIQUE,
	 img_url VARCHAR,
	 location VARCHAR,
	 description VARCHAR,
	 website_url VARCHAR
	)"
)

conn.exec("DROP TABLE IF EXISTS venues")
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




