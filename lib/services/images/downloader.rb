require "down"
require "fileutils"

class Downloader
  attr_accessor :image_urls

  def initialize(image_urls:)
    @image_urls = image_urls
  end

  def call
    image_urls.each do |image_url|
      temp_file = Down.download(image_url)
      puts "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n"*2
      puts "=-=-=-=--=-=-=#{temp_file}=-=-=--=-==-=-=--=\n"
      FileUtils.mv(temp_file.path, "./tmp/#{temp_file.original_filename}")
    end
  end
end