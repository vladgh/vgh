require 'helpers/spec'
require 'vgh/apps'

describe VGH::APPS do
  it "Should have an array of supported apps" do
    subject.list.should be_an Array
  end
end
