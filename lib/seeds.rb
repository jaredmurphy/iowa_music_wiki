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
	 author_id VARCHAR,
	 category VARCHAR,
	 second_category VARCHAR,

	 location VARCHAR,
	 bands TEXT[][],
	 band_id VARCHAR,
	 label_id VARCHAR,
	 
	 website_url VARCHAR,
	 listen_url VARCHAR,
	 
	 genres TEXT[][],
	 albums TEXT[][],

	 edited TIMESTAMP
	 )"
)

conn.exec("INSERT INTO articles (name, description, category, author_id) VALUES (
	      'Mighty Shady',
	      'was a band',
	      'bands', 
	      '1'
		  )"
	)
conn.exec("INSERT INTO articles (name, description, category, author_id) VALUES (
	      'DGs Taphouse',
	      'is a venue',
	      'venues', 
	      '1'
		  )"
	)
conn.exec("INSERT INTO articles (name, description, category, author_id) VALUES (
	      'Nova Labs',
	      'is a label',
	      'labels', 
	      '1'
		  )"
	)
conn.exec("INSERT INTO articles (name, description, category, author_id) VALUES (
	      'DoubleThink',
	      'is an album',
	      'albums', 
	      '1'
		  )"
	)


conn.exec("DROP TABLE IF EXISTS authors")
conn.exec("CREATE TABLE authors(
	id SERIAL PRIMARY KEY,
	username VARCHAR NOT NULL UNIQUE,
	email VARCHAR NOT NULL UNIQUE,
	password_digest VARCHAR NOT NULL,
	article_id VARCHAR,
	edit_count INTEGER
	)"
)

conn.exec("INSERT INTO authors (id, username, email, password_digest) VALUES (
	      '0',
	      'jared', 
	      'jared',
	      'jared'
		  )"
	)




