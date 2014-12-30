require 'spec_helper'

describe 'serf::service::upstart' do
  it { should contain_file('/etc/init/serf.conf').with({
    'owner' => 'root',
    'group' => 'root',
    'mode' => '0644',
    'content' => /start on runlevel/
  }) }
  it { should contain_file('/etc/init/serf.conf').that_comes_before('Anchor[serf::config]') }
end
