module VGH

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
  def snap_and_tag(volume_id, description, tags)
    @volume_id   = volume_id
    @description = description
    @tags        = tags
    create_snapshot
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
    tag_snapshot
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
  def purge_backups_for(*args)
    expired_backups_for(*args).each do |snap|
      message.info "Deleting expired snapshot (#{snap.id})"
      snap.delete
    end
  end

  # Purges expired snapshots
  def purge_checkpoints_for(*args)
    expired_checkpoints_for(*args).each do |snap|
      message.info "Deleting checkpoint (#{snap.id})"
      snap.delete
    end
  end

  # Creates a list of expired snapshots according to the expiration time
  # specified in the app's configuration file
  # @return [Array] An array of expired snapshot objects
  def expired_backups_for(vid)
    @expired_backups = []
    all_backups.tagged('BACKUP').tagged_values(vid).
      each {|snap|
        if snap.start_time < (Time.now - backup_expiration*24*60*60)
          @expired_backups.push snap
        end
      }
    return @expired_backups
  end

  # Creates a list of checkpoints that should be purged
  # @return [Array] An array of snapshot objects
  def expired_checkpoints_for(vid)
    @expired_checkpoints = all_backups.
      tagged('CHECKPOINT').tagged_values(vid).
      sort_by(&:start_time).reverse.
      drop(checkpoints_to_keep)
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

  # How many checkpoints should be kept
  def checkpoints_to_keep
    keep = config[:checkpoints]
    if keep.nil?
      @checkpoints_to_keep = 5
    else
      @checkpoints_to_keep = keep
    end
    return @checkpoints_to_keep.to_i
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
