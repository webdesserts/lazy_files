require 'spec_helper'
require 'lazy_files/dirs/dir'
require 'lazy_files/cl_utils/cl_utils'

describe Lazy do
  subject { Lazy }
  it { should respond_to :pwd }
  describe "#pwd" do
    subject(:pwd) { Lazy.pwd }
    it { should be_an_instance_of Lazy::LazyDir }
    it "should be the current directory" do
      pwd.path.should == Dir.pwd
    end
  end
end
