require 'lazy_files/files/file_mods'
require 'lazy_files/files/constants'

module Lazy
  class File
    attr_reader :path, :stream

    PATHBASED_METHODS.each do |method_name|
      define_method(method_name) do
        ::File.send(method_name, @path)
      end
    end

    def initialize(path, *args, &block)
      @path = ::File.expand_path path
      @stream = nil
      if ::File.file? @path
        if !args.empty?
          open(*args, &block)
        else
          execute_and_close(&block) if block_given?
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
      new_stream(*args) unless args.empty? && block_given?
      execute_and_close(&block) if block_given?
      @stream
    end

    def reopen(*args, &block)
      close unless closed?
      open(*args, &block)
    end

    def print(*args)
      ensure_open('w')
      @stream.print(*args)
    end

    def puts(*args)
      ensure_open('w')
      @stream.puts(*args)
    end

    def read(*args)
      ensure_open('r')
      @stream.read(*args)
    end

    def close
      if closed?
        false
      else
        @stream = @stream.close
        true
      end
    end

    def close!
      raise IOError, 'file not opened' if closed?
      close
    end

    def closed?
      @stream.nil? || @stream.closed?
    end

    def open?
      @stream.is_a?(::File) && !@stream.closed?
    end

    def to_s
      "#<LazyFile:#{basename}>"
    end

    private
    def ensure_open(*args)
      new_stream(*args) if closed?
    end

    def execute_and_close(&block)
      yield self
      close
    end

    def new_stream(*args)
      @stream = ::File.new(@path, *args)
    end
  end
end
