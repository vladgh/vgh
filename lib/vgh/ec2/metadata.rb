require 'open-uri'

module VGH

  # Looks for the instance id in the configuration. If it does not exist then it
  # queries the API server for it.
  # @return [String]
  def instance_id
      remote_instance = config[:instance]
      if remote_instance
        $instance_id ||= remote_instance
      else
        $instance_id ||= VGH::EC2::MetaData.new.instance_id
      end
      return $instance_id
  end

module EC2

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

end # module EC2
end # module VGH

require 'vgh/output'
