file_names = {
  jpg: ["jpg", "JPG", "jpe", "JPE", "jpeg", "JPEG"]
}

file_data = {
  jpg: ["\xFF\xD8\xFF\xE0", "\xFF\xD8\xFF\xE1"],
  jpgb: ["\xFF\xD8\xFF\xE0"]
}

def jpg?(filename, data)
  # return status == (filename[:jpg] && data[0,4] == file_data[:jpg])
end

def file_type(file_hash)
  response = "Not a valid image file."
  response = "File is jpg." if jpg?(file_hash[:filename], file_hash[:tempfile])
  return response
end

binary = File.binread("./public/images/flood-damage.jpg")[0, 4]
data_1 = binary
p "data_1 encoding: #{data_1.encoding}"
data_1.force_encoding("UTF-8")
p "data_1 encoding after force_encoding: #{data_1.encoding}"

# data_2 = File.binread("./public/images/borregoflooddamgage.JPG")[0, 4]
# p data_2  # "\xFF\xD8\xFF\xE1"

# data_3 = File.binread("./public/images/renamed_exe.jpg")[0, 4]
# p data_3  # "MZ\x90\x00"

# if file_data[:jpg].include? data_1
#   puts "true"
# else
#   puts "false"
# end

# jpg_data = ["\xFF\xD8\xFF\xE0", "\xFF\xD8\xFF\xE1"]
jpg_data = file_data[:jpg]
# p "jpg_data: #{jpg_data}"  # "jpg_data: [\"\\xFF\\xD8\\xFF\\xE0\", \"\\xFF\\xD8\\xFF\\xE1\"]"

string_1 = "\xFF\xD8\xFF\xE0"
p "string_1: #{string_1}"  # "string_1: \xFF\xD8\xFF\xE0"
p "string_1 encoding: #{string_1.encoding}"
string_1.force_encoding(Encoding::ASCII_8BIT)
p "string_1 encoding after force_encoding: #{string_1.encoding}"

p jpg_data.include? string_1
p jpg_data.include? data_1
p data_1 == string_1
