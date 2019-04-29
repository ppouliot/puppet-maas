require 'spec_helper'
describe 'maas' do
  let(:title) { 'maas' }
  let(:node) { 'maas.contoso.ltd' }
  let(:facts) do
    {
      operatingsystem: 'Ubuntu',
      operatingsystemrelease: '16.04',
      ipaddress: '192.168.0.54',
      is_virtual: false,
    }
  end

  on_supported_os.reject { |_, f| f[:os]['family'] == 'Solaris' }.each do |os, f|
    context "on #{os}" do
      let(:facts) do
        f.merge(super())
      end

      context 'with default params' do
        # this is the simplest test possible to make sure the Puppet code compiles
        it { is_expected.to compile }
        # same as above except it will test all the dependencies
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('maas::install') }
        it { is_expected.to contain_class('maas::config') }
        it { is_expected.to contain_class('maas::install').that_comes_before('Class[maas::config]') }
        it { is_expected.to contain_file('/etc/maas/.puppet/').with_ensure('directory').that_requires('Package[maas]') }
        ['maas', 'maas-dhcp', 'maas-dns'].each do |package|
          it { is_expected.to contain_package(package).with_ensure('present') }
        end
        it {
          is_expected.to contain_maas__superuser('admin').with(
            password: 'maasadmin',
            email: 'admin@maas.contoso.ltd',
            # sshkey: '~/.ssh/id_rsa',
            # ssh_import: true,
          )
        }
        it { is_expected.to contain_exec('maas-import-boot-images-run-by-user-admin') }
        it { is_expected.to contain_exec('maas-boot-resources-import-admin') }
        it { is_expected.to contain_exec('maas-nodes-accept-all-admin') }

        it { is_expected.to contain_class('maas') }
        it { is_expected.not_to raise_error }
      end
    end
    context 'with class specific parameters' do
      let(:facts) do
        f.merge(super())
      end

      describe 'maas_release_ppa_stable' do
        let(:params) { { maas_release_ppa: 'stable' } }

        it { is_expected.to contain_apt__ppa('ppa:maas/stable') }
      end
      describe 'maas_release_ppa_next' do
        let(:params) { { maas_release_ppa: 'next' } }

        it { is_expected.to contain_class('apt') }
        it { is_expected.to contain_apt__ppa('ppa:maas/next') }
      end
      describe 'hyperv_power_adapter' do
        let(:params) { { hyperv_power_adapter: true } }

        it { is_expected.to contain_class('maas::hyperv_power_adapter') }
      end
      describe 'default_superuser_sshkey' do
        let(:params) { { default_superuser_sshkey: '~/.ssh/id_rsa' } }

        it { is_expected.to contain_maas__superuser('admin').with_sshkey('~/.ssh/id_rsa') }
      end
    end
  end
end
