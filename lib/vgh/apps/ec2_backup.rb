module VGH
module APPS

  # == Description:
  #
  # See {file:README.rdoc#EC2-Backup EC2-Backup Section} in the README
  # file.
  #
  # == Usage:
  #     backup = APPS::EC2_Backup.new
  #     backup.run
  #
  class EC2_Backup

    # @return [Object] Volumes Class
    attr_reader :volumes

    # @return [Object] Snapshot Class
    attr_reader :snapshot

    # Initialize external classes
    def initialize
      @volumes ||= EC2::Volume.new
      @snapshot = EC2::Snapshot.new
    end

    # Runs the ec2-backup app logic
    def run

      System.lock

      volumes.list.map {|vid|
        snapshot.snap_and_tag(
          vid,
          "Backup for #{vid}(#{volumes.name_tag(vid)})",
          {
            'Name'   => fqdn,
            'BACKUP' => "#{vid}"
          }
        )
        snapshot.purge_backups
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

