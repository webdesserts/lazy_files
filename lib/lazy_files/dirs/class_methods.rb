# ClassMethods will be available on both the class its
# self and its parent class, Lazy.
#
# Careful consideration should be taken before turning
# a method into a class method as this could cause
# conflicts with future features.

module Lazy
  class Dir
    module ClassMethods
      def dir(*args, &block)
        Dir.new(*args, &block)
      rescue Errno::ENOENT
        return nil
      end
      def mkdir(dirname, *args, &block)
        ::Dir.mkdir(dirname, *args)
        Dir.new(dirname, &block)
      end
      def cd(adir, &block)
        if adir.is_a? Lazy::Dir
          path, lazydir = adir.path, adir
        else
          path, lazydir = adir, dir(adir)
        end
        if block_given?
          ::Dir.chdir(path){ yield lazydir }
        else
          ::Dir.chdir(path)
        end
        lazydir
      end
    end
    extend ClassMethods
  end
  extend Lazy::Dir::ClassMethods
end
