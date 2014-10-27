# LazyFiles(v0.0.4)
**warning**: This software was last left in an alpha stage. Some of the APIs listed below are yet to be implemented, or were lost due to me barely knowing how to use git at the time. Use at your own caution.

A Library to make File-Handling in Ruby simple(r).

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
```

prints...

```
Gemfile
Gemfile.lock
lazy_files.gemspec
LICENSE
Rakefile
README.md
```

### Lazy::File

LazyFiles runs off of the idea of a `File` wrapper I call a `Lazy::File`. To create a
`Lazy::File` simply call `Lazy.file`

```ruby
Lazy.file('readme.md') #=> <LazyFile:readme.md>
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

Unlike the `File` object, an IOStream is not opened when a `Lazy::File` is created.
This allows you to store references to your files without using up buffers or file
descripters.

```ruby
file = Lazy.file('hello.txt')
file.stream             #=> nil
file.puts 'hello world'
file.stream             #=> <File:hello.txt>
file.close              #=> true
file.stream             #=> nil
```

**IMPORTANT** if you have never worked with an IOStream before there is an important concept
to take hold of. When you open an IOStream you are sectioning off a buffer. This means
that **any stream left open will leak memory and file descriptors!** Even though Ruby eventually
closes the stream through garbage collection, its always good practice to **close your streams**
after you're done with them.

With a `Lazy::File` you can close it with `#close`.

```ruby
file = Lazy.file('hello.txt')
file.puts 'stuff...'
file.close #=> will close the stream and reset file#stream to nil
```

Just like with a `File` you can also quickly open and close a file by passing `Lazy#file`
a block.

```ruby
file = LazyFile.file('hello.txt') do |f|
  f.print 'hello_world'
end
file.closed? #=> true
```

A `Lazy::File` is nothing but a reference. The file must already exist for you to
reference it.

```ruby
Lazy.ls #=> []
Lazy.file('nofile.txt') #=> nil
```

if you want to create a file, call the `mkfile` method.

```ruby
Lazy.mkfile('nofile.txt') #=> <LazyFile:nofile.txt>
Lazy.ls #=> [<LazyDir:nofile.txt>]
```

### Lazy::Dir

A `Lazy::Dir` works very similar to a `Lazy::File`

```ruby
Lazy.dir('docs')     #=> <LazyDir:docs>
Lazy.mkdir('newdir') #=> <LazyDir:newdir>
```

You can cd into a directory by passing a block.

```ruby
Lazy.pwd   #=> /
Lazy.dir('docs') do
  Lazy.pwd #=> /docs
end
```

or use the `cd` method

```ruby
dir = Lazy.dir('docs')
dir.cd do |d|
  d #=> <LazyDir:/docs>
  Lazy.pwd #=> /docs
end

Lazy.pwd   #=> /
dir.cd
Lazy.pwd   #=> /docs
```

You can also use `Lazy::cd`.

```ruby
Lazy.cd('docs') do
  Lazy.pwd #=> /docs
end
```

If you for some odd reason you want to open a stream to your `LazyDir`,
you can do it the same way you would in a normal `Dir`

```ruby
dir = dir('docs')
dir.open
dir.tell
dir.read
dir.close
```

### Command-Line Utils

- `wd`/`pwd` - returns a `Lazy::Dir` for the working directory
- `mkfile`   - creates a new file and returns a `Lazy::File`
- `mkdir`    - creates a new directory and returns a `Lazy::Dir`
- `ls`       - returns an array of all items in the working directory in their Lazy form


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
