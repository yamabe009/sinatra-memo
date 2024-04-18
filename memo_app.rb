# frozen_string_literal: true

require 'sinatra'
require 'erb'
require 'securerandom'

helpers do
  def h(text)
    ERB::Util.h(text)
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
  list.push(id: SecureRandom.uuid, title: params[:title], content: params[:content])
  write_memo_list(list)

  redirect '/memo'
end

get '/memo/:id' do
  list = read_memo_list
  @item = get_item(list, params['id'])
  erb :memo_details
end

get '/memo/:id/edit' do
  list = read_memo_list
  @item = get_item(list, params['id'])
  erb :memo_edit
end

delete '/memo/:id' do
  list = read_memo_list
  list.delete_if { |item| item[:id] == params['id'] }
  write_memo_list(list)

  redirect '/memo'
end

patch '/memo/:id' do
  list = read_memo_list
  item = get_item(list, params['id'])
  item[:title] = params[:title]
  item[:content] = params[:content]
  write_memo_list(list)

  redirect "/memo/#{params['id']}"
end

not_found do
  '404 not found'
end

def read_memo_list
  write_memo_list([]) if !File.exist?('memo/memo.json')
  JSON.parse(File.read('memo/memo.json'), symbolize_names: true)
end

def write_memo_list(list)
  File.write('memo/memo.json', list.to_json)
end

def get_item(list, id)
  list.find { |item| item[:id] == id }
end
