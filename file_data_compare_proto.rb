file_data = {
  jpg: ["\xFF\xD8\xFF\xE0", "\xFF\xD8\xFF\xE1"],
  jpgb: ["\xFF\xD8\xFF\xE0"]
}

binary_1 = File.binread("./public/images/flood-damage.jpg")[0, 4]
data_1 = binary_1.force_encoding("UTF-8")
# p data_1  # "\xFF\xD8\xFF\xE0"

binary_2 = File.binread("./public/images/borregoflooddamgage.JPG")[0, 4]
data_2 = binary_2.force_encoding("UTF-8")
# p data_2  # "\xFF\xD8\xFF\xE1"

binary_3 = File.binread("./public/images/renamed_exe.jpg")[0, 4]
data_3 = binary_3.force_encoding("UTF-8")
# p data_3  # "MZ\x90\x00"

p file_data[:jpg].include? data_1  # true
p file_data[:jpg].include? data_2  # true
p file_data[:jpg].include? data_3  # false