require 'bundler/setup'
require 'sinatra' 
require 'sinatra/activerecord'
require './models.rb'
require 'rack-flash'

enable :sessions
use Rack::Flash, :sweep => true

set :database, "sqlite3:groupDB.sqlite3"

