# ClassMethods will be available on both the class its
# self and its parent class, Lazy.
#
# Careful consideration should be taken before turning
# a method into a class method as this could cause
# conflicts with future features.

module Lazy
  class LazyFile
    module ClassMethods
      def basename(file)
        file = file.path if file.is_a? LazyFile
        File.basename file
      end

      def file(*args, &block)
        LazyFile.new(*args, &block)
      end
    end
    extend ClassMethods
  end
  extend Lazy::LazyFile::ClassMethods
end
