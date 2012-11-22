require 'spec_helper'
require 'lazy_files/files/file'

describe Lazy::File do
  before(:all) { Dir.chdir TESTDIR }
  after(:each) { Spwn.clean TESTDIR }
  after(:all) { Dir.chdir ROOT}
  subject(:file) { Lazy.file('hello.txt') }

  its(:io) { should be_nil }
  its(:path) { should == File.join(TESTDIR, 'hello.txt')}

  it { should respond_to :basename }

  context '#basename' do
    it "should return the file's current basename" do
      file.basename.should == 'hello.txt'
    end
    context 'when the with_ext option is false' do
      it 'it should return the name without an extension' do
        file.basename(false).should == 'hello'
      end
      it 'should return the files name' do
        Lazy.file('hello.jpg').basename(false).should == 'hello'
      end
      it 'should work with dotfiles' do
        Lazy.file('.gitignore').basename(false).should == '.gitignore'
      end
      it 'should work with multiple extensions' do
        Lazy.file('main.js.coffee').basename(false).should == 'main.js'
      end
    end
  end

  context '#name' do
    it 'should return the basename without an extension' do
      file.name.should == 'hello'
    end
  end

  context '#exist?' do
    it 'should respond to all path based File methods' do
      Lazy::File::PATHBASED_METHODS.each do |method_name|
        should respond_to method_name
      end
    end
    it 'should be true if the file exists' do
      file.should exist
    end
    it 'should be false if the file does not exist' do
      File.delete(file.path)
      file.should_not exist
    end
  end

  context '#open' do
    subject(:file) { Lazy.file('hello.txt') }
    it 'should allow you to open an access a file' do
      file.open('w') do |f|
        f.puts 'hello world'
      end
      `cat hello.txt`.strip.should == 'hello world'
    end
    it "should set an io value if a block isn't given" do
      file.open('w')
      file.io.should be_an_instance_of File
    end
    it 'should return a File object' do
      file.open('w').should be_an_instance_of File
    end
  end

end

describe Lazy do
  before(:all) { Dir.chdir TESTDIR }
  after(:each) { Spwn.clean TESTDIR }
  after(:all) { Dir.chdir ROOT}
  context "::basename" do
    it { should respond_to :basename }
    it 'should accept a path' do
      Lazy.basename('hello/testfile.jpeg').should == 'testfile.jpeg'
    end
    it 'should accept a Lazy::File' do
      Spwn.file('testfile.jpeg')
      file = Lazy.file('testfile.jpeg')
      Lazy.basename(file)
    end
  end

  context '::file' do
    it { should respond_to :file}
    it 'should create a file if it does not exist' do
      Lazy.file('testfile.jpeg')
      File.exist?('testfile.jpeg').should be_true
    end
    it 'should return the file' do
      Spwn.dir('hello') do
        Spwn.file('testfile.jpeg')
      end
      Lazy.file('hello/testfile.jpeg').should be_an_instance_of Lazy::File
    end
    it 'should open the file when a block is given' do
      Spwn.file('testfile.jpeg') do |file|
        file.closed?.should be_false
      end
    end
  end
end
