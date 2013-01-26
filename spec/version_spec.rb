require 'helpers/spec'
require 'vgh/version'

describe VGH do

  it 'Should return a semantic version number' do
    extend VGH
    version.should =~ /\d+\.\d+\.\d+/
  end

end
