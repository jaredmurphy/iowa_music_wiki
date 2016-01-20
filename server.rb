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
  		
  	
  		@categories = entries.map { |a| a.to_s }

  		erb :create_entry
  	end
    
    get '/create_entry/albums' do

      erb :albums
    end

    post '/create_entry/albums' do
      a_name = params["a_name"]
      a_band = params["a_band"]
      a_img_url = params["a_img_url"]
      a_listen_url = params["a_listen_url"]
      a_description = params["a_description"]

      conn.exec_params("INSERT INTO albums (name, band, img_url, listen_url, description) 
          VALUES ($1, $2, $3, $4, $5)",
          [a_name, a_band, a_img_url, a_listen_url, a_description]
        )
      @entry_submitted = true
      erb :albums

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

