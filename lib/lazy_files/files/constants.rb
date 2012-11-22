# This is a list of all methods on the Ruby File class that
# have a single parameter and accept a path name. This is here
# to allow me to metaprogram the methods into the Lazy::File
# class rather than add the methods manually

class Lazy::File
  PATHBASED_METHODS = [
    :directory?,
    :exist?,
    :exists?,
    :readable?,
    :readable_real?,
    :world_readable?,
    :writable?,
    :writable_real?,
    :world_writable?,
    :executable?,
    :executable_real?,
    :file?,
    :zero?,
    :size?,
    :size,
    :owned?,
    :grpowned?,
    :pipe?,
    :symlink?,
    :socket?,
    :blockdev?,
    :chardev?,
    :setuid?,
    :setgid?,
    :sticky?,
    :stat,
    :lstat,
    :ftype,
    :atime,
    :mtime,
    :ctime,
    :readlink,
    :dirname,
    :extname,
    :split
  ]
end
