# LazyFiles

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'lazy_files'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lazy_files

## Usage

```ruby
Lazy.ls #=> [<LazyDir:lib>,<LazyDir:spec>,<LazyFile:README.md>, ... ]
Lazy.ls.each do |entry|
  puts entry.basename if entry.file? && entry.size > 0
end

# prints...
#  Gemfile
#  Gemfile.lock
#  lazy_files.gemspec
#  LICENSE
#  Rakefile
#  README.md
```

### Lazy::File

LazyFiles runs off of the idea of a `File` wrapper I call a `Lazy::File`. To create a
`Lazy::File` simply call `Lazy.file`

```ruby
Lazy.file('readme.md') #=> <LazyFile:readme.md>
```

Unlike the `File` object, an IO stream is not opened when a `Lazy::File` is created.
This allows you to store references to your files without using up buffers or file
descripters.

```ruby
file = Lazy.file('hello.txt')
file.io                 #=> nil
file.puts 'hello world'
file.io                 #=> <File:hello.txt>
file.io.closed?         #=> true
```

A `Lazy::File` stores an absolute reference to your file, so you do not lose the
file reference when you change directories

```ruby
lazy = Lazy.file('README.md')
norm = File.open('README.md')

# cd into tmp/
Lazy.dir('tmp') do
  lazy.path #=> /home/michael/code/lazy_files/README.md
  norm.path #=> will raise an error
end
```

Just like with a `File` you can quickly open and close a file by passing the `Lazy.file`
method a block.

```ruby
file = LazyFile.file('hello.txt') do |f|
  f #=> <File:hello.txt>
  f.print 'hello_world'
end
file.io.closed? #=> true
```

A `Lazy::File` is nothing but a reference. The file must already exist for you to
reference it.

```ruby
Lazy.file('nofile.txt') #=> nil
```

if you want to create a file, call the `mkfile` method.

```ruby
Lazy.mkfile('nofile.txt') #=> <LazyFile:nofile.txt>
```

### Lazy::Dir

A `Lazy::Dir` works very similar to a `Lazy::File`

```ruby
Lazy.dir('docs')     #=> <LazyDir:docs>
Lazy.mkdir('newdir') #=> <LazyDir:newdir>
```

```ruby
# You can cd into a directory by passing a block.
Lazy.pwd   #=> /
Lazy.dir('docs') do
  Lazy.pwd #=> /docs
end

# or use the `cd` method
dir = Lazy.dir('docs')
dir.cd do
  Lazy.pwd #=> /docs
end

Lazy.pwd   #=> /
dir.cd
Lazy.pwd   #=> /docs
```

### Command-Line Utils

- `wd`     - returns a `Lazy::Dir` for the working directory
- `pwd`    - prints out the current dir (useful for debugging)
- `mkfile` - creates a new file and returns a `Lazy::File`
- `mkdir`  - creates a new directory and returns a `Lazy::Dir`
- `ls`     - returns an array of all items in the working directory in their Lazy form


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
