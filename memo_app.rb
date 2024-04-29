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
  @memos = read_memos
  erb :memo_list
end

get '/memo/new' do
  erb :memo_new
end

post '/memo/new' do
  memos = read_memos
  memos.push(id: SecureRandom.uuid, title: params[:title], content: params[:content])
  write_memos(memos)

  redirect '/memo'
end

get '/memo/:id' do
  memos = read_memos
  @memo = get_memo(memos, params['id'])
  erb :memo_details
end

get '/memo/:id/edit' do
  memos = read_memos
  @memo = get_memo(memos, params['id'])
  erb :memo_edit
end

delete '/memo/:id' do
  memos = read_memos
  memos.delete_if { |memo| memo[:id] == params['id'] }
  write_memos(memos)

  redirect '/memo'
end

patch '/memo/:id' do
  memos = read_memos
  memo = get_memo(memos, params['id'])
  memo[:title] = params[:title]
  memo[:content] = params[:content]
  write_memos(memos)

  redirect "/memo/#{params['id']}"
end

not_found do
  '404 not found'
end

def read_memos
  write_memos([]) if !File.exist?('memo/memo.json')
  JSON.parse(File.read('memo/memo.json'), symbolize_names: true)
end

def write_memos(memos)
  File.write('memo/memo.json', memos.to_json)
end

def get_memo(memos, id)
  memos.find { |memo| memo[:id] == id }
end
