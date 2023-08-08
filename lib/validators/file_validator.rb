require 'net/http'

class FileValidator
  attr_accessor :file, :errors, :file_path

  VALID_FILE_EXTENSIONS = '.txt'

  def initialize(file:, file_path:)
    @file = file
    @file_path = file_path
    @errors = []
  end

  def validate
    return Result.new(true, nil, nil) if presence && content_type && extension

    Result.new(false, errors.join(', '), nil)
  end

  private

  def presence
    return true if file

    add_to_errors('File does not exist')
  end

  def is_remote_path?
    file_path.match?(%r{^https?://})
  end

  def content_type
    return true unless is_remote_path?
    return true if file.content_type&.start_with?('text/')

    add_to_errors('File content type is not valid')
  end

  def extension
    extension_name = File.extname(file).downcase
    return true if extension_name == VALID_FILE_EXTENSIONS

    add_to_errors('File is not of valid type')
  end

  def add_to_errors(message)
    errors << message
    false
  end
end
