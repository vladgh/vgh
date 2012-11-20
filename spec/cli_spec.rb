require 'helpers/spec'
require 'vgh'
require 'vgh/apps'
require 'vgh/cli'

describe VGH::CLI do

  let(:app) {VGH::APPS.list.shuffle.first}

  before(:all) do
    ARGV[0] = app
  end

  it "Should get the app name as the first argument" do
      VGH::CLI.new.options[:app].should eq app
    end

  context "When '-v' passed to the command line" do
    it "Verbosity should be enabled" do
      ARGV.push('-v')
      VGH::CLI.new.options[:verbose].should be_true
    end
  end

  context "When '-v' NOT passed to the command line" do
    it "Verbosity should be disabled" do
      VGH::CLI.new.options[:verbose].should be_false
    end
  end

  context "When '-l' passed to the command line" do
    it "Logging should be enabled" do
      ARGV.push('-l')
      VGH::CLI.new.options[:logging].should be_true
    end
  end

  context "When '-l' NOT passed to the command line" do
    it "Logging should be disabled" do
      VGH::CLI.new.options[:logging].should be_false
    end
  end

end
