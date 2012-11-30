module Lazy
  class Dir
    # This is a list of most of the methods in the Ruby Dir class that
    # have a single parameter and accept a path name. This is here
    # to allow me to metaprogram the methods into the Lazy::Dir
    # class rather than add the methods manually
    PATHBASED_METHODS = []
  end
end
