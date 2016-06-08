require 'rubygems'
require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/articles.db")
 
class Article < Sinatra::Base
  include DataMapper::Resource
  property :id, Serial
  property :author_name, Text, :required => true
  property :body, Text, :required => true
  property :title, Text, :required => true
  property :keywords, Text
  property :image_url, Text
  property :created_at, DateTime
  property :updated_at, DateTime
end
 
DataMapper.finalize.auto_upgrade!

get '/' do
  @articles = Article.all :order => :id.desc
  @title = 'All Articles'
  erb :home
end

post '/' do
  n = Article.new
  n.body = params[:body]
  n.title = params[:title]
  n.author_name = "User1"
  n.keywords = params[:keywords]
  n.image_url = params[:image_url]
  n.created_at = Time.now
  n.updated_at = Time.now
  n.save
  redirect '/'
end

get '/:id' do
  @article = Article.get params[:id]
  @title = "Edit article ##{params[:id]}"
  erb :edit
end

put '/:id' do
  n = Article.get params[:id]
  n.body = params[:body]
  n.updated_at = Time.now
  n.save
  redirect '/'
end

get '/:id/delete' do
  @article = Article.get params[:id]
  @title = "Confirm deletion of article ##{params[:id]}"
  erb :delete
end

delete '/:id' do
  n = Article.get params[:id]
  n.destroy
  redirect '/'
end
