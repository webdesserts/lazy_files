# ClassMethods will be available on both the class its
# self and its parent class, Lazy.
#
# Careful consideration should be taken before turning
# a method into a class method as this could cause
# conflicts with future features.

module Lazy
  class File
    module ClassMethods
      def basename(file)
        file = file.path if file.is_a? Lazy::File
        ::File.basename file
      end

      def file(path, *args, &block)
        File.new(path, *args, &block)
      rescue Errno::ENOENT
        return nil
      end

      def mkfile(filename, *args, &block)
        args[0] = 'w' if args.empty?
        ::File.open(filename, *args, &block)
        Lazy.file(filename)
      end
    end
    extend ClassMethods
  end
  extend Lazy::File::ClassMethods
end
