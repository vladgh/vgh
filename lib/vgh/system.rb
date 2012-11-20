module VGH

  # Returns the FQDN (either the one specified in the configuration file or
  # the system's one)
  # @return [String]
  def fqdn
    remote_fqdn = app_config[:fqdn]
    if remote_fqdn
      $fqdn ||= remote_fqdn
    else
      $fqdn ||= System.fqdn
    end
  end

  # Check if the script is run as root
  # @return [Boolean]
  def is_root?
    if Process.uid == 0
      return true
    else
      return false
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

    # Returns the current system's FQDN
    # @return [String]
    def self.fqdn
      $fqdn ||= `hostname -f`
    end

  end # module System

end # module VGH
