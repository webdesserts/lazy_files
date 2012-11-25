# ClassMethods will be available on both the class its
# self and its parent class, Lazy.
#
# Careful consideration should be taken before turning
# a method into a class method as this could cause
# conflicts with future features.

class Lazy::Dir
  module ClassMethods
    def dir(*args, &block)
      Lazy::Dir.new(*args, &block)
    end
  end
  extend ClassMethods
end

module Lazy
  extend Lazy::Dir::ClassMethods
end
