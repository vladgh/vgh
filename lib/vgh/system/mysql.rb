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
    cfg         = app_config
    @mysqladmin = '/usr/bin/mysqladmin'
    @mysql      = '/usr/bin/mysql'
    @user       = cfg[:mysql_user]
    @password   = cfg[:mysql_pwd]
  end

  # Check if server is running and we have access to the credentials file
  # @return [Boolean]
  def mysql_exists?
    mysql_exists = false
    if File.exists?(@mysqladmin)
      mysql_exists = system "#{@mysqladmin} -s ping"
    end
    return mysql_exists
  end

  # Lock & Flush the MySQL tables
  def flush
    if mysql_exists?
      message.info 'Locking MySQL tables...'
      `#{@mysql} -u#{@user} -p#{@password} -e "FLUSH TABLES WITH READ LOCK"`
    end
  end

  # Unlock the MySQL tables
  def unlock
    if mysql_exists?
      message.info 'Unlocking MySQL tables...'
      `#{@mysql} -u#{@user} -p#{@password} -e "UNLOCK TABLES"`
    end
  end

end # class MySQL
end # module System
end # module VGH

require 'vgh/output'
require 'vgh/configuration'
