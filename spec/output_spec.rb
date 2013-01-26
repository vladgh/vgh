require 'helpers/spec'
require 'vgh'
require 'vgh/cli'
require 'vgh/apps'
require 'vgh/output'
require 'vgh/logging'
require 'vgh/configuration'

describe VGH::Output do

  it 'Should write STDOUT messages' do
    subject.should_receive(:stdout).with('RSpec Test')
    subject.stdout('RSpec Test')
  end

  it 'Should write DEBUG messages' do
    subject.should_receive(:debug).with('RSpec Test')
    subject.debug('RSpec Test')
  end

  it 'Should write INFO messages' do
    subject.should_receive(:info).with('RSpec Test')
    subject.info('RSpec Test')
  end

  it 'Should write WARN messages' do
    subject.should_receive(:warn).with('RSpec Test')
    subject.warn('RSpec Test')
  end

  it 'Should write ERROR messages' do
    subject.should_receive(:error).with('RSpec Test')
    subject.error('RSpec Test')
  end

  it 'Should write FATAL messages' do
    subject.should_receive(:fatal).with('RSpec Test')
    subject.fatal('RSpec Test')
  end

end
