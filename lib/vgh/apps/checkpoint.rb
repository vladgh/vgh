module VGH
module APPS

  # == Description:
  #
  # See {file:README.rdoc#Checkpoint Checkpoint Section} in the README
  # file.
  #
  # == Usage:
  #     checkpoint = APPS::Checkpoint.new
  #     checkpoint.run
  #
  class Checkpoint

    # @return [Object] Volumes Class
    attr_reader :volumes

    # @return [Object] Snapshot Class
    attr_reader :snapshot

    # Initialize external classes
    def initialize
      @volumes ||= EC2::Volume.new
      @snapshot = EC2::Snapshot.new
    end

    # Runs the checkpoint app logic
    def run

      System.lock

      volumes.list_tagged('CHECKPOINT').map {|vid|
        snapshot.snap_and_tag(
          vid,
          "CHECKPOINT for #{vid}(#{volumes.name_tag(vid)})",
          {
            'Name'   => fqdn,
            'CHECKPOINT' => "#{vid}"
          }
        )
        snapshot.purge_checkpoints_for vid
      }

      System.unlock

    end

  end # class EC2_Backup

end # module APPS
end # module VGH

require 'vgh/output'
require 'vgh/configuration'
require 'vgh/system/lvm'
require 'vgh/system/mysql'
require 'vgh/ec2/volume'
require 'vgh/ec2/snapshot'

