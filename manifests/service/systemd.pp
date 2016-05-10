# ex: syntax=puppet sw=4 ts=4 si et
class serf::service::systemd (
    $install_path = $::serf::install_path,
    $config_dir   = $::serf::config_dir,
) {
    file { '/usr/lib/systemd/system/serf.service':
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('serf/systemd.service.erb'),
        require => Anchor['serf::install'],
        before  => Anchor['serf::config'],
        notify  => Service['serf'],
    }
}
