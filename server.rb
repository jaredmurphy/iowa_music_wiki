module IowaMusic
  class Server < Sinatra::Base

  	get '/' do
  		conn = PG.connect(dbname: "iowa_music_wiki_db")
  		erb :home
  	end
  	# this will list all bands
  	get '/bands' do
  		@title = "bands"
  		conn = PG.connect(dbname: "iowa_music_wiki_db")
  		@data = conn.exec("
  			SELECT * FROM #{@title};").to_a
  		erb :lists
  	end

  	get '/bands/:id' do
  		@id = params[:id]
  		 @title = "bands"
  		conn = PG.connect(dbname: "iowa_music_wiki_db")
  		@data = conn.exec("
  			SELECT * FROM #{@title} WHERE id = #{@id};").to_a
  		erb :article
  	end
  	get '/labels' do
  		@title = "labels"
  		conn = PG.connect(dbname: "iowa_music_wiki_db")
  		@data = conn.exec("
  			SELECT * FROM #{@title}").to_a
  		erb :lists
  	end
  	 get '/labels/:id' do
  		@id = params[:id]
  		 @title = "labels"
  		conn = PG.connect(dbname: "iowa_music_wiki_db")
  		@data = conn.exec("
  			SELECT * FROM #{@title} WHERE id = #{@id};").to_a
  		erb :article
  	end
  	get '/venues' do
  		@title = "venues"
  		conn = PG.connect(dbname: "iowa_music_wiki_db")
  		@data = conn.exec("
  			SELECT * FROM #{@title}").to_a
  		erb :lists
  	end
  	get '/venues/:id' do
  		@id = params[:id]
  		 @title = "venues"
  		conn = PG.connect(dbname: "iowa_music_wiki_db")
  		@data = conn.exec("
  			SELECT * FROM #{@title} WHERE id = #{@id};").to_a
  		erb :article
  	end
  	get '/categories' do
  		@title = "categories"
  		conn = PG.connect(dbname: "iowa_music_wiki_db")
  		@data = conn.exec("
  			SELECT table_name FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE';")
  		erb :categories
  	end

  	get '/create_entry' do
  		@title = "create entry"
  		conn = PG.connect(dbname: "iowa_music_wiki_db")
  		@genres = conn.exec("SELECT * FROM genres;")
  		@data = conn.exec("
			SELECT table_name FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE';")
  		erb :form
  	end

  	post "/create_entry" do
    	name = params["name"]
    	img_url = params["img_url"]
    	genre_one = params["genre_one"]
    	location = params["location"]
    	description = params["description"]
    	website_url = params["website_url"]
    	
    	conn = PG.connect(dbname: "iowa_music_wiki_db")
    	conn.exec_params(
    		"INSERT INTO bands (name, img_url, genre_one, location, description, website_url) 
    		VALUES ($1, $2, $3, $4, $5, $6)",
    		[name, img_url, genre_one, location, description, website_url]
    	)

    	@entry_submitted = true
    	erb :form
    end

    get '/random' do
  		@data = conn.exec("
			SELECT table_name FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE';")
  		erb :random
  	end

end

end

