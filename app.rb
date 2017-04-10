require 'sinatra'
# require 'fileutils'
require_relative "file_validation.rb"
# include FileUtils::Verbose

get '/' do
    erb :upload
end

post '/' do
    # "#{params}"  # {"file"=>{:filename=>"upload_1.png", :type=>"image/png", :name=>"file", :tempfile=>#, :head=>"Content-Disposition: form-data; name=\"file\"; filename=\"upload_1.png\"\r\nContent-Type: image/png\r\n"}}
    # tempfile = params[:file][:tempfile]
    # filename = params[:file][:filename]
    file_hash = params[:file]
    # file_type = file_type(file_hash)
    "#{file_hash}"
end