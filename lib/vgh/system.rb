module VGH

  # This is a parent class for different system actions performed by the scripts
  # included in this gem. For more information see the classes defined under
  # this namespace.
  #
  # == Usage
  #
  #     fqdn = System.fqdn
  #
  module System

    # FQDN
    # @return [String] The FQDN of the current machine.
    def self.fqdn
      $fqdn ||= `hostname -f`
    end

  end # module System

end # module VGH
