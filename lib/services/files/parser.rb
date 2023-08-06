require 'open-uri'

class Parser
  attr_accessor :file_path

  def initialize(file_path:)
    @file_path = file_path
  end

  def parse
    # TODO check if path is a URL if yes then we validate if its a text file remotely, if not,check if file? and check  
    # TODO better to raise error, check content type of response
    return Result.new(false, 'File cannot be found.', file_path) unless File.file?(file_path) # when file exits locally

    
    get_image_urls
  rescue URI::InvalidURIError
    return Result.new(false, 'URL is not valid.', nil) 
  
  end

  private


  def get_image_urls # TODO validate type here as well
    file = open(file_path)
    content = file.read
    file.close # nit: mayve write this under ensure
    parse_file_content(content)
  end

  def parse_file_content(content)
    image_urls = content.split(' ')
  end
end
