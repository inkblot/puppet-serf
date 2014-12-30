require 'spec_helper'

describe 'serf' do
  it { should compile }
  it { should compile.with_all_deps }

  context 'using defaults' do
    it { should contain_class('serf::install::download') }

    it { should contain_file('serf.conf').with({
      'path' => '/spec/_CONFIG_DIR_/serf.conf',
      'owner' => '_CONFIG_OWNER_',
      'group' => '_CONFIG_GROUP_'
    }) }
    it { should contain_file('serf.conf').that_notifies('Service[serf]') }

    it { should contain_class('serf::service::initscript') }

    it { should contain_service('serf') }
  end

  context 'using package install' do
    let(:facts) { { :test_config => 'package_install' } }

    it { should contain_class('serf::install::package') }
  end

  context 'using upstart service' do
    let(:facts) { {
      :operatingsystem => 'Ubuntu',
      :lsbdistcodename => 'trusty'
    } }

    it { should contain_class('serf::service::upstart') }
  end
end
