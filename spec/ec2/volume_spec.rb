require 'helpers/spec'

require 'aws-sdk'
require 'vgh/ec2/volume'

describe VGH::EC2::Volume do

  include_context 'AWS Dummy'

  let(:volume) {VGH::EC2::Volume.new}

  before(:each) do
    volume.stub(:message).and_return(Dummy.new)
    volume.stub(:ec2).and_return(@ec2)
  end

  it "Should return an instance" do
    volume.stub(:instance_id).and_return(@instance.id)
    volume.instance.should be_a(AWS::EC2::Instance)
  end

  it "Should create a hash with block device mappings" do
    volume.stub_chain(:instance, :block_device_mappings).
      and_return(@instance_mappings)
    volume.mappings.should be_a_kind_of Hash
  end

  it "Should return a collection of volume tags" do
    volume.volume_tags(@volume2.id).should be_a(@tag_collection)
  end

  it "Should return the value of the name tag or (NOTAG)" do
    volume.name_tag(@volume1.id).should be_a String
  end

  it "Should create a list of volumes" do
    volume.stub(:mappings).and_return(@instance_mappings)
    volume.list.should be_a Array
  end

  it "Should return a list of volumes that need a checkpoint" do
    volume.stub(:list).and_return([])
    volume.list_tagged('CHECKPOINT').should be_a Array
  end

end

