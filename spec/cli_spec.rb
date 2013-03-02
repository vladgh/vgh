require 'helpers/spec'
require 'vgh'
require 'vgh/apps'
require 'vgh/cli'

describe VGH::CLI do

  let(:app) {VGH::APPS.list.shuffle.first}
  let(:cli) {VGH::CLI.new.options}

  before(:each) do
    ARGV[0] = app
  end

  it 'Should get the app name as the first argument' do
    cli[:app].should eq app
  end

  it 'No Verbosity' do
    cli[:verbose].should be_false
  end

  it 'Verbosity' do
    ARGV.push('--verbose')
    cli[:verbose].should be_true
  end

  it 'Logging' do
    ARGV.push('--logging')
    cli[:logging].should be_true
  end

  it 'No Logging' do
    cli[:logging].should be_false
  end

end
