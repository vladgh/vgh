require 'spec_helper'
require 'vgh'
require 'vgh/apps'
require 'vgh/cli'

describe "Command Line" do
  VGH::APPS.list.map {|app_name|
    it "Should accept '#{app_name}' as the first argument" do
      ARGV[0] = app_name
      VGH::CLI.new.options[:app].should eq app_name
    end
  }

  it "Should enable verbosity" do
    ARGV[0] = VGH::APPS.list.shuffle.first
    ARGV.push('-v')
    VGH::CLI.new.options[:verbose].should be_true
  end

  it "Should enable logging" do
    ARGV[0] = VGH::APPS.list.shuffle.first
    ARGV.push('-l')
    VGH::CLI.new.options[:logging].should be_true
  end
end
