require 'open-uri'
require 'net/http'
require 'uri'

module VGH
module Extended_AWS
module Extended_EC2

# This class gathers metadata information about the current instance, used by
# the applications in this gem.
#
# == Usage
#
#     data = Metadata.new
#     id   = data.instance_id
#     root = data.root_device
#
class MetaData

  # Query the API server for the instance ID
  # @return [String, nil] The current instance's ID
  def instance_id
    begin
      @instance_id = open('http://instance-data/latest/meta-data/instance-id').read
    rescue
      message.fatal 'Could not get Instance ID!'
    end
  end

  # Query the API server for the root device
  # @return [String, nil] The root device of the current instance
  def root_device
    begin
      @root_device = open('http://instance-data/latest/meta-data/block-device-mapping/root').read
    rescue
      message.fatal 'Could not get the root device!'
    end
  end

end

end # module Extended_EC2
end # module Extended_AWS
end # module VGH

require 'vgh/output'
