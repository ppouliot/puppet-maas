require 'spec_helper'
describe 'maas' do
  let(:facts) do
    {
      operatingsystem: 'Ubuntu',
      operatingsystemrelease: '14.04',
      ipaddress: '192.168.0.54',
    }
  end

  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('maas') }
  end
end
