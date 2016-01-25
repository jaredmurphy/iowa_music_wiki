module IowaMusic
  class Server < Sinatra::Base



########### Table of Contents ###########
#########################################
########### things - line 37 ############
#########################################
## view articles by category - line 48 ##
#########################################
### view individual article - line 57 ###
#########################################
######## edit article - line 73 #########
#########################################
###### create article - line 111 ########
#########################################
####### random article - line 141 #######
#########################################
### search by article name - line 151 ###
#########################################
###### view author list - line 164 ######
#########################################
######## current user - line 176 ########
#########################################
########### signup - line 188 ###########
#########################################
########### login - line 213 ############
#########################################
########## logout - line 236 ############
#########################################
########## private - line 244 ###########
#########################################


    #####################
    ###### things #######
    #####################
    enable :sessions
    entries = [:albums, :bands, :festivals, :labels, :record_stores, :songs, :studios, :venues]


    get '/' do
      erb :home
    end

    #################################
    ### view articles by category ###
    #################################
    get '/articles' do
      @categories = entries.to_a.sort!  
      @articles = conn.exec("
        SELECT * FROM articles").to_a.sort_by!{ |x| x['name'] }
      erb :categories
    end
    ###############################
    ### view individual article ###
    ###############################
    get '/article/:id' do
      @id = params[:id]
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})

      @data = conn.exec_params("SELECT * FROM articles WHERE id = $1", [@id]).first

      @edited_by = conn.exec_params("
        SELECT username FROM authors WHERE id = $1", [@data['author_id'].to_i]).first
      @bands = conn.exec("SELECT id, name FROM articles WHERE id = $1", [@data['bands'].to_i])
      @band = conn.exec("SELECT *, name FROM articles WHERE id = $1", [@data['band_id'].to_i]).first
      @description = markdown(@data['description'])
      erb :article
    end

    ####################
    ### edit article ###
    ####################
    get '/article/:id/edit' do
      @id = params[:id]
      @categories = entries.to_a
      @data = conn.exec("
      SELECT * FROM articles WHERE id = #{@id}").to_a
      @bands = conn.exec("SELECT * FROM articles WHERE category = 'bands'");
      @labels = conn.exec("SELECT * FROM articles WHERE category = 'labels'");
      erb :article_edit
    end
    
    post '/article/:id/edit' do
      @id = params[:id]
      author_id = params['@editing']
      name = params["name"]
      second_category = params["second_category"]
      img_url = params["img_url"]
      location = params["location"]
      description = params["description"]
      website_url = params["website_url"]
      genres = params["genres"]
      video_url = params["video_url"]
      band_ids = params["band_ids"]
      label_id= params["label_id"]

      @data = conn.exec_params("
        UPDATE articles SET img_url = $1, description = $2, author_id = $3, second_category = $4, location = $5, video_url = $6, label_id = $7, edited = CURRENT_TIMESTAMP 
        WHERE id = #{@id} returning *",
        [img_url, description, author_id, second_category, location, video_url, label_id]).to_a


      conn.exec_params("UPDATE articles SET bands = array_append(bands, '#{band_ids}') WHERE id = #{@id}")
      conn.exec_params("UPDATE articles SET genres = array_append(genres,'#{genres}')  WHERE id = #{@id}")
      conn.exec_params("UPDATE authors SET articles = array_append(articles, '#{@id.to_s}') WHERE id = #{author_id}")
      conn.exec_params("UPDATE authors SET edit_count = edit_count + 1 WHERE id = #{author_id}")

      @entry_submitted = true
      erb :article_edit
    end
    
    ######################
    ### create article ###
    ######################
    get '/create_entry' do
      @categories = entries.to_a.sort!
      @articles = conn.exec_params("SELECT * FROM articles").to_a
      erb :create_entry
    end
    post '/create_entry' do
      author_id = params['@editing']
      name = params["name"]
      img_url = params["img_url"]
      website_url = params["website_url"]
      genres = params["grenres"]
      category = params["category"]
      location = params['location']
      description = params['description']
      genres =   params["genres"] 
      band_id = params["band_id"]

      conn.exec_params(
        "INSERT INTO articles (name, website_url, img_url, description, category, author_id, location, genres, band_id, edited) 
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, CURRENT_TIMESTAMP)",
        [name, website_url, img_url, description, category, author_id, location, genres, band_id]
      )

      conn.exec_params("UPDATE authors SET edit_count = edit_count + 1 WHERE id = #{author_id}")
      @entry_submitted = true
      erb :create_entry
    end

    #######################
    #### random article ###
    #######################
    get '/random' do 
      articles = conn.exec_params("SELECT * FROM articles").to_a
      random_article = articles.sample
      random_article_id = random_article['id']
      redirect "/article/#{random_article_id}"  
    end

    ##############################
    ### search by article name ###
    ##############################
    get '/search' do 
      erb :search
    end

    post '/search' do
      @query = "%#{params['query']}%"
      @result = conn.exec_params("SELECT * FROM articles WHERE name ILIKE $1;", [@query]).to_a.sort!{|a,b| a['name']<=>b['name']}
      erb :search
    end

    ########################
    ### view author list ###
    ########################
    get '/authors' do
      @authors = conn.exec_params("SElECT * FROM authors").to_a.sort!{|a,b| a['name']<=>b['name']}
      @articles = conn.exec_params("SELECT * FROM articles").to_a.sort!{|a,b| a['name']<=>b['name']}

      erb :authors
    end

    ####################
    ### current user ###
    ####################
    def current_user
      if session["author_id"]
        @author ||= conn.exec_params("SELECT * FROM authors WHERE id = $1", [session["author_id"]]).first
      else 
        {}
        #user is not logged in
      end
    end

    ##############
    ### signup ###
    ##############
    get '/signup' do 
      erb :signup
    end

    post '/signup' do
      username = params['username']
      encrypted_password = BCrypt::Password.create(params['password'])
      email = params['email']
      edit_count = 0
      @author = conn.exec_params("SELECT * FROM authors WHERE username = $1", [params['username']]).first
      
      if @author
        @error = "Invalid Username"
        erb :signup
      else
       conn.exec_params("INSERT INTO authors (username, email, password_digest, edit_count) VALUES ($1, $2, $3, $4)",
        [username, email, encrypted_password, edit_count]
        )
        erb :signupsuccess
      end
    end

    #############
    ### login ###
    #############
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
 
    ##############
    ### logout ###
    ##############
    get '/logout' do
      session.delete('author_id')
      redirect '/'
    end

    ###############
    ### private ###
    ###############
    private

    def conn
        if ENV["RACK_ENV"] == 'production'
           @conn ||= PG.connect(
            dbname: ENV["POSTGRES_DB"],
            host: ENV["POSTGRES_HOST"],
            password: ENV["POSTGRES_PASS"],
            user: ENV["POSTGRES_USER"]
        )
        else
           @conn ||= PG.connect(dbname: "iowa_music_wiki_db")
        end
    end #end private
  end #end class
end#end module
