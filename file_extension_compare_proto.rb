file_names = {
  jpg: [".jpg", ".JPG", ".jpe", ".JPE", ".jpeg", ".JPEG"]
}

file_ext_1 = File.extname("./public/images/flood-damage.jpg")
# p file_ext_1  # ".jpg"

file_ext_2 = File.extname("./public/images/borregoflooddamgage.JPG")
# p file_ext_2  # ".JPG"

file_ext_3 = File.extname("./public/images/renamed_exe.jpg")
# p file_ext_3  # ".jpg"

p file_names[:jpg].include? file_ext_1  # true
p file_names[:jpg].include? file_ext_2  # true
p file_names[:jpg].include? file_ext_3  # true