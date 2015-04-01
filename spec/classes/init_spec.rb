require 'spec_helper'
describe 'maas' do

  context 'with defaults for all parameters' do
    it { should contain_class('maas') }
  end
end
