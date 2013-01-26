require 'helpers/spec'
require 'vgh/ec2/metadata'

describe VGH::EC2::MetaData do

  let(:response) {'Remote server response'}
  it 'Should receive valid response from the AWS metadata server' do
    subject.stub_chain(:open, :read).and_return(response)
    subject.instance_id.should eq(response)
    subject.root_device.should eq(response)
  end

end

