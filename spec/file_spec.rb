require 'spec_helper'
require 'lazy_files/files/file'

describe Lazy::File do
  before(:all) { Dir.chdir TESTDIR }
  after(:each) { Spwn.clean TESTDIR }
  after(:all) do
    Dir.chdir ROOT
    Spwn.clean TESTDIR
  end
  subject(:file) { Lazy.mkfile('hello.txt') }

  its(:io) { should be_nil }
  its(:path) { should == File.join(TESTDIR, 'hello.txt')}

  it { should respond_to :basename }
  it { should respond_to :exist? }
  it { should respond_to :exists? }
  it { should respond_to :open }
  it 'should respond to all path based File methods' do
    Lazy::File::PATHBASED_METHODS.each do |method_name|
      should respond_to method_name
    end
  end

  context '#new' do
    context "with a block passed" do
      it "should open and immediately close a file" do
        Spwn.file('hello', ext:'txt')
        io = nil
        Lazy::File.new('hello.txt') do |f|
          io = f
        end
        io.should be_closed
      end
      it "should allow access to the file" do
        Spwn.file('hello', ext:'txt')
        Lazy::File.new('hello.txt') do |f|
          f.print "hello world"
        end
        `cat hello.txt`.should == "hello world"
      end
      it "should raise an error if the file doesn't exist" do
        expect { Lazy::File.new('hello.txt') }.to raise_error Errno::ENOENT
      end
    end
  end

  context '#basename' do
    it "should return the file's current basename" do
      file.basename.should == 'hello.txt'
    end
    context 'when the :ext option is false' do
      it 'it should return the name without an extension' do
        file.basename(ext: false).should == 'hello'
      end
      it 'should return the files name' do
        Lazy.mkfile('hello.jpg').basename(ext: false).should == 'hello'
      end
      it 'should work with dotfiles' do
        Lazy.mkfile('.gitignore').basename(ext: false).should == '.gitignore'
      end
      it 'should work with multiple extensions' do
        Lazy.mkfile('main.js.coffee').basename(ext: false).should == 'main.js'
      end
    end
  end

  context '#exist?' do
    it "should pass the files path to the File equivilant" do
      File.should_receive(:exist?).with(file.path)
      file.exist?
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
    subject(:file) { Lazy.mkfile('hello.txt') }
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
      file = Lazy.mkfile('testfile.jpeg')
      Lazy.basename(file)
    end
  end

  context '::file' do
    it { should respond_to :file}
    it 'should return nil if the file does not exist' do
      Lazy.file('testfile.jpeg').should be_nil
    end
    it 'should return the file if it does exist' do
      Spwn.dir('hello') do
        Spwn.file('testfile',ext:'jpeg')
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
