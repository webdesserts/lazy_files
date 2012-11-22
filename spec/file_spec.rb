require 'spec_helper'
require 'lazy_files/files/file'

describe Lazy::File do
  before(:all) { Dir.chdir TESTDIR }
  after(:each) { Spwn.clean TESTDIR }
  after(:all) { Dir.chdir ROOT}
  subject { Lazy.file('test.md') }

  it { should respond_to :basename }
  context "#exist?" do
    it "should respond to all path based File methods" do
      Lazy::File::PATHBASED_METHODS.each do |method_name|
        should respond_to method_name
      end
    end
    it "should be true if the file exists" do
      file = Lazy.file('hello.jpg')
      file.should exist
    end
    it "should be false if the file does not exist" do
      file = Lazy.file('hello.jpg')
      File.delete(file.path)
      file.should_not exist
    end
  end
  context "#name" do
    it "should return the files name" do
      Lazy.file('hello.jpg').name.should == "hello"
    end
    it "should work with dotfiles" do
      Lazy.file('.gitignore').name.should == ".gitignore"
    end
    it "should work with multiple extensions" do
      Lazy.file('main.js.coffee').name.should == "main.js"
    end
  end
end

describe Lazy do
  before(:all) { Dir.chdir TESTDIR }
  after(:each) { Spwn.clean TESTDIR }
  after(:all) { Dir.chdir ROOT}
  context "::basename" do
    it { should respond_to :basename }
    it "should accept a path" do
      Lazy.basename('hello/testfile.jpeg').should == "testfile.jpeg"
    end
    it "should accept a Lazy::File" do
      Spwn.file('testfile.jpeg')
      file = Lazy.file('testfile.jpeg')
      Lazy.basename(file)
    end
  end

  context "::file" do
    it { should respond_to :file}
    it "should create a file if it does not exist" do
      Lazy.file('testfile.jpeg')
      File.exist?('testfile.jpeg').should be_true
    end
    it "should return the file" do
      Spwn.dir('hello') do
        Spwn.file('testfile.jpeg')
      end
      Lazy.file('hello/testfile.jpeg').should be_an_instance_of Lazy::File
    end
    it "should open the file when a block is given" do
      Spwn.file('testfile.jpeg') do |file|
        file.closed?.should be_false
      end
    end
  end
end
