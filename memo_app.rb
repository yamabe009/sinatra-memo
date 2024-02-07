# frozen_string_literal: true

require 'sinatra'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memo' do
  @list = read_memo_list
  erb :memo_list
end

get '/memo/new' do
  erb :memo_new
end

post '/memo/new' do
  list = read_memo_list
  next_id = list.empty? ? 1 : (list.max { |i| i[:id] }[:id] + 1)
  list.push({ id: next_id, title: params[:title], content: params[:content] })
  p list
  File.write('memo/memo.json', list.to_json)

  redirect '/memo'
end

get '/memo/:id' do
  list = read_memo_list
  @item = list.find { |i| i[:id] == params['id'].to_i }
  erb :memo_details
end

get '/memo/:id/edit' do
  list = read_memo_list
  @item = list.find { |i| i[:id] == params['id'].to_i }
  erb :memo_edit
end

delete '/memo/:id' do
  list = read_memo_list
  list.delete_if { |i| i[:id] == params['id'].to_i }
  File.write('memo/memo.json', list.to_json)

  redirect '/memo'
end

patch '/memo/:id' do
  list = read_memo_list
  item = list.find { |i| i[:id] == params['id'].to_i }
  item[:title] = params[:title]
  item[:content] = params[:content]
  File.write('memo/memo.json', list.to_json)

  redirect "/memo/#{params['id']}"
end

not_found do
  '404 not found'
end

def read_memo_list
  JSON.parse(File.read('memo/memo.json'), symbolize_names: true)
end
