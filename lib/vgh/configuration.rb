require 'aws-sdk'
require 'yaml'

require 'logger'

module VGH

  # Initialize the configuration parser
  # @return [Hash]
  def parse_config
    $parse_config ||= Configuration.new
  end

  # Returns a hash containing the main settings
  # @return [Hash]
  def config
    $config ||= parse_config.main_config
  end

  # Returns a hash containing the app settings
  # @return [Hash]
  def app_config
    $app_config ||= parse_config.app_config
  end

  # Returns a single merged hash with all configurations
  # @return [Hash]
  def global_config
    $global_config ||= [config, app_config].inject(:merge)
  end

  # Creates a global ec2 method (passing the specified region).
  # The default region is us-east-1, so we overwrite it here.
  def ec2
    region = config[:region]
    if region
      $ec2 = AWS::EC2.new.regions[region]
    else
      $ec2 = AWS::EC2.new
    end
  end

  # == Description:
  #
  # See {file:README.rdoc#Configuration Configuration Section} in the
  # README file.
  #
  #
  # == Usage:
  #
  #     parse       = Configuration.new
  #     main_config = parse.main_config
  #     app_config  = parse.app_config
  #
  #     pp main_config
  #     pp app_config
  #
  class Configuration

    # Main configuration
    attr_reader :main_config

    # App specific configuration
    attr_reader :app_config

    # Set defaults
    def initialize
      @confdir = validate_config_dir('/etc/vgh')
      @main    = "#{@confdir}/config.yml"
      @app     = "#{@confdir}/#{app}.config.yml"
    end

    # IF specified, use the confdir specified in the command line options
    def validate_config_dir(default_confdir)
      cli = cli_confdir
      if cli.nil?
        return default_confdir
      else
        return cli
      end
    end

    # Returns error if the configuration is not right
    def validate(cfg)
      unless config_exists?(cfg) and config_correct?(cfg)
        puts load_error(cfg)
        exit 1
      end
    end

    # Checks if the configuration file exists
    def config_exists?(path)
      File.exist?(path)
    end

    # Checks if the configuration is a valid YAML file
    def config_correct?(path)
      parse(path).kind_of?(Hash)
    end

    # Returns a parsed configuration
    def parse(path)
      @parse = YAML.load(File.read(path))
    end

    # Parse the main configuration
    def main_config
      message.info "Loading main configuration..."
      validate(@main)
      @main_config = parse(@main)
      AWS.config({
        :access_key_id     => @main_config[:access_key_id],
        :secret_access_key => @main_config[:secret_access_key],
        :logger            => log,
        :log_formatter     => AWS::Core::LogFormatter.colored,
        :max_retries       => 2
      })
      return @main_config
    end

    # Parse app specific configuration
    def app_config
      message.info "Loading #{app} configuration..."
      validate(@app)
      @app_config = parse(@app)
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

