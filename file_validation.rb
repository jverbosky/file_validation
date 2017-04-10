class FileValidation

  attr_reader :file_types, :file_ext, :file_data

  def initialize
    @file_types = {
      jpg: "image/jpeg"
    }
    @file_ext = {
      jpg: [".jpg", ".JPG", ".jpe", ".JPE", ".jpeg", ".JPEG"]
    }
    @file_data = {
      jpg: ["\xFF\xD8\xFF\xE0", "\xFF\xD8\xFF\xE1"]
    }
  end

  def jpg?(details)
    (@file_types[:jpg] == details[:type]) &&
    (@file_ext[:jpg].include? details[:ext]) &&
    (@file_data[:jpg].include? details[:data])
  end

  def get_details(file_hash)
    details = {}
    details[:type] = file_hash[:type]
    details[:ext] = File.extname(file_hash[:filename])
    binary = File.binread(file_hash[:tempfile])[0, 4]
    # binary = File.binread("./public/images/flood-damage.jpg")[0, 4]  # use w/file_hash_1
    # binary = File.binread("./public/images/borregoflooddamgage.JPG")[0, 4]  # use w/file_hash_2
    # binary = File.binread("./public/images/renamed_exe.jpg")[0, 4]  # use w/file_hash_3
    details[:data] = binary.force_encoding("UTF-8")
    return details
  end

  def validate_file(file_hash)
    response = "is not a valid image file."
    details = get_details(file_hash)
    case
      when jpg?(details) then response = "is a valid JPG."
    end
    return response
  end

end

# Sandbox testing before adding :type from hash

# file_ext_1 = File.extname("./public/images/flood-damage.jpg")
# # p file_ext_1  # ".jpg"
# binary_1 = File.binread("./public/images/flood-damage.jpg")[0, 4]
# data_1 = binary_1.force_encoding("UTF-8")
# # p data_1  # "\xFF\xD8\xFF\xE0"

# file_ext_2 = File.extname("./public/images/borregoflooddamgage.JPG")
# # p file_ext_2  # ".JPG"
# binary_2 = File.binread("./public/images/borregoflooddamgage.JPG")[0, 4]
# data_2 = binary_2.force_encoding("UTF-8")
# # p data_2  # "\xFF\xD8\xFF\xE1"

# file_ext_3 = File.extname("./public/images/renamed_exe.jpg")
# # p file_ext_3  # ".jpg"
# binary_3 = File.binread("./public/images/renamed_exe.jpg")[0, 4]
# data_3 = binary_3.force_encoding("UTF-8")
# # p data_3  # "MZ\x90\x00"

# validate = FileValidation.new

# # p validate.file_types[:jpg].include? file_ext_1  # true
# # p validate.file_types[:jpg].include? file_ext_2  # true
# # p validate.file_types[:jpg].include? file_ext_3  # true

# # p validate.file_data[:jpg].include? data_1  # true
# # p validate.file_data[:jpg].include? data_2  # true
# # p validate.file_data[:jpg].include? data_3  # false

# p validate.jpg?(file_ext_1, data_1)  # true
# p validate.jpg?(file_ext_2, data_2)  # true
# p validate.jpg?(file_ext_3, data_3)  # false (renamed EXE)

# got hashes via file_hash = params[:file] in app.rb /post route
# note - had to change :tempfile value from # to 0 and use File.binread for file on disk in place of :tempfile to test get_details()
# file_hash_1 = {:filename=>"flood-damage.jpg", :type=>"image/jpeg", :name=>"file", :tempfile=>0, :head=>"Content-Disposition: form-data; name=\"file\"; filename=\"flood-damage.jpg\"\r\nContent-Type: image/jpeg\r\n"}
# p validate.get_details(file_hash_1)  # {:type=>"image/jpeg", :ext=>".jpg", :data=>"\xFF\xD8\xFF\xE0"}
# p validate.validate_file(file_hash_1)  # "File is a valid JPG."

# file_hash_2 = {:filename=>"borregoflooddamgage.JPG", :type=>"image/jpeg", :name=>"file", :tempfile=>0, :head=>"Content-Disposition: form-data; name=\"file\"; filename=\"borregoflooddamgage.JPG\"\r\nContent-Type: image/jpeg\r\n"}
# p validate.get_details(file_hash_2)  # {:type=>"image/jpeg", :ext=>".JPG", :data=>"\xFF\xD8\xFF\xE1"}
# p validate.validate_file(file_hash_2)  # "File is a valid JPG."

# file_hash_3 = {:filename=>"renamed_exe.jpg", :type=>"image/jpeg", :name=>"file", :tempfile=>0, :head=>"Content-Disposition: form-data; name=\"file\"; filename=\"renamed_exe.jpg\"\r\nContent-Type: image/jpeg\r\n"}
# p validate.get_details(file_hash_3)  # {:type=>"image/jpeg", :ext=>".jpg", :data=>"MZ\x90\u0000"}
# p validate.validate_file(file_hash_3)  # "File is not a valid image file."
