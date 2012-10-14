require 'logger'

module VGH

  # Returns log state
  def log
    if logging?
      $log ||= Logging.new.log
    else
      $log ||= Logger.new('/dev/null')
    end
  end

  # == Description:
  #
  # This class logs messages if logging is enabled from the command line
  # options. The default location of the log files is +/var/log/vgh.log+.
  #
  # This class uses the Ruby Logger standard library.
  #
  #
  # == Usage:
  #
  #     log = Logging.new.log
  #     log.info "This is an info message"
  #
  class Logging

    # Defaults
    def defaults
      @path  = '/var/log/vgh.log'
      @level = Logger::INFO
    end

    # Check log file existence
    def initialize
      defaults
      validate_log_directory
    end

    # Creates a log directory and file if it does not already exist
    def validate_log_directory
      dir = File.dirname(@path)
      Dir.mkdir(dir) unless File.exists?(dir)
    end

    # Opens the log file
    def log_file
      File.open(@path, File::WRONLY | File::APPEND | File::CREAT)
    end

    # Global, memoized, lazy initialized instance of a logger
    def log
      # Logger
      @log ||= Logger.new(log_file)
      @log.level = @level
      @log.datetime_format = "%Y-%m-%d %H:%M "  # simplify time output
      @log
    end

  end # class Logging

end # module VGH

require 'vgh/cli'

