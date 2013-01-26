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

    # Initialize external classes
    def initialize
      @volumes ||= EC2::Volume.new
    end

    # Runs the checkpoint app logic
    def run

      System.lock

      vols = volumes
      vols.list_tagged('CHECKPOINT').map {|vid|
        snap_and_tag(
          vid,
          "CHECKPOINT for #{vid}(#{vols.name_tag(vid)})",
          {
            'Name'   => fqdn,
            'CHECKPOINT' => "#{instance_id};#{vid}"
          }
        )
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

