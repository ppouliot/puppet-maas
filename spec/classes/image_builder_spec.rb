require 'spec_helper'
describe 'maas::image_builder' do
  let(:title) { 'image_builder' }
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
        ['bzr', 'make', 'python-tempita','python-yaml','python-virtualenv'].each do |package|
          it { is_expected.to contain_package(package).with_ensure('latest') }
        end
        it {
          is_expected.to contain_vcsrepo('/opt/maas-image-builder')
            .with_ensure('latest')
            .with_provider('bzr')
            .with_source('lp:~ltrager/maas-image-builder/update_ks')
        }
        it {
          is_expected.to contain_exec('image-builder_make_install-deps')
            .with_command('/usr/bin/make install-dependencies && /usr/bin/make')
            .with_cwd('/opt/maas-image-builder')
            .with_onlyif('/usr/bin/test ! -f /opt/maas-image-builder/bin/maas-image-builder')
            .with_creates('/opt/maas-image-builder/bin/maas-image-builder')
            .with_logoutput(true)
            .with_timeout(0)
        }
        it { is_expected.to contain_class('maas::image_builder') }
        it { is_expected.not_to raise_error }
      end
    end
  end
end
