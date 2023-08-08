require 'net/http'

class ImageValidator
  attr_accessor :image, :errors

  VALID_IMAGE_EXTENSIONS = ['.jpg', '.jpeg', '.png', '.gif'].freeze

  def initialize(image:)
    @image = image
    @errors = []
  end

  def validate
    return Result.new(true, nil, nil) if presence && content_type && extension

    Result.new(false, errors.join(', '), nil)
  end

  private

  def presence
    return true if image

    add_to_errors('Image content type is not valid')
  end

  def content_type
    return true if image.content_type&.start_with?('image/')

    add_to_errors('Image content type is not valid')
  end

  def extension
    extension_name = File.extname(image).downcase
    return true if VALID_IMAGE_EXTENSIONS.include?(extension_name)

    add_to_errors('Image is not of valid type')
  end

  def add_to_errors(message)
    errors << message
    false
  end
end
