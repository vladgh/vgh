require 'helpers/spec'
require 'vgh'
require 'vgh/cli'
require 'vgh/apps'
require 'vgh/output'
require 'vgh/logging'
require 'vgh/configuration'

describe VGH::Output do
  let(:message) {VGH::Output.new}
  it "Should write messages" do
    message.should_receive(:stdout).with("RSpec Test")
    message.stdout("RSpec Test")
  end
end
