require 'spec_helper'
describe 'maas' do
  let(:title) { 'maas' }
  let(:node) { 'maas.contoso.ltd' }
  let :facts do
    {
      id => 'root',
      kernel => 'Linux',
      osfamily => 'Debian',
      operatingsystems => 'Ubuntu',
    }
  end

  # this is the simplest test possible to make sure the Puppet code compiles
  it { is_expected.to compile }
  # same as above except it will test all the dependencies
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('apt') }
  # same again except it expects an error message
  # it { is_expected.to compile.and_raise_error(/error message/)
end
