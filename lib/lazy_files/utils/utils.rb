module Lazy
  def wd
    Lazy.dir(::Dir.pwd)
  end
  alias_method :pwd, :wd
  extend self
end
