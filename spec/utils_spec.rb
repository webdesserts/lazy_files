require 'spec_helper'
require 'lazy_files/dirs/dir'
require 'lazy_files/utils/utils'


describe Lazy do
  init()
  it { should respond_to :pwd }
  it { should respond_to :wd}
  describe "#wd" do
    subject(:wd) { Lazy.wd }
    it { should be_an_instance_of Lazy::Dir }
    it "should be the current directory" do
      wd.path.should == Dir.pwd
    end
  end
end

