module VGH
module Extended_AWS
module Extended_EC2

# Creates a snapshot of the specified volume.
#
# == Usage
#
#     snap = Snapshot.new.
#     snap.create(id, tag)
#
class Snapshot

  # @return [Object] The Snapshot object
  attr_reader :snapshot

  # The workflow to create a snapshot:
  # - create snapshot
  # - add a name tag
  # - add an info tag
  # @param [String] volume_id The ID of the volume to snapshot
  # @param [String] volume_tag The Tag of the volume to snapshot
  def create(volume_id, volume_tag)
    create_snapshot(volume_id, volume_tag)
    name_tag
    info_tag(volume_id)
    message.info "Creating and tagging snapshot \"#{snapshot.id}\""
  end

  # Creates a snapshot for the specified volume
  # @param [String] volume_id The ID of the volume to snapshot
  # @param [String] volume_tag The tag of the volume to snapshot
  # @return [Object] The newly created snapshot object
  def create_snapshot(volume_id, volume_tag)
    @snapshot = ec2.volumes[volume_id].
      create_snapshot("Backup for #{volume_id}(#{volume_tag})")
  end

  # Creates a name tag for the newly created snapshot.
  # The name is the FQDN of the current instance.
  def name_tag
    ec2.snapshots[snapshot.id].tag('Name', :value => fqdn)
  end

  # Creates an info tag for the newly created snapshot
  def info_tag(volume_id)
    ec2.snapshots[snapshot.id].tag("Backup_#{instance_id}", :value => volume_id)
  end

  # Purges expired snapshots
  def purge
    expired.each do |snap|
      message.info "Deleting expired snapshot (#{snap.id})"
      snap.delete
    end
  end

  # Creates a list of expired snapshots according to the expiration time
  # specified in the app's configuration file
  # @return [Array] An array of expired snapshot objects
  def expired
    @expired = []
    all.each {|snap|
      if snap.start_time < (Time.now - app_config[:expiration]*24*60*60)
        @expired.push snap
      end
    }
    return @expired
  end

  # Returns a list of snapshots that are named the same with the current FQDN.
  def all
    @all ||= ec2.snapshots.
      with_owner('self').
      tagged('Name').tagged_values(fqdn)
  end

end # class Snapshot

end # module Extended_EC2
end # module Extended_AWS
end # module VGH

require 'vgh/system'
require 'vgh/output'
require 'vgh/configuration'
require 'vgh/extended_aws/extended_ec2/metadata'
