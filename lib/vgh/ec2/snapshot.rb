module VGH

  # Creates the snapshots
  def snap_and_tag(*args)
    EC2::Snapshot.new(*args)
  end

module EC2

# Creates a snapshot of the specified volume.
#
# == Usage
#
#     Snapshot.new(volume_id, description, tags)
#
class Snapshot

  # Create and tag snapshot, and also purge expired ones
  # @param [String] volume_id The ID of the volume to snapshot
  # @param [String] description The description for the new snapshot
  # @param [Hash] tags A Hash containing the names and values of the tags
  # @return [Snapshot] The Snapshot object.
  def initialize(volume_id, description, tags)
    @volume_id   = volume_id
    @description = description
    @tags        = tags
    create_snapshot
    tag_snapshot
    purge_backups
    return snapshot
  end

  # @return [String] The Volume ID
  attr_reader :volume_id

  # @return [String] The description of the snapshot
  attr_reader :description

  # @return [Hash] The tags hash
  attr_reader :tags

  # @return [Object] The Snapshot object
  attr_reader :snapshot

  # Creates a snapshot for the specified volume
  # @return [Object] The newly created snapshot object
  def create_snapshot
    @snapshot = ec2.volumes[volume_id].
      create_snapshot("#{description}")
    message.info "Created snapshot \"#{snapshot.id}\""
    return @snapshot
  end

  # Tags a Snapshot
  def tag_snapshot
    snap = snapshot
    message.info "Tagging snapshot \"#{snap.id}\"..."
    tags.map {|key, value|
      ec2.tags.create(snap, key, {:value => value})
    }
  end

  # Purges expired snapshots
  def purge_backups
    expired_backups.each do |snap|
      message.info "Deleting expired snapshot (#{snap.id})"
      snap.delete
    end
  end

  # Creates a list of expired snapshots according to the expiration time
  # specified in the app's configuration file
  # @return [Array] An array of expired snapshot objects
  def expired_backups
    @expired_backups = []
    all_backups.each {|snap|
      if snap.start_time < (Time.now - backup_expiration*24*60*60)
        @expired_backups.push snap
      end
    }
    return @expired_backups
  end

  # Check for a an expiration period in the configuration file
  def backup_expiration
    expiration = config[:expiration]
    if expiration.nil?
      @backup_expiration = 7
    else
      @backup_expiration = expiration
    end
    return @backup_expiration.to_i
  end

  # Returns a list of snapshots that are named the same with the current FQDN.
  def all_backups
    @all ||= ec2.snapshots.
      with_owner('self').
      tagged('Name').tagged_values(fqdn)
  end

end # class Snapshot

end # module EC2
end # module VGH

require 'vgh/system'
require 'vgh/output'
require 'vgh/configuration'
require 'vgh/ec2'
require 'vgh/ec2/metadata'
require 'vgh/ec2/volume'
