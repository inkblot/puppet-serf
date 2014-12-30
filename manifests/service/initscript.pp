# ex: syntax=puppet sw=4 ts=4 si et
class serf::service::initscript (
    $install_path = $::serf::install_path,
    $config_dir   = $::serf::config_dir,
) {
    file { '/etc/init.d/serf':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('serf/initscript.erb'),
        require => Anchor['serf::install'],
        before  => Anchor['serf::config'],
        notify  => Service['serf'],
    }
}
