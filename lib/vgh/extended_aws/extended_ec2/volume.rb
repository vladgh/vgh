module VGH
module Extended_AWS
module Extended_EC2

# Collects information about the EBS volumes attached to the current instance.
# == Usage
#     @volume = Volume.new
#     @volume.list.map {|id, info|
#       puts id
#       puts info[:tag]
#       puts info[:device)
#     }
#
class Volume

  # @return An instance object
  def instance
    @instance ||= ec2.instances[instance_id]
  end

  # Creates a Hash collection of volumes containing their id, tag and device
  # @return [Hash]
  def list
    @list = {}
    mappings.map {|device, info|
      volume_id = info.volume.id
      @list[volume_id] = {
        :device => device,
        :tag => tag(volume_id)
      }
    }
    return @list
  end

  # Returns a Hash containing the block device mappings of the current instance.
  # @return [Hash]
  def mappings
    message.info "Creating a list of volumes..."
    @mappings ||= instance.block_device_mappings
  end

  # Get volume's Name tag
  # @return [String] The tag of the volume or (NOTAG) if a tag does not exists.
  def tag(volume_id)
    v_tags = tags(volume_id)
    v_tags.count == 0 ? @tag = '(NOTAG)' : @tag = v_tags.first.value
  end

  # Returns a collection of tags for the specified volume.
  # @param [String] volume_id The id of the volume to query for tags.
  def tags(volume_id)
    @tags = ec2.tags.
      filter('resource-type', 'volume').
      filter('key', 'Name').
      filter('resource-id', volume_id)
  end

end # class Volume

end # module Extended_EC2
end # module Extended_AWS
end # module VGH

require 'vgh/output'
require 'vgh/configuration'
require 'vgh/extended_aws/extended_ec2/metadata'
