require 'sinatra'

require 'sinatra/content_for'

require 'haml'
require 'sass'

require 'dm-core'
require 'dm-migrations'

require 'pow'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{File.join(File.dirname(__FILE__), 'db', 'database.sqlite3')}")

module Models
  class Visit
    include DataMapper::Resource



    property :id, Serial
    property :when, DateTime
    property :ip, String

  end

  class Feedback
    include DataMapper::Resource



    property :id, Serial
    property :when, DateTime
    property :email, String
    property :message, String

  end
end

DataMapper.finalize
DataMapper.auto_upgrade!

helpers do
  def navigation(locations)
    locations.collect { |text, location|
      selected = (request.path_info == location)
      "<li class='#{selected ? 'selected' : ''}'><a href='#{location}'>#{text.upcase}</a></li>"
    }.join
  end

  def count_hit
    Models::Visit.new(:when => Time.now, :ip => request['REMOTE_ADDR']).save
  end

  def total_hits
    Models::Visit.count
  end

  def hit_counter
    (("%05d" % total_hits)[0..4]).split('').map { |digit|
      "<span class='digit digit-#{digit}'></span>"
    }.join
  end
end

set :views, Proc.new { File.join(root, 'views') }
set :environment, :development

get '/' do
  count_hit
  haml :index
end

%w(gallery airplanes feedback helicopters quiz).each do |page|
  get "/#{page}" do
    count_hit
    haml page.to_sym
  end
end

get '/stylesheets/reset.css' do
  sass :reset
end

get '/stylesheets/layout.css' do
  sass :layout
end

get '/stats' do
  {
    :hits => total_hits
  }.inspect
end

post '/feedback' do
  if params[:message].empty? then
    redirect '/feedback' 
  else
    Models::Feedback.new(:email => params[:email], :message => params[:message], :when => Time.now).save
    haml :feedback_thanks
  end
end

get '/feedback/view' do
  @feedback = Models::Feedback.all
  haml :feedback_view
end