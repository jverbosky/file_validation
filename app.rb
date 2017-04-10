require 'sinatra'
require_relative "file_validation.rb"

get '/' do
    erb :upload
end

post '/' do
    file_hash = params[:file]
    file_check = FileValidation.new
    result = file_check.validate_file(file_hash)
    erb :results, locals: {file_hash: file_hash, result: result}
end