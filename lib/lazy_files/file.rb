class Lazy::File do
  def initialize( path ) do
    @path = File.expand_path path
  end
  def self.basename(file)
    path = file.path if file.is_a? Lazy::File
    super(path)
  end
end
