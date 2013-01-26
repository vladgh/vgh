require 'aws-sdk'
require 'yaml'

require 'logger'

module VGH

  # Global config method
  # @return [Hash]
  def config
    $config ||= Configuration.new.config
  end


  # == Description:
  #
  # See {file:README.rdoc#Configuration Configuration Section} in the
  # README file.
  #
  #
  # == Usage:
  #
  #     config    = Configuration.new.config
  #     mysetting = config[:mysetting]
  #
  #
  class Configuration

    # Global configuration
    # @return [Hash] The configuration hash
    attr_reader :config

    # Parse the main configuration
    # @return [Hash]
    def initialize
      message.info "Loading configuration..."
      @config ||= validate(config_file)
      aws_config
    end

    # The global configuration directory
    # @return [String]
    def global_config_dir
      '/etc/vgh'
    end

    # The user configuration directory
    # @return [String]
    def user_config_dir
      File.expand_path('~/.vgh')
    end

    # IF specified, use the confdir specified in the command line options
    # @return [String]
    def confdir
      cli_confdir = cli[:confdir]
      global = global_config_dir
      if !cli_confdir.nil?
        return cli_confdir
      elsif File.directory?(global)
        return global
      else
        return user_config_dir
      end
    end

    # The main configuration file
    # @return [String]
    def config_file
      "#{confdir}/config.yml"
    end

    # Returns error if the configuration is not right
    # @return [Hash]
    def validate(path)
      if config_exists?(path) and config_correct?(path)
        parse(path)
      else
        puts load_error(path)
        exit 1
      end
    end

    # Checks if the configuration file exists
    # @return [Boolean]
    def config_exists?(path)
      File.exist?(path)
    end

    # Checks if the configuration is a valid YAML file
    # @return [Boolean]
    def config_correct?(path)
      parse(path).kind_of?(Hash)
    end

    # Returns a parsed configuration
    # @return [Hash]
    def parse(path)
      YAML.load(File.read(path))
    end

    # Configures AWS
    def aws_config
      AWS.config(config)
      AWS.config(aws_logging)
    end

    # Implements our own Logging class
    # @return [Hash]
    def aws_logging
      aws_logging ||= {
        :logger        => log,
        :log_formatter => AWS::Core::LogFormatter.colored
      }
    end

    # Returns the error message in case the configuration os not right
    def load_error(path)
      log.fatal("#{path} is either missing or formatted incorrectly!")
      load_error = <<END
#{path} is either missing or formatted incorrectly!

To run this script, you need to create a file named
#{path} with your configuration in the following format:

# Comment
:key: 'value'
:string: 'string value'
:integer: 123
:boolean: true/false
:array:
- '1st'
- '2nd'
:hash:
-
:sub_key: 'sub value'

END
      return load_error
    end

  end # class Configuration

end # module VGH

require 'vgh/cli'
require 'vgh/output'
require 'vgh/logging'

