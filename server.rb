module IowaMusic
  class Server < Sinatra::Base



########### Table of Contents ###########
#########################################
########### things - line 35 ############
#########################################
## view articles by category - line 45 ##
#########################################
### view individual article - line 54 ###
#########################################
######## edit article - line 68 #########
#########################################
####### create article - line 96 ########
#########################################
####### random article - line 121 #######
#########################################
######### search by article name ########
#########################################
######## current user - line 131 ########
#########################################
########### signup - line 143 ###########
#########################################
########### login - line 160 ############
#########################################
########## logout - line 183 ############
#########################################
########## private - line 191 ###########
#########################################


    #####################
    ###### things #######
    #####################
    enable :sessions
    entries = [:albums, :bands, :festivals, :labels, :record_stores, :studios, :venues]

    get '/' do
      erb :home
    end

    #################################
    ### view articles by category ###
    #################################
  	get '/articles' do
      @categories = entries.to_a.sort!  
  		@articles = conn.exec("
  			SELECT * FROM articles;").to_a.sort!{|a,b| a['category']<=>b['category']}
  		erb :categories
  	end
    ###############################
    ### view individual article ###
    ###############################
  	get '/article/:id' do
  		@id = params[:id]
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})

  		@data = conn.exec_params("SELECT * FROM articles WHERE id = $1", [@id]).first

      @author = conn.exec_params("
        SELECT username FROM authors WHERE id = $1", [@data['author_id'].to_i]).first

      @description = markdown(@data['description'])
  		erb :article
  	end

    ####################
    ### edit article ###
    ####################
    get '/article/:id/edit' do
      @id = params[:id]
      @data = conn.exec("
      SELECT * FROM articles WHERE id = #{@id}").to_a
      erb :article_edit
    end
    
    post '/article/:id/edit' do
      @id = params[:id]
      author_id = params['@author']
      name = params["name"]
      second_category = params["second_category"]
      img_url = params["img_url"]
      location = params["location"]
      description = params["description"]
      website_url = params["website_url"]

      @data = conn.exec_params("
        UPDATE articles SET img_url = $1, description = $2, author_id = $3, second_category = $4, location = $5, edited = CURRENT_TIMESTAMP 
        WHERE id = #{@id} returning *",
        [img_url, description, author_id, second_category, location]).to_a

      conn.exec_params("UPDATE authors SET edit_count = edit_count + 1")
      @entry_submitted = true
      erb :article_edit
    end
    
    ######################
    ### create article ###
    ######################
    get '/create_entry' do
      erb :create_entry
    end
    post '/create_entry' do
      author_id = params['@author']
      name = params["name"]
      img_url = params["img_url"]
      website_url = params["website_url"]
      genres = params["grenres"]
      category = params["category"]
      location = params['location']
      description = params['description']
    
      conn.exec_params(
        "INSERT INTO articles (name, website_url, img_url, description, category, author_id, location, edited) 
        VALUES ($1, $2, $3, $4, $5, $6, $7 CURRENT_TIMESTAMP)",
        [name, website_url, img_url, description, category, author_id, location]
      )
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
      edit_count = '0'
      conn.exec_params("INSERT INTO authors (username, email, password_digest, edit_count) VALUES ($1, $2, $3, $4)",
        [username, email, encrypted_password, edit_count]
      )
      erb :signupsuccess
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
           PG.connect(
            dbname: ENV["POSTGRES_DB"],
            host: ENV["POSTGRES_HOST"],
            password: ENV["POSTGRES_PASS"],
            user: ENV["POSTGRES_USER"]
        )
        else
            PG.connect(dbname: "iowa_music_wiki_db")
        end
    end #end private
  end #end class
end#end module

