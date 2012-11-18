require 'spec_helper'
require 'lazy_files/file'

describe Lazy::File do
  it { should respond_to :basename }
  it { should respond_to :path }
  it { should respond_to :dirname }
  it { should respond_to :executable }
  it { should respond_to :exist }
  it { should respond_to :exists? }
  it { should respond_to :expand_path }
end
