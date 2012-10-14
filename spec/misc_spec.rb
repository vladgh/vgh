require 'spec_helper'
require 'vgh'
require 'vgh/cli'
require 'vgh/apps'
require 'vgh/output'
require 'vgh/logging'
require 'vgh/configuration'

describe "Various Tests" do
  it "Should have an array of supported apps" do
    VGH::APPS.list.should be_an Array
  end

  it "Should write logs" do
    log = VGH::Logging.new.log
    log.should_receive(:info).with("RSpec Test")
    log.info("RSpec Test")
  end

  it "Should write messages" do
    message = VGH::Output.new
    message.should_receive(:stdout).with("RSpec Test")
    message.stdout("RSpec Test")
  end
end
