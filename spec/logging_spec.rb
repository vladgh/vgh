require 'helpers/spec'
require 'vgh'
require 'vgh/logging'

describe VGH::Logging do
  it "Should write logs" do
    log = VGH::Logging.new.log
    log.should_receive(:info).with("RSpec Test")
    log.info("RSpec Test")
  end
end
