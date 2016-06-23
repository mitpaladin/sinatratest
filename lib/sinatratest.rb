require 'rubygems'
require 'sinatra'
require 'sequel'
require 'pg'
require 'omniauth'
require 'prolog/use_cases/summarise_content'
require_relative '../config/environment.rb'

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

# Sinatra app using OmniAuth plugin and default strategy
class Sinatratest < Sinatra::Base
  use Rack::Session::Cookie
  use OmniAuth::Strategies::Developer
end

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
