require 'lazy_files/files/file_mods'
require 'lazy_files/files/constants'

class Lazy::File
  attr_reader :path, :io

  PATHBASED_METHODS.each do |method_name|
    define_method(method_name) do
      File.send(method_name, @path)
    end
  end

  def initialize(path, *args, &block)
    @path = File.expand_path path
    @io = nil
    unless File.exists? @path
      args = ['w'] if args.empty?
      if block_given?
        File.open(@path, *args, &block)
      else
        File.open(@path, *args).close
      end
    end
  end

  def basename(with_ext = true)
    name = File.basename @path
    if with_ext
      name
    else
      name[/.*(?=#{extname}\Z)/]
    end
  end

  def name
    basename(false)
  end

  def to_s
    "#<LazyFile:#{basename}>"
  end

  def open(*args, &block)
    @io = File.open(@path, *args, &block)
  end

end
