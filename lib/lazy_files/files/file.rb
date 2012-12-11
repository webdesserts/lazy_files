require 'lazy_files/files/file_mods'
require 'lazy_files/files/constants'

module Lazy
  class File
    attr_reader :path, :io

    PATHBASED_METHODS.each do |method_name|
      define_method(method_name) do
        ::File.send(method_name, @path)
      end
    end

    def initialize(path, *args, &block)
      @path = ::File.expand_path path
      @io = nil
      if ::File.file? @path
        if block_given? || !args.empty?
          open(*args, &block)
        end
      else
        raise Errno::ENOENT
      end
    end

    def basename(options={})
      options = {
        ext: true
      }.merge(options)

      name = ::File.basename @path
      if options[:ext]
        name
      else
        name[/.*(?=#{extname}\Z)/]
      end
    end

    def open(*args, &block)
      # read-write mode if no mode specified
      # args[0] = 'a+' if args.empty?
      if block_given?
        execute_and_close(&block)
      else
        new_io(*args)
      end
      self
    end

    def reopen(*args, &block)
      close unless closed?
      open(*args, &block)
    end

    def print(*args)
      default_mode('w')
      @io.print(*args)
    end

    def puts(*args)
      default_mode('w')
      @io.puts(*args)
    end

    def read(*args)
      default_mode('r')
      @io.read(*args)
    end

    def to_s
      "#<LazyFile:#{basename}>"
    end

    def close
      if @io.closed?
        false
      else
        @io = @io.close
        true
      end
    end

    def close!
      raise IOError, 'file not opened' if closed?
      close
    end

    def closed?
      @io.nil? || @io.closed?
    end

    private
    def default_mode(*args)
      new_io(*args) if closed?
    end

    def execute_and_close(&block)
      yield self
      close
    end
    def new_io(*args)
      @io = ::File.new(@path, *args)
    end
  end
end
