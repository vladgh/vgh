require 'helpers/spec'

require 'vgh/extended_aws/extended_ec2/metadata'

describe VGH::Extended_AWS::Extended_EC2::MetaData do

  before(:each) do
    subject.stub(:message).and_return(Dummy.new)
  end

  it "Should retrieve the instance id" do
    unless subject.instance_id.nil?
      subject.instance_id.should match(/i\-.*/)
    end
  end

  it "Should retrieve the root device" do
    unless subject.root_device.nil?
      subject.root_device.should match(/\/dev\/.*/)
    end
  end

end

