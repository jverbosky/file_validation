class FileValidation

  attr_reader :file_types, :file_ext, :file_data

  def initialize
    @file_types = {
      bmp:  "image/bmp",
      gif: "image/gif",
      jpg: "image/jpeg",
      png: "image/png",
      tiff: "image/tiff"
    }
    @file_ext = {
      bmp: [".bmp", ".BMP"],
      gif: [".gif", ".GIF"],
      jpg: [".jpg", ".JPG", ".jpe", ".JPE", ".jpeg", ".JPEG"],
      png: [".png", ".PNG"],
      tiff: [".tif", ".TIF", ".tiff", ".TIFF"]
    }
    @file_data = {
      bmp: "BM",
      gif: ["\x47\x49\x46\x38\x37\x61", "\x47\x49\x46\x38\x39\x61"],
      jpg: ["\xFF\xD8\xFF\xE0", "\xFF\xD8\xFF\xE1"],
      png: ["\x89\x50\x4E\x47\x0D\x0A\x1A\x0A"],
      tiff: ["\x4d\x4d\x00\x2a", "\x49\x49\x2a\x00"]
    }
  end

  def bmp?(details)
    (@file_types[:bmp] == details[:type]) &&
    (@file_ext[:bmp].include? details[:ext]) &&
    (@file_data[:bmp] == details[:data][0, 2])
  end

  def gif?(details)
    (@file_types[:gif] == details[:type]) &&
    (@file_ext[:gif].include? details[:ext]) &&
    (@file_data[:gif].include? details[:data][0, 6])
  end

  def jpg?(details)
    (@file_types[:jpg] == details[:type]) &&
    (@file_ext[:jpg].include? details[:ext]) &&
    (@file_data[:jpg].include? details[:data][0, 4])
  end

  def png?(details)
    (@file_types[:png] == details[:type]) &&
    (@file_ext[:png].include? details[:ext]) &&
    (@file_data[:png].include? details[:data])
  end

  def tiff?(details)
    (@file_types[:tiff] == details[:type]) &&
    (@file_ext[:tiff].include? details[:ext]) &&
    (@file_data[:tiff].include? details[:data][0, 4])
  end

  def get_details(file_hash)
    details = {}
    details[:type] = file_hash[:type]
    details[:ext] = File.extname(file_hash[:filename])
    binary = File.binread(file_hash[:tempfile])[0, 8]
    details[:data] = binary.force_encoding("UTF-8")
    return details
  end

  def validate_file(file_hash)
    details = get_details(file_hash)
    case
      when bmp?(details) then response = "is a valid BMP."
      when gif?(details) then response = "is a valid GIF."
      when jpg?(details) then response = "is a valid JPG."
      when png?(details) then response = "is a valid PNG."
      when tiff?(details) then response = "is a valid TIFF."
      else response = "is not a valid image file."
    end
    return response
  end

end

# Sandbox testing before adding :type from hash

  # replace get_details() and adjust binary statements for testing different file types
  # def get_details(file_hash)
  #   details = {}
  #   details[:type] = file_hash[:type]
  #   details[:ext] = File.extname(file_hash[:filename])
  #   binary = File.binread(file_hash[:tempfile])[0, 8]  # use with app.rb
  #   # binary = File.binread("./public/images/flood-damage.jpg")[0, 8]  # use w/file_hash_1
  #   # binary = File.binread("./public/images/borregoflooddamgage.JPG")[0, 8]  # use w/file_hash_2
  #   # binary = File.binread("./public/images/renamed_exe.jpg")[0, 8]  # use w/file_hash_3
  #   # binary = File.binread("./public/images/1.bmp")[0, 8]  # use w/file_hash_4
  #   # binary = File.binread("./public/images/winner.gif")[0, 8]  # use w/file_hash_5
  #   # binary = File.binread("./public/images/luma.png")[0, 8]  # use w/file_hash_6
  #   # binary = File.binread("./public/images/nemo.tif")[0, 8]  # use w/file_hash_7
  #   details[:data] = binary.force_encoding("UTF-8")
  #   return details
  # end

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

