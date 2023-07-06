# frozen_string_literal: true

require 'sinatra'

get '/memo' do
  @list = JSON.parse(File.read('memo/memo.json'), symbolize_names: true)
  erb :memo_list
end

get '/memo/new' do
  erb :memo_new
end

post '/memo/new' do
  list = JSON.parse(File.read('memo/memo.json'), symbolize_names: true)
  next_id = list.max { |i| i[:id] }[:id] + 1
  list.push({ id: next_id, title: params[:title], content: params[:content] })
  p list
  File.write('memo/memo.json', list.to_json)

  redirect '/memo'
end

get '/memo/:id' do
  file = File.open('memo/memo.json')
  list = JSON.parse(file.read, symbolize_names: true)
  @item = list.find { |i| i[:id] == params['id'].to_i }
  erb :memo_details
end

get '/memo/:id/edit' do
  file = File.open('memo/memo.json')
  list = JSON.parse(file.read, symbolize_names: true)
  @item = list.find { |i| i[:id] == params['id'].to_i }
  erb :memo_edit
end

delete '/memo/:id' do
  list = JSON.parse(File.read('memo/memo.json'), symbolize_names: true)
  list.delete_if { |i| i[:id] == params['id'].to_i }
  File.write('memo/memo.json', list.to_json)

  redirect '/memo'
end

post '/memo/:id' do
  list = JSON.parse(File.read('memo/memo.json'), symbolize_names: true)
  item = list.find { |i| i[:id] == params['id'].to_i }
  item[:title] = params[:title]
  item[:content] = params[:content]
  File.write('memo/memo.json', list.to_json)

  redirect "/memo/#{params['id']}"
end
