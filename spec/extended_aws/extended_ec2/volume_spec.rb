require 'helpers/spec'

require 'aws-sdk'
require 'vgh/extended_aws/extended_ec2/volume'

describe VGH::Extended_AWS::Extended_EC2::Volume do

  include_context "Dummy Instance"

  it "Should create a hash with block device mappings" do
    subject.mappings.should be_a_kind_of Hash
  end

  it "Should create a list of volumes" do
    subject.list.should be_a_kind_of Hash
  end

  it "Should get a collection of volume tags" do
    subject.tags(@volume.id).should be_a(AWS::EC2::TagCollection)
  end

  it "If no tags, it should return (NOTAG)" do
    subject.tag(@volume.id).should eq('(NOTAG)')
  end

end

