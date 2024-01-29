# frozen_string_literal: true

require 'sinatra'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memo' do
  @list = JSON.parse(File.read('memo/memo.json'), symbolize_names: true)
  erb :memo_list
end

get '/memo/new' do
  erb :memo_new
end

post '/memo/new' do
  list = JSON.parse(File.read('memo/memo.json'), symbolize_names: true)
  next_id = 1
  if list.empty? then

  end
  next_id = list.empty? ? 1 : ( list.max { |i| i[:id] }[:id] + 1 )
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

patch '/memo/:id' do
  list = JSON.parse(File.read('memo/memo.json'), symbolize_names: true)
  item = list.find { |i| i[:id] == params['id'].to_i }
  item[:title] = params[:title]
  item[:content] = params[:content]
  File.write('memo/memo.json', list.to_json)

  redirect "/memo/#{params['id']}"
end

not_found do
  '404 not found'
end
