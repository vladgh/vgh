require 'optparse'

module VGH

  # Returns a global collection of options.
  # @return [Hash]
  def cli
    $cli ||= CLI.new.options
  end

  # Returns the app name specified in the command line
  # @return [String]
  def app
    $app ||= cli[:app]
  end

  # Returns the configuration specified in the command line
  # @return [String]
  def cli_confdir
    $cli_confdir ||= cli[:confdir]
  end

  # Returns verbosity
  # @return [Boolean]
  def verbose?
    $verbose = cli[:verbose]
  end

  # Returns logging
  # @return [Boolean]
  def logging?
    $logging = cli[:logging]
  end

  # == Description:
  #
  # Returns a structure describing the command line options and arguments.
  # See {file:README.rdoc#label-Command+line+options Command line options} in
  # the README file.
  #
  #
  # == Usage:
  #     cli = CLI.new.options
  #     puts cli[:app]
  #     puts cli[:verbose]
  #     puts cli[:logging]
  #     puts cli[:confdir]
  #
  class CLI

    # Command line options
    attr_reader :options

    # We set default values here.
    def defaults
      @options[:app]     = false
      @options[:verbose] = false
      @options[:logging] = false
    end

    # Collect options
    # @param [Array] apps A list of available apps
    # @param [String] app The name of the app
    # @param [Array] args The command line arguments
    def initialize(apps = APPS.list, app = ARGV[0], args = ARGV)
      @options = {}
      @optparse = OptionParser.new()
      defaults
      banner(apps)
      confdir
      verbose
      logging
      help
      version
      validate(args)
      check_app(apps, app)
    end

    # Checks if the provided app is in the available list
    def check_app(apps, app)
      if apps.include? app
        @options[:app] = app
      else
        puts "ERROR: You need to specify one of the following apps: \
#{apps.join(', ')}"
        exit
      end
    end

    # Returns the banner
    def banner(apps)
      header
      available_apps(apps)
      global_options
    end

    # Returns the header of the banner
    def header
      @optparse.banner = 'Usage: vgh app [options]'
      @optparse.separator '========================'
    end

    # Returns a list of available apps
    def available_apps(apps)
      @optparse.separator ''
      @optparse.separator "Available apps: #{apps.join(', ')}"
    end

    # Returns the header of the global options section
    def global_options
      @optparse.separator ''
      @optparse.separator 'Options:'
    end

    # Loads the configuration directory
    def confdir
      @optparse.on('-c', '--confdir \'~/.vgh\'', 'Configuration directory') do |conf|
        path = File.expand_path(conf)
        @options[:confdir] = path if File.directory?(path)
      end
    end

    # Loads the verbosity argument
    def verbose
      @optparse.on('-v', '--[no-]verbose', 'Run verbosely') do |verbose|
        @options[:verbose] = verbose
      end
    end

    # Loads the logging argument
    def logging
      @optparse.on('-l', '--[no-]logging', 'Enable logging') do |logging|
        @options[:logging] = logging
      end
    end

    # Loads the help argument
    def help
      @optparse.on_tail('-h', '--help', 'Show this message') do
        show_help
      end
    end

    # Loads the version argument
    def version
      @optparse.on_tail('-V', '--version', 'Show version') do
        show_version
      end
    end

    # Parses the arguments
    def validate(args)
      begin
        @optparse.parse!(args)
      rescue OptionParser::ParseError,
             OptionParser::InvalidArgument,
             OptionParser::InvalidOption,
             OptionParser::MissingArgument
        puts $!.to_s
        show_help
        exit
      end
    end

    # Returns the help
    def show_help
      puts @optparse
      puts ''
      show_version
      exit
    end

    # Returns a message with the script's version
    def show_version
      puts "VGH Scripts: v#{VGH::VERSION}"
      exit
    end

  end # Class CLI

end # module VGH

require 'vgh/apps'
require 'vgh/version'

