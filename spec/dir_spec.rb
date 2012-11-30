require 'spec_helper'
require 'lazy_files/dirs/dir'

describe Lazy::Dir do
  before(:all) { Dir.chdir TESTDIR }
  after(:each) { Spwn.clean TESTDIR }
  after(:all) do
    Spwn.clean TESTDIR
    Dir.chdir ROOT
  end
  subject(:dir) { Lazy.dir('./hello') }

  its(:io) { should be_nil }
  its(:path) { should == File.join(TESTDIR, 'hello') }

  it 'should respond to all path based Dir methods' do
    Lazy::Dir::PATHBASED_METHODS.each do |method_name|
      should respond_to method_name
    end
  end

  context '#basename' do
    subject(:dir) { Lazy.dir('./hello').basename }
    it { should == 'hello' }
  end
end
