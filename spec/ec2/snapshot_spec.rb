require 'helpers/spec'
require 'aws-sdk'
require 'vgh/ec2/snapshot'
require 'vgh/system'

describe VGH::EC2::Snapshot do

  include_context 'AWS Dummy'
  let(:snap) {VGH::EC2::Snapshot.allocate}

  before(:each) do
    snap.stub(:snapshot).and_return(@snapshot)
    snap.stub(:message).and_return(Dummy.new)
    snap.stub(:tags).and_return(@tag_hash)
    snap.stub(:ec2).and_return(@ec2)
    snap.stub(:fqdn).and_return(@fqdn)
  end

  it "Should tag a snapshot" do
    snap.tag_snapshot.each{|t|
      t.should be_a AWS::EC2::Tag
    }
  end

  it "Should list all snapshots" do
    snap.all_backups.should be_an AWS::EC2::SnapshotCollection
  end

  it "Should create a list of expired backups" do
    snap.expired_backups_for(@volume1.id).should be_an Array
  end

  it "Should create a list of expired checkpoints" do
    snap.stub(:config).and_return({:checkpoints => 2})
    snap.expired_checkpoints_for(@volume1.id).should be_an Array
  end


  it "Should return a backup expiration integer" do
    snap.stub(:config).and_return({:expiration => 5})
    snap.backup_expiration.should eq(5)
  end

end

