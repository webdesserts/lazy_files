require 'lazy_files/files/file_mods'
require 'lazy_files/files/constants'

class Lazy::File
  attr_reader :path

  PATHBASED_METHODS.each do |method_name|
    define_method(method_name) do
      File.send(method_name, @path)
    end
  end

  def initialize(path, *args, &block)
    @path = File.expand_path path
    unless File.exists? @path
      args = ['w'] if args.empty?
      if block_given?
        File.open(@path, *args, &block)
      else
        File.open(@path, *args) {}
      end
    end
  end

  def to_s
    "#<LazyFile:#{basename}>"
  end

  def basename
    File.basename @path
  end
end
