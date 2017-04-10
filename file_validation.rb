file_names = {
  jpg: ["jpg", "JPG", "jpe", "JPE", "jpeg", "JPEG"]
}

file_data = {
  jpg: "xff\xd8\xff\xe0"
}

def jpg?(filename, data)
  # return status == (filename[:jpg] && data[0,4] == file_data[:jpg])
end

def file_type(file_hash)
  response = "Not a valid image file."
  response = "File is jpg." if jpg?(file_hash[:filename], file_hash[:tempfile])
  return response
end

data = File.binread("./public/images/flood-damage.jpg")[0, 4]
p data  # "\xFF\xD8\xFF\xE0"

data = File.binread("./public/images/borregoflooddamgage.JPG")[0, 4]
p data  # "\xFF\xD8\xFF\xE1"

data = File.binread("./public/images/renamed_exe.jpg")[0, 4]
p data  # "MZ\x90\x00"


