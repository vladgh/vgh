require 'helpers/spec'
require 'vgh'
require 'vgh/apps'
require 'vgh/cli'

describe VGH::CLI do

  let(:app) {VGH::APPS.list.shuffle.first}

  before(:all) do
    ARGV[0] = app
  end

  it 'Should get the app name as the first argument' do
      subject.options[:app].should eq app
  end

  it 'Verbosity' do
    subject.options[:verbose].should be_false
  end

  it 'No Verbosity' do
    ARGV.push('--verbose')
    subject.options[:verbose].should be_true
  end

  it 'Logging' do
    ARGV.push('--logging')
    subject.options[:logging].should be_true
  end

  it 'No Logging' do
    subject.options[:logging].should be_false
  end

end
