module Lazy
  def self.pwd
    Lazy.dir(Dir.pwd)
  end
end