# JPG 1
# got hashes via file_hash = params[:file] in app.rb /post route
# note - had to change :tempfile value from # to 0 and use File.binread for file on disk in place of :tempfile to test get_details()
# file_hash_1 = {:filename=>"flood-damage.jpg", :type=>"image/jpeg", :name=>"file", :tempfile=>0, :head=>"Content-Disposition: form-data; name=\"file\"; filename=\"flood-damage.jpg\"\r\nContent-Type: image/jpeg\r\n"}
# p validate.get_details(file_hash_1)  # {:type=>"image/jpeg", :ext=>".jpg", :data=>"\xFF\xD8\xFF\xE0"}
# p validate.validate_file(file_hash_1)  # "is a valid JPG."

# JPG 2
# file_hash_2 = {:filename=>"borregoflooddamgage.JPG", :type=>"image/jpeg", :name=>"file", :tempfile=>0, :head=>"Content-Disposition: form-data; name=\"file\"; filename=\"borregoflooddamgage.JPG\"\r\nContent-Type: image/jpeg\r\n"}
# p validate.get_details(file_hash_2)  # {:type=>"image/jpeg", :ext=>".JPG", :data=>"\xFF\xD8\xFF\xE1"}
# p validate.validate_file(file_hash_2)  # "is a valid JPG."

# JPG 3 (renamed EXE)
# file_hash_3 = {:filename=>"renamed_exe.jpg", :type=>"image/jpeg", :name=>"file", :tempfile=>0, :head=>"Content-Disposition: form-data; name=\"file\"; filename=\"renamed_exe.jpg\"\r\nContent-Type: image/jpeg\r\n"}
# p validate.get_details(file_hash_3)  # {:type=>"image/jpeg", :ext=>".jpg", :data=>"MZ\x90\u0000"}
# p validate.validate_file(file_hash_3)  # "is not a valid image file."

# BMP
# file_hash_4 = {:filename=>"1.bmp", :type=>"image/bmp", :name=>"file", :tempfile=>0, :head=>"Content-Disposition: form-data; name=\"file\"; filename=\"1.bmp\"\r\nContent-Type: image/bmp\r\n"}
# p validate.get_details(file_hash_4)  # {:type=>"image/bmp", :ext=>".bmp", :data=>"BM"}
# details = {:type=>"image/bmp", :ext=>".bmp", :data=>"BM6\u0000\t\u0000\u0000\u0000"}
# p validate.bmp?(details)  # true
# p validate.validate_file(file_hash_4)  # "is a valid BMP."

# GIF
# file_hash_5 = {:filename=>"winner.gif", :type=>"image/gif", :name=>"file", :tempfile=>0, :head=>"Content-Disposition: form-data; name=\"file\"; filename=\"winner.gif\"\r\nContent-Type: image/gif\r\n"}
# p validate.get_details(file_hash_5)  # {:type=>"image/gif", :ext=>".gif", :data=>"GIF89a,\u0001"}
# details = {:type=>"image/gif", :ext=>".gif", :data=>"GIF89a,\u0001"}
# p validate.gif?(details)  # true
# p validate.validate_file(file_hash_5)

# PNG
# file_hash_6 = {:filename=>"luma.png", :type=>"image/png", :name=>"file", :tempfile=>0, :head=>"Content-Disposition: form-data; name=\"file\"; filename=\"luma.png\"\r\nContent-Type: image/png\r\n"}
# p validate.get_details(file_hash_6)  # {:type=>"image/png", :ext=>".png", :data=>"\x89PNG\r\n\u001A\n"}
# details = {:type=>"image/png", :ext=>".png", :data=>"\x89PNG\r\n\u001A\n"}
# p validate.png?(details)  # true
# p validate.validate_file(file_hash_6)

# TIFF
# file_hash_7 = {:filename=>"nemo.tif", :type=>"image/tiff", :name=>"file", :tempfile=>0, :head=>"Content-Disposition: form-data; name=\"file\"; filename=\"nemo.tif\"\r\nContent-Type: image/tiff\r\n"}
# p validate.get_details(file_hash_7)  # {:type=>"image/tiff", :ext=>".tif", :data=>"II*\u0000\"\xC4\u0002\u0000"}
# details = {:type=>"image/tiff", :ext=>".tif", :data=>"II*\u0000\"\xC4\u0002\u0000"}
# p validate.tiff?(details)  # true
# p validate.validate_file(file_hash_7)