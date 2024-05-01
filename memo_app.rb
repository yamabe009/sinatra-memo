# frozen_string_literal: true

require 'sinatra'
require 'erb'
require 'securerandom'

MEMO_FILE_PATH = 'memo/memo.json'

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

post '/memo' do
  memos = read_memos
  memo_id = SecureRandom.uuid
  memos[memo_id] = { id: memo_id, title: params[:title], content: params[:content] }
  write_memos(memos)

  redirect '/memo'
end

get '/memo/:id' do
  memos = read_memos
  @memo = memos[params[:id]]
  erb :memo_details
end

get '/memo/:id/edit' do
  memos = read_memos
  @memo = memos[params[:id]]
  erb :memo_edit
end

delete '/memo/:id' do
  memos = read_memos
  memos.delete(params[:id])
  write_memos(memos)

  redirect '/memo'
end

patch '/memo/:id' do
  memos = read_memos
  memo = memos[params[:id]]
  memo['title'] = params[:title]
  memo['content'] = params[:content]
  write_memos(memos)

  redirect "/memo/#{params[:id]}"
end

not_found do
  '404 not found'
end

def read_memos
  write_memos({}) if !File.exist?(MEMO_FILE_PATH)
  JSON.parse(File.read(MEMO_FILE_PATH))
end

def write_memos(memos)
  File.write(MEMO_FILE_PATH, memos.to_json)
end
