# frozen_string_literal: true

require 'sinatra'

get '/memo' do
  @list = (1..5)
  erb :memo_list
end

get '/memo/new' do
  erb :memo_new
end

post '/memo/new' do
  @title = params[:title]
  @content = params[:content]
  @status_msg = '登録しました'
  erb :memo_saved
end
