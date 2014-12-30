require 'spec_helper'

describe 'serf::install::download' do
  it { should contain_exec('download_serf').with({
    'creates' => '/spec/_INSTALL_PATH_/serf-_VERSION_'
  }) }

  it { should contain_file('serf-_VERSION_') }
  it { should contain_file('serf-_VERSION_').that_notifies('Service[serf]') }

  it { should contain_file('serf').with({
    'path' => '/spec/_INSTALL_PATH_/serf',
    'target' => '/spec/_INSTALL_PATH_/serf-_VERSION_'
  }) }
  it { should contain_file('serf').that_notifies('Service[serf]') }
end
