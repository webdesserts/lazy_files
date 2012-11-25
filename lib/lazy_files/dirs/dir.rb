require 'lazy_files/dirs/dir_mods'
require 'lazy_files/dirs/constants'

class Lazy::Dir
  attr_reader :path, :io

  PATHBASED_METHODS.each do |method_name|
    define_method(method_name) do
      Dir.send(method_name, @path)
    end
  end

  def initialize(path)
    @path = File.expand_path path
    unless File.directory? @path
      Dir.mkdir(File.basename(@path))
    end
    @io = Dir.open(@path) {}
  end

  def basename
    File.basename @path
  end

  def open(*args, &block)
    @io = Dir.open(@path, *args, &block)
  end

  def to_s
    "#<LazyDir:#{basename}"
  end
end
