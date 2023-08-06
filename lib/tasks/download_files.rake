require_relative '../services/files/parser'
require_relative '../models/result'
require_relative '../services/images/downloader'

namespace :the_big_picture_corp do
  desc 'rake task example'
  task :download_files do
    image_urls = Parser.new(file_path: 'downloaderFile.txt').parse
    downloaded_images = Downloader.new(image_urls: image_urls).call


    puts "=-=-=--==--==-=-=-=-=-=-=-=-=-=-=-=-=-=-\n"*10
    puts 'All done'
  end
end
