require 'spec_helper'
require 'lazy_files/dirs/dir'

describe Lazy::Dir do
  init
  subject(:dir) { Lazy.mkdir('hello') }

  its(:stream) { should be_nil }
  its(:path) { should == File.join(TESTDIR, 'hello') }

  it 'should respond to all path based Dir methods' do
    Lazy::Dir::PATHBASED_METHODS.each do |method_name|
      should respond_to method_name
    end
  end

  describe '#new' do
    before(:each) { Lazy.mkdir('hello') }
    context 'without a block' do
      subject { Lazy::Dir.new('hello') }
      it { should be_an_instance_of Lazy::Dir }
      it { should be_closed }
    end
    context "with a block" do
      it "should cd into the directory" do
        Lazy.dir('hello') do
          ::File.basename(::Dir.pwd).should == 'hello'
        end
      end
    end
    it "should raise an error if the dir doesn't exist" do
      expect { Lazy::Dir.new('nodir') }.to raise_error Errno::ENOENT
    end
  end

  describe '#open' do
    subject(:dir) { Lazy.mkdir('hello') }
    context "with a block" do
      it "should close the stream immediately after" do
        dir.open(){}
        dir.should be_closed
      end
      it 'should open the stream for the duration of the block' do
        dir.open do |d|
          d.should be_open
        end
      end
    end
  end

  describe '#basename' do
    it "should return the file's current basename" do
      dir.basename.should == 'hello'
    end
  end

  describe '#cd' do
    context "with a block" do
      it "should change the working directory" do
        dir.cd do |d|
          Dir.pwd.should == dir.path
        end
      end
      it "should yield the Lazy::Dir passed" do
        dir.cd do |d|
          d.should be dir
        end
      end
      it "should reset working directory after exiting the block" do
        expect { dir.cd{} }.to_not change{
          ::Dir.pwd
        }.from(TESTDIR).to(dir.path)
      end
    end
    context "without a block" do
      it "should change the working directory" do
        expect { dir.cd }.to change{
          ::Dir.pwd
        }.from(TESTDIR).to(dir.path)
      end
    end
  end
end

describe Lazy do
  init
  let!(:dir) { Lazy.mkdir('hello') }
  describe '::mkdir' do
    it "should return a Lazy::Dir" do
      dir.should be_an_instance_of Lazy::Dir
    end
  end
  describe '::cd' do
    it "should accept a Lazy::Dir" do
      Lazy.cd(dir)
      Dir.pwd.should == dir.path
    end
    it "should return a Lazy::Dir" do
      Lazy.cd(dir).should be_an_instance_of Lazy::Dir
    end
    context "with a block" do
      it "should change the working directory" do
        Lazy.cd('hello') do |d|
          Dir.pwd.should == dir.path
        end
      end
      it "should yield the Lazy::Dir passed" do
        Lazy.cd(dir) do |d|
          d.should be dir
        end
      end
      it "should reset working directory after exiting the block" do
        expect { Lazy.cd('hello'){} }.to_not change{
          ::Dir.pwd
        }.from(TESTDIR).to(dir.path)
      end
    end
    context "without a block" do
      it "should change the working directory" do
        expect { Lazy.cd('hello') }.to change{
          ::Dir.pwd
        }.from(TESTDIR).to(dir.path)
      end
    end
  end
end
