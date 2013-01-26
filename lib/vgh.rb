# Try to load rubygems.  Hey rubygems, I hate you.
begin
  require 'rubygems'
rescue LoadError
end

require 'aws-sdk'
require 'sinatra'

require 'yaml'
require 'logger'
require 'erb'
require 'open-uri'
require 'net/http'
require 'uri'
require 'optparse'

# See the {file:README.rdoc README} file.
module VGH

  # The main run method
  def run

    # Display header
    show_header

    # Run apps
    case app
    when 'ec2-backup'
      APPS::EC2_Backup.new.run
    when 'checkpoint'
      APPS::Checkpoint.new.run
    end

    # Display footer
    show_footer

  end # end run method

  # Returns the header
  def show_header
    message.header
  end

  # Returns the footer
  def show_footer
    message.footer
  end

end # module VGH

require "vgh/output"
require "vgh/apps"
require "vgh/apps/ec2_backup"
require "vgh/apps/checkpoint"
