# ex: syntax=puppet sw=4 ts=4 si et
class serf::service::initscript (
    $install_path = $::serf::install_path,
    $config_dir   = $::serf::config_dir,
) {
  case $::osfamily {
    'Debian': { $template = 'serf/initscript.erb' }
    'RedHat': { $template = 'serf/sysvinit.erb' }
  }
    file { '/etc/init.d/serf':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template($template),
        require => Anchor['serf::install'],
        before  => Anchor['serf::config'],
        notify  => Service['serf'],
    }
}
