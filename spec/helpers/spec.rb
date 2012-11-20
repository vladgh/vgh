RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

class Dummy
  def method_missing(name, *args, &block)
    #puts "Tried to handle unknown method %s" % name # name is a symbol
    #unless args.empty?
      #puts "It had arguments: %p" % [args]
    #end
  end
end

shared_context "Dummy Instance" do
  before(:each) do
    AWS.stub!
    AWS.config({:access_key_id => '', :secret_access_key => ''})
    @ec2 = AWS::EC2.new
    @instance = AWS::EC2::Instance.new('i-12345678')
    @fqdn = 'test.example.com'
    @volume = AWS::EC2::Volume.new('vol-12345678')
    @snapshot = AWS::EC2::Snapshot.new('snap-12345678')
    @device = '/dev/test'
    @attachment = AWS::EC2::Attachment.new(@volume, @instance, @device)
    @instance.stub(:block_device_mappings).and_return({
      @device => @attachment
    })

    subject.stub(:ec2).and_return(@ec2)
    subject.stub(:instance_id).and_return(@instance.id)
    subject.stub(:fqdn).and_return(@fqdn)
    subject.stub(:instance).and_return(@instance)
    subject.stub(:snapshot).and_return(@snapshot)
    subject.stub(:message).and_return(Dummy.new)
  end
end
