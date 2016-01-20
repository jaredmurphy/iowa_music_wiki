module IowaMusic
  class Server < Sinatra::Base

    entries = [:bands, :venues, :albums, :festivals, :songs, :labels, :record_stores, :studios]

  	get '/' do
  		
  		erb :home
  	end
  	# this will list all bands
     get '/albums' do
      @title = "albums"
      
      @data = conn.exec("
        SELECT * FROM #{@title}").to_a
      erb :lists
    end
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
  		@categories = entries.map { |a| a.to_s }
  		erb :categories
  	end

  	get '/create_entry' do
  		@title = "create entry"
  		
  		@genres = conn.exec("SELECT * FROM genres;")
  		@categories = entries.map { |a| a.to_s }

  		erb :form
  	end
    

    # CREATE POST
  	post "/create_entry" do
      category = params["category"]

      a_name = params["a_name"]
      a_name = params["a_band"]
      a_img_url = params["a_img_url"]
      a_listen_url = params["a_listen_url"]
      a_description = params["a_description"]

    	b_name = params["b_name"]
    	b_img_url = params["b_img_url"]
    	b_genre_one = params["b_genre_one"]
    	b_location = params["b_location"]
    	b_description = params["b_description"]
    	b_website_url = params["b_website_url"]

      f_name = params["f_name"]
      f_img_url = params["f_img_url"]
      f_location = params["f_location"]
      f_description = params["f_description"]
      f_website_url = params["f_website_url"]

      l_name = params["l_name"]
      l_img_url = params["l_img_url"]
      l_location = params["l_location"]
      l_description = params["l_description"]
      l_website_url = params["l_website_url"]
      l_albums = params["l_albums"]
      l_bands = params["l_songs"]

      rs_name = params["rs_name"]
      rs_img_url = params["rs_img_url"]
      rs_location = params["rs_location"]
      rs_description = params["rs_description"]
      rs_website_url = params["rs_website_url"]


      song_name = params["song_name"]
      song_band = params["song_band"]
      song_album = params["song_album"]
      song_lyrics = params["song_lyrics"]
      song_description = params["song_description"]
   
      studio_name = params["studio_name"]
      studio_img_url = params["studio_img_url"]
      studio_location = params["studio_location"]
      studio_description = params["studio_description"]
      studio_website_url = params["studio_website_url"]
      
      
      v_name = params["v_name"]
      v_img_url = params["v_img_url"]
      v_location = params["v_location"]
      v_description = params["v_description"]
      v_website_url = params["v_website_url"]
    	
      if category == 'Albums'
        conn.exec_params("INSERT INTO albums (name, band, img_url, listen_url, description) 
          VALUES ($1, $2, $3, $4, $5)",
          [a_name, a_band, a_img_url, a_listen_url, a_description]
        )
    	elsif category == 'Bands'
      	conn.exec_params(
      		"INSERT INTO bands (name, img_url, genre_one, location, description, website_url) 
      		VALUES ($1, $2, $3, $4, $5, $6)",
      		[b_name, b_img_url, b_genre_one, b_location, b_description, b_website_url]
      	)

      elsif category == 'Festivals'
        conn.exec_params(
          "INSERT INTO festivals (name, img_url, location, description, website_url) 
          VALUES ($1, $2, $3, $4, $5)",
          [f_name, f_img_url, f_location, f_description, f_website_url]
        )
      elsif category == 'Labels'
        conn.exec_params(
          "INSERT INTO labels (name, img_url, bands, albums, location, website_url, description) 
          VALUES ($1, $2, $3, $4, $5, $6, $7)",
          [l_name, l_img_url, l_bands, l_albums, l_location, l_website_url, l_description]
        )
      elsif category == 'Record_stores'
        conn.exec_params(
          "INSERT INTO record_stores (name, img_url, location, description, website_url) 
          VALUES ($1, $2, $3, $4, $5)",
          [rs_name, rs_img_url, rs_location, rs_description, rs_website_url]
        )
      elsif category == 'Songs'
        conn.exec_params(
          "INSERT INTO songs (name, band, album, lyrics, description) 
          VALUES ($1, $2, $3)",
          [song_name, song_band, song_album, song_lyrics, song_description]
        )
        elsif category == 'Studios'
        conn.exec_params(
          "INSERT INTO studios (name, img_url, location, description, website_url) 
          VALUES ($1, $2, $3, $4, $5)",
          [studio_name, studio_img_url, studio_location, studio_description, studio_website_url]
        )
        elsif category == 'Venues'
        conn.exec_params(
          "INSERT INTO venues (name, img_url, location, description, website_url) 
          VALUES ($1, $2, $3, $4, $5)",
          [v_name, v_img_url, v_location, v_description, v_website_url]
        )
      end

    	@entry_submitted = true
    	erb :form
    end

    # end create post

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

