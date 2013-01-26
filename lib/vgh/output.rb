module VGH

  # Creates a global message method
  def message
    $message ||= Output.new
  end

  # == Description:
  #
  # This class sends messages to +STDOUT+ or to a log file. It takes the following
  # standard methods:
  # - +debug+
  # - +info+
  # - +warn+
  # - +error+
  # - +fatal+
  #
  # If +stdout+ is called then the message is only sent to +STDOUT+.
  #
  # If +header+ or +footer+ is called then it displays them.
  #
  #
  # == Usage:
  #     # Load output
  #     message = Output.new
  #
  #     message.header
  #
  #     message.info "Starting code"
  #     # Your code here
  #     message.info "End code"
  #
  #     message.footer
  #
  class Output

    # Debug message
    attr_reader :debug
    # Inforational message
    attr_reader :info
    # Warning message
    attr_reader :warn
    # Error message
    attr_reader :error
    # Fatal Error message
    attr_reader :fatal
    # Header
    attr_reader :header
    # Footer
    attr_reader :footer

    # Writes a debug log message and outputs to screen
    def debug(message)
      log.debug(message)
      stdout message
    end

    # Writes an info log message and outputs to screen
    def info(message)
      log.info(message)
      stdout message
    end

    # Writes an warn log message and outputs to screen
    def warn(message)
      log.warn(message)
      stdout message
    end

    # Writes an error log message and outputs to screen
    def error(message)
      log.error(message)
      stdout message
    end

    # Writes a fatal log message and outputs to screen
    def fatal(message)
      log.fatal(message)
      stdout message
    end

    # Outputs a message to screen
    def stdout(message)
      puts message if verbose?
    end

    # Returns the header
    def header
     stdout <<END_HEADER
###############################################################################
VladGh.com - Scripts (v#{VERSION})
#{Time.now.strftime("%m/%d/%Y %H:%M:%S(%Z)")}
###############################################################################

END_HEADER
    end

    # Returns the footer
    def footer
      stdout <<END_FOOTER

###############################################################################"
END_FOOTER
    end

  end # class Output
end # module VGH

require 'vgh/cli'
require 'vgh/logging'
