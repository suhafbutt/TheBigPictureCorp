require_relative '../services/files/parser'
require_relative '../models/result'
require_relative '../services/images/downloader'
require_relative '../validators/file_validator'
require_relative '../validators/path_validator'
require_relative '../validators/image_validator'
require_relative '../services/images/download_response'

namespace :the_big_picture_corp do
  desc 'rake task example'
  task :download_files, :source, :destination do |_t, args|
    args.with_defaults(destination: 'tmp/')

    result = Parser.new(file_path: args[:source]).parse
    if result.success?
      download_result = Downloader.new(image_urls: result.object, destination_path: args[:destination]).call
    else
      puts result.error
    end

    puts DownloadResponse.new(download_result.object).overview if download_result&.success?
  end
end
