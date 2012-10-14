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

    # Loads the necessary classes
    def initialize
      $cfg      = parse_config.app_config
      @mysql    = System::MySQL.new
      @lv       = System::LV.new
      @volume   = Extended_AWS::Extended_EC2::Volume.new
      @snapshot = Extended_AWS::Extended_EC2::Snapshot.new
    end

    # Runs the ec2-backup app logic
    def run
      lock

      begin
        @volume.list.map {|id, info|
          @snapshot.create(id, info[:tag])
        }
      rescue
        message.fatal "Something went wrong in the snapshot creation process!"
      end

      unlock

      @snapshot.purge
    end

    # Flushes MySQL tables and suspends Logical Volumes
    def lock
      @mysql.flush
      @lv.suspend
    end

    # Resumes MySQL and Logical Volumes
    def unlock
      @mysql.unlock
      @lv.resume
    end

  end # class EC2_Backup

end # module APPS
end # module VGH

require 'vgh/output'
require 'vgh/system/lvm'
require 'vgh/system/mysql'
require 'vgh/extended_aws/extended_ec2/volume'
require 'vgh/extended_aws/extended_ec2/snapshot'

