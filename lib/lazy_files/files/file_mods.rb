# ClassMethods will be available on both the class its
# self and its parent class, Lazy.
#
# Careful consideration should be taken before turning
# a method into a class method as this could cause
# conflicts with future features.

class Lazy::File
  module ClassMethods
    def basename(file)
      file = file.path if file.is_a? Lazy::File
      File.basename file
    end

    def file(*args, &block)
      Lazy::File.new(*args, &block)
    end
  end
  extend ClassMethods
end

module Lazy
  extend Lazy::File::ClassMethods
end
