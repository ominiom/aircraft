require 'sinatra'

require 'sinatra/content_for'

require 'haml'
require 'sass'

helpers do
  def navigation(locations)
    locations.collect { |text, location|
      selected = (request.path_info == location)
      "<li class='#{selected ? 'selected' : ''}'><a href='#{location}'>#{text.upcase}</a></li>"
    }.join
  end
end

set :views, Proc.new { File.join(root, 'views') }

get '/' do
  haml :index
end

%w(gallery history feedback explanation quiz).each do |page|
  get "/#{page}" do
    haml page.to_sym
  end
end

get '/stylesheets/reset.css' do
  sass :reset
end

get '/stylesheets/layout.css' do
  sass :layout
end