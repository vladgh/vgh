shared_context 'AWS Dummy' do

  before(:all) do
    @fqdn = 'test.example.com'

    AWS.stub!
    AWS.config({:access_key_id => '1234', :secret_access_key => '4321'})
    @ec2 = AWS::EC2.new

    # Instance
    @instance = @ec2.instances['i-12345678']

    # Volumes
    @volume1 = @ec2.volumes['vol-11111111']
    @tag1 = @volume1.tag('Name', :value => 'VolumeName')
    @tag2 = @volume1.tag('Checkpoint')

    @volume2 = @ec2.volumes['vol-22222222']
    @tag3 = @volume2.tag('Checkpoint')

    @volume3 = @ec2.volumes['vol-33333333']

    # Tags
    @tag_collection = AWS::EC2::TagCollection
    @tag_hash = {
      'Name'  => 'TestTag',
      'MyTAG' => 'TestValue'
    }

    # Attachments
    @device1 = '/dev/sdz1'
    @device2 = '/dev/sdz2'
    @device3 = '/dev/sdz3'
    @attachment1 = AWS::EC2::Attachment.new(@volume1, @instance, @device1)
    @attachment2 = AWS::EC2::Attachment.new(@volume2, @instance, @device2)
    @attachment3 = AWS::EC2::Attachment.new(@volume3, @instance, @device3)
    @instance_mappings = {
      @device1 => @attachment1,
      @device2 => @attachment2,
      @device3 => @attachment3
    }

    # Snapshots
    @snapshot = @ec2.snapshots['snap-12345678']

  end

end

