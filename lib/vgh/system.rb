module VGH

  # Returns the FQDN (either the one specified in the configuration file or
  # the system's one)
  # @return [String]
  def fqdn
    remote_fqdn = config[:fqdn]
    if remote_fqdn
      $fqdn ||= remote_fqdn
    else
      $fqdn ||= System.fqdn
    end
  end


  # This is a parent class for different system actions performed by the scripts
  # included in this gem. For more information see the classes defined under
  # this namespace.
  #
  # == Usage
  #
  #     fqdn = System.fqdn
  #
  module System

    # Check if the script is run as root
    # @return [Boolean]
    def self.is_root?
      if Process.uid == 0
        return true
      else
        return false
      end
    end

    # Returns the current system's FQDN
    # @return [String]
    def self.fqdn
      $fqdn ||= `hostname -f`
    end

    # Returns the current system's FQDN
    # @return [String]
    def self.lock
      unless remotely?
        mysql.flush
        lvm.suspend
      end
    end

    # Returns the current system's FQDN
    # @return [String]
    def self.unlock
      unless remotely?
        mysql.unlock
        lvm.resume
      end
    end

    # Checks if this script is run remotely.
    # @return [Boolean]
    def self.remotely?
      cfg = config
      if cfg[:instance] or cfg[:fqdn]
        return true
      else
        return false
      end
    end

    # Initializes the MySQL class
    def self.mysql
      mysql ||= System::MySQL.new
    end

    # Initializes the LVM class
    def self.lvm
      lvm ||= System::LVM.new
    end

  end # module System

end # module VGH
