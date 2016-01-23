module IowaMusic
  class Server < Sinatra::Base

    enable :sessions
    entries = [:albums, :bands, :festivals, :labels, :record_stores, :songs, :studios, :venues]


    get '/' do
      erb :home
    end

    #####################
    ### article pages ###
    #####################


  	### albums ###
     get '/albums' do
      @title = "albums"
      @data = conn.exec("
        SELECT * FROM #{@title}").to_a
      erb :lists
    end

    get '/albums/:id' do
      @id = params[:id]
       @title = "albums"
      @data = conn.exec("
        SELECT * FROM #{@title} WHERE id = #{@id};").to_a
      erb :article
    end
    ### end albums ###

    ### bands ###
  	get '/bands' do
  		@title = "bands"
  		@data = conn.exec("
  			SELECT * FROM #{@title};").to_a
  		erb :lists
  	end

  	get '/bands/:id' do
  		@id = params[:id]
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
  		 @title = "bands"
  		 @data = conn.exec_params("
  			SELECT * FROM bands WHERE id = $1", [@id]).first
       #binding.pry
       #auth_id = @data['author_id'].to_i
       @author = conn.exec_params("
        SELECT username FROM authors WHERE id = $1", [@data['author_id'].to_i]).first
       @description = markdown(@data['description'])
  		erb :article
  	end

    ### edit ###

    get '/bands/:id/edit' do

      @id = params[:id]
      @table = "bands"
      @data = conn.exec("
      SELECT * FROM #{@table} WHERE id = #{@id}").to_a
      erb :bands_edit
    end

    post '/bands/:id/edit' do

   
      author_id = params['author']
      name = params["name"]
      img_url = params["img_url"]
      genre_one = params["genre_one"]
      location = params["location"]
      description = params["description"]
      website_url = params["website_url"]
      @id = params[:id]
      @table = 'bands'
      @data = conn.exec_params("
      UPDATE #{@table} SET location = $1, genre_one = $2, img_url = $3, website_url = $4, description = $5, author_id = $6, edited = CURRENT_TIMESTAMP 
        WHERE id = #{@id} returning *",
        [location, genre_one, img_url, website_url, description, author_id]).to_a
      @entry_submitted = true
      erb :bands_edit
    end
    ### end bands ###

    ### create bands ####
    get '/create_entry/bands' do
      erb :bands
    end
    post '/create_entry/bands' do
      author_id = params['author']
      b_name = params["b_name"]
      b_img_url = params["b_img_url"]
      b_genre_one = params["b_genre_one"]
      b_location = params["b_location"]
      b_description = params["b_description"]
      b_website_url = params["b_website_url"]

      conn.exec_params(
          "INSERT INTO bands (name, img_url, genre_one, location, description, author_id, website_url, edited) 
          VALUES ($1, $2, $3, $4, $5, $6, $7, CURRENT_TIMESTAMP)",
          [b_name, b_img_url, b_genre_one, b_location, b_description, author_id, b_website_url]
        )
      @entry_submitted = true
      erb :bands
    end


    ### end create bands ###



    ### festivals ###
    get '/festivals' do
      @title = "festivals"
      @data = conn.exec("
        SELECT * FROM #{@title};").to_a
      erb :lists
    end

    get '/festivals/:id' do
      @id = params[:id]
       @title = "festivals"
       @data = conn.exec("
        SELECT * FROM #{@title} WHERE id = #{@id};").to_a
      erb :article
    end
    ### end festivals ###

    ### labels ###
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
    ### end labels ###

    ### record stores ###
    get '/record_stores' do
      @title = "record_stores"
      @data = conn.exec("
        SELECT * FROM #{@title}").to_a
      erb :lists
    end
     get '/record_stores/:id' do
      @id = params[:id]
      @title = "record_stores"
      @data = conn.exec("
        SELECT * FROM #{@title} WHERE id = #{@id};").to_a
      erb :article
    end
    ### end record stores ###

    ### songs ###
    get '/songs' do
      @title = "songs"
      @data = conn.exec("
        SELECT * FROM #{@title}").to_a
      erb :lists
    end
     get '/songs/:id' do
      @id = params[:id]
      @title = "songs"
      @data = conn.exec("
        SELECT * FROM #{@title} WHERE id = #{@id};").to_a
      erb :article
    end
    ### songs ###

    ### studios ###
    get '/studios' do
      @title = "studios"
      @data = conn.exec("
        SELECT * FROM #{@title}").to_a
      erb :lists
    end
     get '/studios/:id' do
      @id = params[:id]
      @title = "studios"
      @data = conn.exec("
        SELECT * FROM #{@title} WHERE id = #{@id};").to_a
      erb :article
    end
    ### studios ###

    ### venues ###
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
    #### end venues ###

    #######################
    #### category lists ###
    #######################

  	get '/categories' do
  		@title = "categories"
  		@categories = entries.map { |a| a.to_s }
  		erb :categories
  	end

    #######################
    ######## other ########
    #######################

    def current_user
      if session["author_id"]
        @author ||= conn.exec_params("SELECT * FROM authors WHERE id = $1", [session["author_id"]]).first
      else 
        {}
        #user is not logged in
      end
    end

    ### sign up ###
    get '/signup' do 
      erb :signup
    end

    post '/signup' do
      username = params['username']
      encrypted_password = BCrypt::Password.create(params['password'])
      email = params['email']
     conn.exec_params("INSERT INTO authors (username, email, password_digest) VALUES ($1, $2, $3)",
        [username, email, encrypted_password]
      )
      erb :signupsuccess
    end

    ### log in ###
    get '/login' do
        erb :login
    end

    post "/login" do
      @author = conn.exec_params("SELECT * FROM authors WHERE username = $1", [params['username']]).first
      if @author
        if BCrypt::Password.new(@author['password_digest']) == params['password']
          session["author_id"] = @author["id"]
          redirect "/"
        else 
          @error = "Invalid Password"
          erb :login
        end
      else 
        @error = "Invalid Username"
        erb :login
      end
    end

    ### logout ###
    get '/logout' do
      session.delete('author_id')
      redirect '/'
    end

    ### random ###
    #### incomplete ####
    get '/random' do 
      category = 'bands' #entries.sample.to_s
      rand_ids = conn.exec_params("SELECT id FROM #{category}")
      rand_article = rand_ids.to_a.sample
      rand_article_id = rand_article["id"]

      redirect "/bands/#{rand_article_id}"
  
    end

    ### search ###
    get '/search' do 
      @categories = entries.map { |a| a.to_s }
      erb :search
    end

    post '/bands/search' do
      @entries 
      @query = "%#{params['query']}%"
      @result = conn.exec_params("SELECT name, id FROM bands WHERE name ILIKE $1;", [@query]).to_a
      erb :search
    end

    #######################
    ### create articles ###
    #######################
  	get '/create_entry' do
  		@title = "create entry"
  		@categories = entries.map { |a| a.to_s }
  		erb :create_entry
  	end

    ### create albums ####
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

    ### end create albums ###


    ### create festivals ####
    get '/create_entry/festivals' do
      erb :festivals
    end
    post '/create_entry/festivals' do
      f_name = params["f_name"]
      f_img_url = params["f_img_url"]
      f_location = params["f_location"]
      f_description = params["f_description"]
      f_website_url = params["f_website_url"]

      conn.exec_params(
          "INSERT INTO festivals (name, img_url, location, description, website_url) 
          VALUES ($1, $2, $3, $4, $5)",
          [f_name, f_img_url, f_location, f_description, f_website_url]
        )
      @entry_submitted = true
      erb :festivals
    end
    ### end create festivals ###

    ### create labels ####
    get '/create_entry/labels' do
      erb :labels
    end
    post '/create_entry/labels' do
      l_name = params["l_name"]
      l_img_url = params["l_img_url"]
      l_location = params["l_location"]
      l_description = params["l_description"]
      l_website_url = params["l_website_url"]
      l_albums = params["l_albums"]
      l_bands = params["l_songs"]

        conn.exec_params(
          "INSERT INTO labels (name, img_url, bands, albums, location, website_url, description) 
          VALUES ($1, $2, $3, $4, $5, $6, $7)",
          [l_name, l_img_url, l_bands, l_albums, l_location, l_website_url, l_description]
        )
      @entry_submitted = true
      erb :labels
    end
    ### end create labels ###

    ### create record stores ####
    get '/create_entry/record_stores' do
      erb :record_stores
    end

    post '/create_entry/record_stores' do
      rs_name = params["rs_name"]
      rs_img_url = params["rs_img_url"]
      rs_location = params["rs_location"]
      rs_description = params["rs_description"]
      rs_website_url = params["rs_website_url"]
        conn.exec_params(
          "INSERT INTO record_stores (name, img_url, location, description, website_url) 
          VALUES ($1, $2, $3, $4, $5)",
          [rs_name, rs_img_url, rs_location, rs_description, rs_website_url]
        )
      @entry_submitted = true
      erb :record_stores
    end
    ### end create record stores ###

    ### create songs ####
    get '/create_entry/songs' do
      erb :songs
    end

    post '/create_entry/songs' do
      song_name = params["song_name"]
      song_band = params["song_band"]
      song_album = params["song_album"]
      song_lyrics = params["song_lyrics"]
      song_description = params["song_description"]
        conn.exec_params(
          "INSERT INTO songs (name, band, album, lyrics, description) 
          VALUES ($1, $2, $3, $4, $5)",
          [song_name, song_band, song_album, song_lyrics, song_description]
        )
      @entry_submitted = true
      erb :songs
    end
    ### end create songs ###

    ### create studios ####
    get '/create_entry/studios' do
      erb :studios
    end

    post '/create_entry/studios' do
      studio_name = params["studio_name"]
      studio_img_url = params["studio_img_url"]
      studio_location = params["studio_location"]
      studio_description = params["studio_description"]
      studio_website_url = params["studio_website_url"]
        conn.exec_params(
          "INSERT INTO studios (name, img_url, location, description, website_url) 
          VALUES ($1, $2, $3, $4, $5)",
          [studio_name, studio_img_url, studio_location, studio_description, studio_website_url]
        )
      @entry_submitted = true
      erb :studios
    end
    ### end create studios ###

    ### create venues ####
    get '/create_entry/venues' do
      erb :venues
    end

    post '/create_entry/venues' do
      v_name = params["v_name"]
      v_img_url = params["v_img_url"]
      v_location = params["v_location"]
      v_description = params["v_description"]
      v_website_url = params["v_website_url"]
      conn.exec_params(
          "INSERT INTO venues (name, img_url, location, description, website_url) 
          VALUES ($1, $2, $3, $4, $5)",
          [v_name, v_img_url, v_location, v_description, v_website_url]
        )
      @entry_submitted = true
      erb :venues
    end
    ### end create venues ###





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
