module VGH
module EC2

# Collects information about the EBS volumes attached to the current instance.
# == Usage
#     volumes = Volume.new
#     puts volumes.list
#     puts volumes.list_tagged('MyTag')
#
class Volume

  # Creates an array with the IDs of all the volumes attached to the current
  # instance
  # @return [Array]
  def list
    @list = []
    mappings.map {|device, info| @list.push(info.volume.id)}
    return @list
  end

  # Creates an array with the IDs of all the volumes attached to the current
  # instance, that contain a specific tag key
  # @param [String] tag_key The Tag to look for
  # @return [Array]
  def list_tagged(tag_key)
    @list_tagged = []
    list.each {|vid|
      volume_tags(vid).map {|volume_tag|
        @list_tagged.push(vid) if volume_tag.key == tag_key
      }
    }
    return @list_tagged
  end

  # Returns a Hash containing the block device mappings of the current instance.
  # @return [Hash]
  def mappings
    message.info "Creating a list of volumes..."
    @mappings ||= instance.block_device_mappings
  end

  # The current instance object
  # @return [Instance] An instance object
  def instance
    @instance ||= ec2.instances[instance_id]
  end

  # Get volume's Name tag
  # @param [String] volume_id The ID of the volume
  # @return [String] The tag of the volume or (NOTAG) if a tag does not exists.
  def name_tag(volume_id)
    @name_tag = 'NOTAG'
    volume_tags(volume_id).each {|tag|
      @name_tag = tag.value if tag.key == 'Name'
    }
    return @name_tag
  end

  # Returns a collection of tags for the specified volume.
  # @param [String] volume_id The id of the volume to query for tags.
  # @return [TagsCollection] An array of tag objects
  def volume_tags(volume_id)
    @volume_tags = ec2.tags.
      filter('resource-type', 'volume').
      filter('resource-id', volume_id)
  end

end # class Volume

end # module EC2
end # module VGH


require 'vgh/output'
require 'vgh/configuration'
require 'vgh/ec2'
require 'vgh/ec2/metadata'
