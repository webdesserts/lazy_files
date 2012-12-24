require 'spec_helper'
require 'lazy_files/files/file'

describe Lazy::File do
  init
  subject(:file) { Lazy.mkfile('hello.txt') }

  its(:stream) { should be_nil }
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

  describe '#new' do
    context 'without a block' do
      before(:each) { Spwn.file('hello', ext: 'txt') }
      context 'or a mode' do
        subject(:file) { Lazy::File.new('hello.txt') }
        it { should be_closed }
      end
      context 'but with a mode' do
        subject(:file) { Lazy::File.new('hello.txt','r') }
        it { should be_open }
      end
    end
    context 'with a block' do
      before(:each) { Lazy.mkfile('hello.txt') }
      it 'should close the stream after execution' do
        file = Lazy::File.new('hello.txt')
        file.should be_closed
      end
      context 'and a mode' do
        it 'should open the stream for the duration of the block' do
          Lazy::File.new('hello.txt','w') do |f|
            f.should be_open
          end
        end
      end
      context 'and no mode' do
        it 'should not open the stream' do
          Lazy::File.new('hello.txt') do |f|
            f.should be_closed
          end
        end
        it 'should close any streams opened by methods called within the block' do
          file = Lazy::File.new('hello.txt') do |f|
            f.puts 'hello world'
          end
          file.closed?
        end
      end
    end
    it "should raise an error if the file doesn't exist" do
      expect { Lazy::File.new('nofile.txt') }.to raise_error Errno::ENOENT
    end
  end

  describe '#basename' do
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

  describe '#exist?' do
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

  describe '#open' do
    subject(:file) { Lazy.mkfile('hello.txt') }
    context "with a block" do
      it "should close the file immediately after" do
        file.open('w'){}
        file.should be_closed
      end
      it 'should open the stream for the duration of the block' do
        file.open('w') do |f|
          f.should be_open
        end
      end
    end
    context "without a block" do
      it "should set an stream value if a block isn't given" do
        file.open('w')
        file.stream.should be_an_instance_of File
        file.stream.should_not be_closed
      end
      it 'should return a File object' do
        file.open('w').should be_an_instance_of File
      end
    end
  end

  describe '#print' do
    it "should print a message to the file" do
      file.print 'hello world'
      file.reopen('r') do |f|
        f.read.should == "hello world"
      end
    end
    it "should open the file in write mode" do
      file.print 'hello World'
      expect{ file.read }.to raise_error IOError
    end
  end

  describe '#puts' do
    it "should put a message to the file" do
      file.puts 'hello world'
      file.reopen('r') do |f|
        f.read.should == "hello world\n"
      end
    end
    it "should open the file in write mode" do
      file.puts 'hello World'
      expect{ file.read }.to raise_error IOError
    end
  end

  describe '#ensure_open' do
    context 'with an open stream' do
      let(:file) { Lazy.mkfile('testfile.txt') }
      before(:each) { file.open }
      it "should not change the @stream" do
        stream = file.stream
        file.send(:ensure_open)
        file.stream.should be stream
      end
    end
    context 'with a nil @stream' do
      subject(:file){ file = Lazy.mkfile('test.txt') }
      it "should open a new stream" do
        File.should_receive(:new)
        file.send(:ensure_open) {}
      end
      it "should set the @stream to the used File" do
        expect { file.send(:ensure_open) {} }.to change{
          file.stream
        }.from( nil ).to( File )
      end
    end
  end
end

describe Lazy do
  init
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
