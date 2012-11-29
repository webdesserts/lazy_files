require 'lazy_files/files/file_mods'
require 'lazy_files/files/constants'

module Lazy
  class LazyFile
    attr_reader :path, :io

    PATHBASED_METHODS.each do |method_name|
      define_method(method_name) do
        File.send(method_name, @path)
      end
    end

    def initialize(path, *args, &block)
      @path = File.expand_path path
      @io = nil
      unless File.file? @path
        args = ['w'] if args.empty?
        if block_given?
          @io = File.open(@path, *args, &block)
        else
          @io = File.open(@path, *args) {}
        end
      end
    end

    def basename(options={})
      options = {
        ext: true
      }.merge(options)
      name = File.basename @path
      if options[:ext]
        name
      else
        name[/.*(?=#{extname}\Z)/]
      end
    end

    def open(*args, &block)
      @io = File.open(@path, *args, &block)
    end

    def to_s
      "#<LazyFile:#{basename}>"
    end

  end
end
