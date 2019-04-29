require 'spec_helper'

describe 'maas::superuser', type: :define do
  let(:title) { 'namevar' }
  let(:pre_condition) { 'include ::maas' }

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end

