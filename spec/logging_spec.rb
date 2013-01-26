require 'helpers/spec'
require 'vgh'
require 'vgh/logging'

describe VGH::Logging do

  it 'Should write STDOUT messages' do
    subject.log.should_receive(:stdout).with('RSpec Test')
    subject.log.stdout('RSpec Test')
  end

  it 'Should write DEBUG messages' do
    subject.log.should_receive(:debug).with('RSpec Test')
    subject.log.debug('RSpec Test')
  end

  it 'Should write INFO messages' do
    subject.log.should_receive(:info).with('RSpec Test')
    subject.log.info('RSpec Test')
  end

  it 'Should write WARN messages' do
    subject.log.should_receive(:warn).with('RSpec Test')
    subject.log.warn('RSpec Test')
  end

  it 'Should write ERROR messages' do
    subject.log.should_receive(:error).with('RSpec Test')
    subject.log.error('RSpec Test')
  end

  it 'Should write FATAL messages' do
    subject.log.should_receive(:fatal).with('RSpec Test')
    subject.log.fatal('RSpec Test')
  end
end
