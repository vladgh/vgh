require 'helpers/spec'
require 'vgh'
require 'vgh/configuration'

describe VGH::Configuration do

  let(:configuration) {VGH::Configuration.allocate}
  let(:cli_confdir) {'/tmp'}
  let(:config_hash) {"---
:key1: 'value1'
:key2: 'value2'"}

  before(:each) do
    configuration.stub(:cli).and_return({:confdir => nil})
  end

  it 'Should return the default config directory' do
    configuration.global_config_dir.should eq('/etc/vgh')
  end

  it 'Should return the user config directory' do
    configuration.user_config_dir =~ /.*\.vgh$/
  end

  it 'Should return a config directory from cli or return users directory' do
    configuration.confdir.should =~ /.*\.vgh/
    configuration.stub(:cli).and_return({:confdir => cli_confdir})
    configuration.confdir.should eq(cli_confdir)
  end

  it 'Should return the main configuration file' do
    configuration.config_file.should =~ /.*\.vgh\/config\.yml/
  end

  it 'Should initialize clean' do
    cfg = VGH::Configuration
    [:message, :cli, :log, :aws_config].each {|s|
      cfg.any_instance.stub(s).and_return(Dummy.new)
    }
    cfg.any_instance.stub(:validate).and_return(config_hash)
    subject.config.should eq(config_hash)
  end

end
