class PathValidator
  def self.directory?(path)
    return Result.new(true, nil, path) if File.directory?(path)

    Result.new(false, 'Directory does not exist', path)
  end
end
