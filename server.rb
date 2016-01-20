module IowaMusic
  class Server < Sinatra::Base

  	get '/' do
  		
  		erb :home
  	end
  	# this will list all bands
  	get '/bands' do
  		@title = "bands"
  		
  		@data = conn.exec("
  			SELECT * FROM #{@title};").to_a
  		erb :lists
  	end

  	get '/bands/:id' do
  		@id = params[:id]
  		 @title = "bands"
  		
  		@data = conn.exec("
  			SELECT * FROM #{@title} WHERE id = #{@id};").to_a
  		erb :article
  	end
  	get '/labels' do
  		@title = "labels"
  		
  		@data = conn.exec("
  			SELECT * FROM #{@title}").to_a
  		erb :lists
  	end
  	 get '/labels/:id' do
  		@id = params[:id]
  		 @title = "labels"
  		
  		@data = conn.exec("
  			SELECT * FROM #{@title} WHERE id = #{@id};").to_a
  		erb :article
  	end
  	get '/venues' do
  		@title = "venues"
  		
  		@data = conn.exec("
  			SELECT * FROM #{@title}").to_a
  		erb :lists
  	end
  	get '/venues/:id' do
  		@id = params[:id]
  		 @title = "venues"
  		
  		@data = conn.exec("
  			SELECT * FROM #{@title} WHERE id = #{@id};").to_a
  		erb :article
  	end
  	get '/categories' do
  		@title = "categories"
  		
  		@data = conn.exec("
  			SELECT table_name FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE';")
  		erb :categories
  	end

  	get '/create_entry' do
  		@title = "create entry"
  		
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
      category = params["category"]
      v_name = params["v_name"]
      v_img_url = params["v_img_url"]
      v_location = params["v_location"]
      v_description = params["v_description"]
      v_website_url = params["v_website_url"]
    	
    	if category == 'Bands'
      	conn.exec_params(
      		"INSERT INTO bands (name, img_url, genre_one, location, description, website_url) 
      		VALUES ($1, $2, $3, $4, $5, $6)",
      		[name, img_url, genre_one, location, description, website_url]
      	)
      end
        if category == 'Venues'
        conn.exec_params(
          "INSERT INTO venues (v_name, v_img_url, v_location, v_description, v_website_url) 
          VALUES ($1, $2, $3, $4, $5)",
          [name, img_url, location, description, website_url]
        )
      end
      # conn.exec_params(
      #   "INSERT INTO venues (name, img_url, location, description, website_url) 
      #   VALUES ($1, $2, $3, $4, $5)",
      #   [name, img_url, location, description, website_url]
      # )

    	@entry_submitted = true
    	erb :form
    end

    get '/random' do
  		@data = conn.exec("
			SELECT table_name FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE';")
  		erb :random
  	end


    private

    def conn
        if ENV["RACK_ENV"] == 'production'
           PG.connect(
            dbname: ENV["POSTGRES_DB"],
            host: ENV["POSTGRES_HOST"],
            password: ENV["POSTGRES_PASS"],
            user: ENV["POSTGRES_USER"]
        )
        else
            PG.connect(dbname: "iowa_music_wiki_db")
        end
    end
end

end

