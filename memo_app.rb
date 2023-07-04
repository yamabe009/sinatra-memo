# frozen_string_literal: true

require 'sinatra'

get '/memo' do
  erb :memo_list
end

get '/memo/new' do
  'memo new'
end
