require 'aws-sdk'
require 'yaml'

require 'logger'

module VGH

  # Initialize the configuration parser
  def parse_config
    $config ||= Configuration.new
  end

  # Returns a hash containing the main settings
  def main_config
    $main_config ||= parse_config.main_config
  end

  # Returns a hash containing the AWS settings
  def aws_config
    $aws_config ||= parse_config.aws_config
  end

  # Returns a hash containing the app settings
  def app_config
    $app_config ||= parse_config.app_config
  end

  # Returns a single merged hash with all configurations
  def global_config
    $global_config ||= [main_config, aws_config, app_config].inject(:merge)
  end

  # Creates a global ec2 method (passing the specified region).
  # The default region is us-east-1, so we overwrite it here.
  def ec2
    region = aws_config[:region]
    if region
      $ec2 = AWS::EC2.new.regions[region]
    else
      $ec2 = AWS::EC2.new
    end
  end

  # == Description:
  #
  # See {file:README.rdoc#label-Configuration Configuration Section} in the
  # README file.
  #
  #
  # == Usage:
  #
  #     cfg         = Configuration.new
  #     main_config = cfg.main_config
  #     aws_config  = cfg.aws_config
  #     app_config  = cfg.app_config
  #
  #     pp main_config
  #     pp aws_config
  #     pp app_config
  #
  class Configuration

    # Main configuration
    attr_reader :main_config

    # AWS configuration
    attr_reader :aws_config

    # App specific configuration
    attr_reader :app_config

    # Set defaults
    def initialize
      @confdir = validate_config_dir('/etc/vgh')
      @main    = "#{@confdir}/config.yml"
      @aws     = "#{@confdir}/aws.config.yml"
      @app     = "#{@confdir}/#{app}.config.yml"
    end

    # IF specified, use the confdir specified in the command line options
    def validate_config_dir(default_confdir, cli = cli_confdir)
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

    # Returns a parsed configuration
    def parse(path)
      @parse = YAML.load(File.read(path))
    end

    # Checks if the configuration file exists
    def config_exists?(path)
      File.exist?(path)
    end

    # Checks if the configuration is a valid YAML file
    def config_correct?(path)
      parse(path).kind_of?(Hash)
    end

    # Parse the main configuration
    def main_config
      message.info "Loading main configuration..."
      validate(@main)
      parse(@main)
    end

    # Parse the AWS configuration
    def aws_config
      message.info "Loading AWS configuration..."
      validate(@aws)
      @aws_config = parse(@aws)
      load_aws
      return @aws_config
    end

    # Overwrite the AWS Core configuration
    def load_aws
      AWS.config(@aws_config)
      AWS.config({
        :logger        => log,
        :log_formatter => AWS::Core::LogFormatter.colored,
        :max_retries   => 2
      })
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
    end

  end # class Configuration

end # module VGH

require 'vgh/cli'
require 'vgh/output'
require 'vgh/logging'

