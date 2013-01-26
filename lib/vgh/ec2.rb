require 'aws-sdk'

module VGH

  # Creates a global ec2 method.
  def ec2
    $ec2 = AWS::EC2.new
  end

  # EC2 Module
  module EC2
  end

end # module VGH

