require 'spec_helper'

describe 'Maas::Superuser', type: :define do
  let(:title) { 'namevar' }
  let(:pre_condition) { 'include ::maas' }

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do 
        {
          password: 'maasadmin',
          email: 'admin@maas.contoso.ltd',
        }
      end

      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_maas__superuser('namevar') }
      it { is_expected.not_to raise_error }

    end
  end
end
