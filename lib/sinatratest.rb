require 'rubygems'
require 'sinatra'
require 'sequel'
require 'sqlite3'

DB = Sequel.connect('sqlite://articles.db')

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

# Sequel model based article
class Article < Sequel::Model
end

get '/' do
  @articles = Article.all
  @title = 'All Articles'
  erb :home
end

post '/' do
  newart = Article.new do |n|
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
  @article = Article[id]
  @title = 'Edit article id'
  erb :edit
end

put '/:id' do |id|
  n = Article[id]
  n.body = params[:body]
  n.updated_at = Time.now
  n.save
  redirect '/'
end

get '/:id/delete' do |id|
  @article = Article[id]
  @title = 'Confirm deletion of article ##id'
  erb :delete
end

delete '/:id' do |id|
  n = Article[id]
  n.destroy
  redirect '/'
end
