# frozen_string_literal: true

require 'sinatra'

get '/memo' do
  erb :memo_list
end

get '/memo/new' do
  erb :memo_new
end

post '/memo/new' do
  tytle = params[:tytle]
  content = params[:content]
  "タイトル：#{tytle}<br>内容：#{content}"
end
