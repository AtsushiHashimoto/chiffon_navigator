require 'rubygems'
require 'sinatra'
require 'json'

$LOAD_PATH.push(File.dirname(__FILE__))
require 'lib/defaultNavigator.rb'

get '/' do
	'Hello world!'
end

navigators = {}

configure do
	# add navigator algorithm class here
	#navigators['default'] = DefaultNavigator.new()
	navigators['default'] = DefaultNavigator.new()
end


options '/navi/:algorithm' do |alg|
	# headers against Cross Domain Request (CORS)
	headers "Access-Control-Allow-Origin" => "*"
	headers "Access-Control-Allow-Credentials" => "true"

	headers "Access-Control-Allow-AMAethods" => "POST, OPTIONS"
	headers "Access-Control-Max-Age" => "7200"
	headers "Access-Control-Allow-Headers" => "x-requested-with, x-requested-by"
end

post '/navi/:algorithm' do |alg|
	headers "Access-Control-Allow-Origin" => "*"
	headers "Access-Control-Allow-Credentials" => "true"

	request.body.rewind
	json_data = JSON.parse(request.body.read)
	prescription = {}
	if !navigators.include?(alg) then
		# Error!!
	elsif
		prescription = navigators[alg].counsel(json_data)
	end

	return JSON.generate(prescription)
end

get '/session_id/:username' do |username|
	headers "Access-Control-Allow-Origin" => "*"
	headers "Access-Control-Allow-Credentials" => "true"
	session_array = Dir.entries("./records").sort!
	delete_list = []
	session_array.each do |value|
		unless value =~ /^#{username}-.*$/
			delete_list.push(value)
		end
	end
	delete_list.each do |value|
		session_array.delete(value)
	end
	"#{session_array.last}"
end
