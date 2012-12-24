require 'lazy_files/dirs/class_methods'
require 'lazy_files/dirs/constants'

module Lazy
  class Dir
    attr_reader :path, :stream

    PATHBASED_METHODS.each do |method_name|
      define_method(method_name) do
        ::Dir.send(method_name, @path)
      end
    end

    def initialize(path, &block)
      @path = ::File.expand_path path
      @stream = nil
      if ::File.directory? @path
        cd(&block) if block_given?
      else
        raise Errno::ENOENT
      end
    end

    def open(&block)
      new_stream
      if block_given?
        execute_and_close(&block)
      end
      @stream
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
      raise IOError, 'dir not opened' if closed?
      close
    end

    def closed?
      if @stream.nil?
        true
      else
        @stream.tell
        false
      end
    rescue IOError
      true
    end

    def open?
      @stream.is_a?(::Dir) && !closed?
    end

    def basename
      ::File.basename @path
    end

    def cd(&block)
      if block_given?
        ::Dir.chdir(@path){ yield self }
      else
        ::Dir.chdir(@path)
      end
    end

    def tell
      ensure_open
      @stream.tell
    end

    def read
      ensure_open
      @stream.read
    end

    def to_s
      "#<LazyDir:#{basename}>"
    end

    private
    def ensure_open
      new_stream if closed?
    end

    def execute_and_close(&block)
      yield self
      close
    end

    def new_stream
      @stream = ::Dir.new(@path)
    end
  end
end
