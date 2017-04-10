class FileValidation

  attr_reader :file_types, :file_data

  def initialize
    @file_types = {
      jpg: [".jpg", ".JPG", ".jpe", ".JPE", ".jpeg", ".JPEG"]
    }
    @file_data = {
      jpg: ["\xFF\xD8\xFF\xE0", "\xFF\xD8\xFF\xE1"]
    }
  end

  def jpg?(file_ext, data)
    (@file_types[:jpg].include? file_ext) && (@file_data[:jpg].include? data)
  end

  def file_type(file_hash)
    response = "Not a valid image file."
    response = "File is jpg." if jpg?(file_hash[:filename], file_hash[:tempfile])
    return response
  end

end

file_ext_1 = File.extname("./public/images/flood-damage.jpg")
# p file_ext_1  # ".jpg"
binary_1 = File.binread("./public/images/flood-damage.jpg")[0, 4]
data_1 = binary_1.force_encoding("UTF-8")
# p data_1  # "\xFF\xD8\xFF\xE0"

file_ext_2 = File.extname("./public/images/borregoflooddamgage.JPG")
# p file_ext_2  # ".JPG"
binary_2 = File.binread("./public/images/borregoflooddamgage.JPG")[0, 4]
data_2 = binary_2.force_encoding("UTF-8")
# p data_2  # "\xFF\xD8\xFF\xE1"

file_ext_3 = File.extname("./public/images/renamed_exe.jpg")
# p file_ext_3  # ".jpg"
binary_3 = File.binread("./public/images/renamed_exe.jpg")[0, 4]
data_3 = binary_3.force_encoding("UTF-8")
# p data_3  # "MZ\x90\x00"

validate = FileValidation.new

# p validate.file_types[:jpg].include? file_ext_1  # true
# p validate.file_types[:jpg].include? file_ext_2  # true
# p validate.file_types[:jpg].include? file_ext_3  # true

# p validate.file_data[:jpg].include? data_1  # true
# p validate.file_data[:jpg].include? data_2  # true
# p validate.file_data[:jpg].include? data_3  # false

p validate.jpg?(file_ext_1, data_1)  # true
p validate.jpg?(file_ext_2, data_2)  # true
p validate.jpg?(file_ext_3, data_3)  # false (renamed EXE)