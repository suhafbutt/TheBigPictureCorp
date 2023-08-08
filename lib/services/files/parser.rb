require 'open-uri'

class Parser
  attr_accessor :file_path

  def initialize(file_path:)
    @file_path = file_path
  end

  def parse
    validation_response = FileValidator.new(file:, file_path:).validate
    return validation_response unless validation_response.success?

    Result.new(true, nil, image_urls)
  rescue URI::InvalidURIError
    Result.new(false, 'something went wrong while access the file.', file_path)
  end

  private

  def file
    @file ||= URI.open(file_path) if file_path
  end

  def image_urls
    content = file.read
    file.close
    parse_file_content(content)
  end

  def parse_file_content(content)
    content.split(' ')
  end
end
