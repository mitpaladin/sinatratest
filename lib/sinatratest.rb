require 'rubygems'
require 'sinatra'
require 'sequel'
require 'pg'
# require 'roda'
# require 'bcrypt'
require 'prolog/use_cases/summarise_content'
require_relative '../config/environment.rb'

# use Rack::Session::Cookie, secret: File.file?('sinatratest.secret') ?
#                           File.read('sinatratest.secret') :
#                           (ENV['SINATRATEST_SECRET'] || SecureRandom.hex(20))

DB = Sequel.postgres('sinatratest_db', user: 'sinatratest_db',
                                       host: 'localhost', port: 5432)

DB.create_table? :articles do
  primary_key :id
  String :author_name, default: 'User1'
  String :body
  String :title
  String :keywords, null: true
  String :image_url, null: true
  DateTime :created_at
  DateTime :updated_at
end

# Sequel model based articles
class Articles < Sequel::Model
end

# Rodauth integration
# class RodauthApp < Roda
#  db = Sequel.postgres('sinatratest_db', user: 'sinatratest_db',
#                                         host: 'localhost', port: 5432)
#  db.drop_table(:accounts, cascade: true)

#  unless db.table_exists?(:accounts)
#    db.create_table(:accounts) do
#      primary_key :id
#      String :email, unique: true, null: false
#      String :password_hash, null: false
#    end

# Add a demo account for testing, since we aren't allowing users to create
# their own accounts.
#    db[:accounts].insert(email: 'demo',
#                         password_hash: BCrypt::Password.create('demo'))
#  end

#  plugin :middleware
#  plugin :render, views: 'lib/views'
#  plugin :rodauth do
#    enable :login
#    after_login do
#      puts 'successful login!'
#      request.redirect('/')
#    end
#  end

#  alias erb render

#  route do |r|
#    r.rodauth

# Force all users to login before accessing Sinatratest
#    rodauth.require_authentication
#   end
# end

# use RodauthApp

# Intermediate repo object with keywords as array rather than String
class ArticleRepo
  def initialize(articles)
    @articles = articles
    keywords_to_a
    self
  end

  def all
    @articles
  end

  private

  def keywords_to_a
    @articles.each do |art|
      keyword_split(art)
    end
  end

  def keyword_split(article)
    oldkeywords = article.keywords
    article.keywords = oldkeywords.split(/,/).map(&:strip)
  end

  attr_reader :articles
end

get '/' do
  artrepo = ArticleRepo.new(Articles.all)
  sumobj = Prolog::UseCases::SummariseContent.new(repository: artrepo)
  rethash = sumobj.call
  @articles = rethash[:articles]
  @title = 'All Articles'
  @kbf = rethash[:keywords_by_frequency]
  erb :home
end

post '/' do
  newart = Articles.new do |n|
    n.body = params[:body]
    n.title = params[:title]
    n.author_name = 'User1'
    n.keywords = params[:keywords]
    n.image_url = params[:image_url]
    n.created_at = Time.now
    n.updated_at = Time.now
  end
  newart.save
  redirect '/'
end

get '/:id' do |id|
  @article = Articles[id]
  @title = 'Edit article id'
  erb :edit
end

put '/:id' do |id|
  n = Articles[id]
  n.body = params[:body]
  n.updated_at = Time.now
  n.save
  redirect '/'
end

get '/:id/delete' do |id|
  @article = Articles[id]
  @title = 'Confirm deletion of article ##id'
  erb :delete
end

delete '/:id' do |id|
  n = Articles[id]
  n.destroy
  redirect '/'
end
