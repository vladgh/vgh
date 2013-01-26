require 'rspec'
require 'aws-sdk'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

class Dummy
  def method_missing(name, *args, &block)
    #puts "Tried to handle unknown method %s" % name # name is a symbol
    #unless args.empty?
      #puts "It had arguments: %p" % [args]
    #end
  end
end

require "#{File.dirname(__FILE__)}/aws_mock.rb"

