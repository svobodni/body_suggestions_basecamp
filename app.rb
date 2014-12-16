#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/config_file'
require 'json'
require 'httparty'

config_file 'config.yml'

#basecamp todos creation
def basecamp_post_suggestion
	auth = { :username => "#{settings.basecamp[:username]}", :password => "#{settings.basecamp[:password]}" }
	todos_post_url = "https://basecamp.com/2521699/api/v1/projects/#{settings.basecamp[:project]}/todolists/#{settings.basecamp[:todolist]}/todos.json"
	todo = { :content => "#{@suggestion_subject}"}
	result_todos_post = HTTParty.post(todos_post_url.to_str, :basic_auth => auth, :headers => { 'Content-Type' => 'application/json', 'User-Agent' => 'Svobodni_body_basecamp_suggestions_app' }, :body => todo.to_json)
	todo_id = result_todos_post["id"]
	comments_post_url = "https://basecamp.com/2521699/api/v1/projects/#{settings.basecamp[:project]}/todos/#{todo_id}/comments.json"	
	comment = { :content => "#{@suggestion_text}"}
	result_comments_post = HTTParty.post(comments_post_url.to_str, :basic_auth => auth, :headers => { 'Content-Type' => 'application/json', 'User-Agent' => 'Svobodni_body_basecamp_suggestions_app' }, :body => comment.to_json)
	comment_id = result_comments_post["id"]
end

#routes

get '/' do
	erb :suggestion_form
end

post '/suggestion' do
	@suggestion_subject = params[:suggestion_subject]
	@suggestion_text = params[:suggestion_text]
	basecamp_post_suggestion
	erb :suggestion_sent
end
