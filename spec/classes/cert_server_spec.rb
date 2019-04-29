require 'spec_helper'
describe 'maas::cert_server' do
  let(:title) { 'maas-cert-server' }
  let(:pre_condition) { 'include ::maas' }
  let(:node) { 'maas.contoso.ltd' }
  let(:facts) do
    {
      operatingsystem: 'Ubuntu',
      operatingsystemrelease: '16.04',
      ipaddress: '192.168.0.54',
      is_virtual: false,
    }
  end

  let(:params) do
    {
      ensure: 'present',
    }
  end

  on_supported_os.reject { |_, f| f[:os]['family'] == 'Solaris' }.each do |os, f|
    context "on #{os}" do
      let(:facts) do
        f.merge(super())
      end

      context 'with default params' do
        it { is_expected.to compile }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('apt') }
        it { is_expected.to contain_apt__ppa('ppa:hardware-certification/public') }
        it { is_expected.to contain_package('maas-cert-server').that_requires('Class[maas]').that_requires('Class[apt::update]') }
        it { is_expected.not_to raise_error }
      end
    end
  end
end
