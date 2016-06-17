if ENV['APP_ENV'] == 'development'
  Articles.db = Articles::SQLDB.new
end