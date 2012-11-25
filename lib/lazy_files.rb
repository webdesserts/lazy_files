require "lazy_files/version"
require "lazy_files/files/file"
require "lazy_files/dirs/dir"
require "lazy_files/cl_utils/cl_utils"

module Lazy
  def find(path)
    case File.ftype path
    when "file"
      Lazy.file(path)
    when "directory"
      Lazy.dir(path)
    else
      nil
    end
  end
end
