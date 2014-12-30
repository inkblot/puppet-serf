require 'spec_helper'

describe 'serf::install::package' do
  let(:facts) { {
    :osfamily =>  'Debian',
    :operatingsystem => 'Debian',
    :lsbdistcodename => 'wheezy',
    :architecture => 'amd64',
    :test_config => 'package_install'
  } }

  it { should contain_package('serf').with({
    'ensure' => '_VERSION_',
    'name'   => '_PACKAGE_NAME_'
  }) }
  it { should contain_package('serf').that_notifies('Service[serf]') }
end
