# ClassMethods will be available on both the class its
# self and its parent class, Lazy.
#
# Careful consideration should be taken before turning
# a method into a class method as this could cause
# conflicts with future features.

module Lazy
  class LazyDir
    module ClassMethods
      def dir(*args, &block)
        LazyDir.new(*args, &block)
      end
    end
    extend ClassMethods
  end
  extend Lazy::LazyDir::ClassMethods
end
