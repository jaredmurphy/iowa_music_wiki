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

conn.exec("DROP TABLE IF EXISTS articles")
conn.exec("CREATE TABLE articles(
	 id      SERIAL PRIMARY KEY,
	 name    VARCHAR(50),
	 img_url VARCHAR,
	 description VARCHAR,
	 author_id INTEGER,
	 category VARCHAR,
	 second_category VARCHAR,

	 location VARCHAR,
	 bands TEXT[][],
	 band_id VARCHAR,
	 label VARCHAR,
	 
	 website_url VARCHAR,
	 listen_url VARCHAR,
	 video_url VARCHAR,
	 
	 genres TEXT[][],
	 albums TEXT[][],


	 edited TIMESTAMP
	 )"
)


conn.exec("DROP TABLE IF EXISTS authors")
conn.exec("CREATE TABLE authors(
	id SERIAL PRIMARY KEY,
	username VARCHAR NOT NULL UNIQUE,
	email VARCHAR NOT NULL UNIQUE,
	password_digest VARCHAR NOT NULL,
	articles TEXT[][],
	edit_count INTEGER
	)"
)






