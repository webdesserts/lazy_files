class Lazy::File
  attr_reader :path
  PATH_METHODS = [
    :directory?,
    :exist?,
    :exists?,
    :readable?,
    :readable_real?,
    :world_readable?,
    :writable?,
    :writable_real?,
    :world_writable?,
    :executable?,
    :executable_real?,
    :file?,
    :zero?,
    :size?,
    :size,
    :owned?,
    :grpowned?,
    :pipe?,
    :symlink?,
    :socket?,
    :blockdev?,
    :chardev?,
    :setuid?,
    :setgid?,
    :sticky?,
    :stat,
    :lstat,
    :ftype,
    :atime,
    :mtime,
    :ctime,
    :readlink,
    :dirname,
    :extname,
    :split
  ]

  PATH_METHODS.each do |method_name|
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

  class << Lazy
    def basename(file)
      file = file.path if file.is_a? Lazy::File
      File.basename file
    end
    def file(*args, &block)
      Lazy::File.new(*args, &block)
    end
  end

end
