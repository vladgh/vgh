module VGH

# See {file:README.rdoc#Applications Applications Section} in the README
# file.
#
#
# == Usage:
#     APPS.list
#
module APPS

  # Lists the available applications
  # @return [Array]
  def self.list
    @apps ||= [
      'ec2-backup',
      'checkpoint'
    ]
  end

end # module APPS

end # module VGH
