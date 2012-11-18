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
> This is currently out of date and needs some updating.

```ruby
Lazy.pwd() #=> <Dir:/home/michael/code>
```

```ruby
Lazy.dir( './' ) #=> <Dir:/>
Lazy.dir( '~/code' ) #=> <Dir:/home/michael/code>
```

```ruby
Lazy.cd( '/' ) #=> <Dir:/>
Lazy.cd( '/' ) do |dir|
  # call stuff
end
```

```ruby
Lazy.ls() #=> [<Dir:src>,<Dir:bin>,<File:README.md>]
Lazy.ls[0] #=> <Dir:src>
Lazy.ls.each do |file|
  puts file
end
Lazy.ls( only: 'dirs' ) #=> [<Dir:src>,<Dir:bin>]
Lazy.ls( ext: 'md' ) #=> ['README.md']
```

```ruby
Lazy.file( 'index.html' ).ext() #=> 'html'
Lazy.file( 'logo.png' ).ext?('html') #=> false
```

```ruby
Lazy.count() #=> 21
Lazy.count( ext: 'html' ) #=> 21
```

```ruby
Lazy.collect( ext: 'js' ) #=> [<File:app.js>]
Lazy.collect( 'assets/js', ext: 'js' ) #=> [<File:main.js>]
Lazy.collect( 'assets/js', ext: 'js', recursive: true ) #=> [<File:main.js>,<File:bootstrap.js>,<File:jquery.js>]
```

```ruby
Lazy.recursively { |file,cd| ... }
Lazy.recursively( limit: 3 ) { |file,cd| ... }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
