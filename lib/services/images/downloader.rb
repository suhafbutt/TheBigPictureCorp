require 'down'
require 'fileutils'
require 'parallel'

class Downloader
  attr_reader :image_urls, :destination_path, :results, :mutex

  MAX_THREAD_COUNT = 100

  def initialize(image_urls:, destination_path:)
    @image_urls = image_urls
    @destination_path = destination_path
    @results = []
    @mutex = Mutex.new
  end

  def call
    Parallel.map(image_urls, in_threads: MAX_THREAD_COUNT) do |image_url|
      download_image(image_url)
    end
    Result.new(true, nil, results)
  end

  private

  def download_image(image_url)
    directory_check = PathValidator.directory?(destination_path)

    if directory_check.success?
      download_and_validate(image_url)
    else
      update_results(directory_check)
    end
  end

  def download_and_validate(image_url)
    temp_file = Down.download(image_url)
    validate_move_to_destination(temp_file, image_url)
  rescue StandardError
    update_results(Result.new(false, 'Something went wrong while downloading the image.', image_url))
  end

  def validate_move_to_destination(temp_image, original_image_url)
    result = ImageValidator.new(image: temp_image).validate
    result.object = original_image_url
    FileUtils.mv(temp_image.path, "#{destination_path}#{temp_image.original_filename}") if result.success?
    update_results(result)
  end

  def update_results(data)
    mutex.synchronize do
      results << data
    end
  end
end
