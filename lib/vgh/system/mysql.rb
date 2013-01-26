module VGH
module System

# This class checks if a local MySQL server is present and running.
# The credentials need to be specified in the app's configuration file.
#
#
# == Usage
#
#     mysql = MySQL.new
#     mysql.flush
#     # run backup
#     mysql.unlock
#
class MySQL

  # Load defaults
  def initialize
    @mysqladmin_cmd = '/usr/bin/mysqladmin'
    @mysql_cmd      = '/usr/bin/mysql'
  end

  # Get MySQL user
  # @return [String]
  def mysql_user
    @mysql_user ||= config[:mysql_user]
  end

  # Get MySQL password
  # @return [String]
  def mysql_password
    @mysql_password ||= config[:mysql_password]
  end

  # Check if server is running and we have the right credentials
  # @return [Boolean]
  def commands_present?
    commands_present = false
    if File.exists?(@mysqladmin_cmd) and File.exists?(@mysqladmin_cmd)
      commands_present = true
    end
    return commands_present
  end

  # Check if server is running and we have the right credentials
  # @return [Boolean]
  def mysql_exists?
    mysql_exists = false
    server_present = system "#{@mysqladmin_cmd} -s ping" if commands_present?
    if server_present and mysql_user.nil? and mysql_password.nil?
      message.warn 'WARNING: MySQL exists but no credentials were found!'
    elsif ! server_present and ! mysql_user.nil? and ! mysql_password.nil?
      message.warn 'WARNING: MySQL credentials exist but no local server was found!'
    elsif server_present and ! mysql_user.nil? and ! mysql_password.nil?
      mysql_exists = true
    end
    return mysql_exists
  end

  # Lock & Flush the MySQL tables
  def flush
    if mysql_exists?
      message.info 'Locking MySQL tables...'
      `#{@mysql} -u#{mysql_user} -p#{mysql_password} -e "FLUSH TABLES WITH READ LOCK"`
    end
  end

  # Unlock the MySQL tables
  def unlock
    if mysql_exists?
      message.info 'Unlocking MySQL tables...'
      `#{@mysql} -u#{mysql_user} -p#{mysql_password} -e "UNLOCK TABLES"`
    end
  end

end # class MySQL
end # module System
end # module VGH

require 'vgh/output'
require 'vgh/configuration'

