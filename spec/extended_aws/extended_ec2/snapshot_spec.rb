require 'helpers/spec'

require 'aws-sdk'
require 'vgh/extended_aws/extended_ec2/snapshot'
require 'vgh/system'

describe VGH::Extended_AWS::Extended_EC2::Snapshot do

  include_context "Dummy Instance"

  it "Should return a snapshot" do
    subject.snapshot(@volume.id, 'test').should be_a(AWS::EC2::Snapshot)
  end

  it "Should add a Name tag to a snapshot" do
    subject.name_tag.should be_a(AWS::EC2::Tag)
  end

  it "Should add an Info tag to a snapshot" do
    subject.info_tag(@volume.id).should be_a(AWS::EC2::Tag)
  end

  it "Should get a list of all snapshots" do
    subject.all.should be_a(AWS::EC2::SnapshotCollection)
  end

  it "Should create an array of expired snapshots" do
    subject.expired.should be_empty
  end

  it "Should purge expired snapshots" do
    subject.purge.should be_empty
  end

  #it "Should create a list of volumes" do
    #subject.list.should be_a_kind_of Hash
  #end

  #it "Should get a collection of volume tags" do
    #subject.tags(@volume.id).should be_a(AWS::EC2::TagCollection)
  #end

  #it "If no tags, it should return (NOTAG)" do
    #subject.tag(@volume.id).should eq('(NOTAG)')
  #end

end

