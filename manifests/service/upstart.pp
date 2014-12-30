# ex: syntax=puppet sw=4 ts=4 si et
class serf::service::upstart (
    $install_path = $::serf::install_path,
    $config_dir   = $::serf::config_dir,
) {
    file { '/etc/init/serf.conf':
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('serf/upstart.conf.erb'),
        require => Anchor['serf::install'],
        before  => Anchor['serf::config'],
        notify  => Service['serf'],
    }
}
