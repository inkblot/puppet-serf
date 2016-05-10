# ex: syntax=puppet sw=4 ts=4 si et
class serf (
    $node_name      = undef,
    $protocol       = undef,
    $advertise      = undef,
    $bind           = undef,
    $encrypt_key    = undef,
    $event_handlers = undef,
    $tags           = undef,
    $start_join     = undef,
    $profile        = undef,
    $discover       = undef,
    $rpc_address    = undef,
    $rpc_port       = undef,
    $rpc_auth       = undef,
    $log_level      = undef,

    $install_class  = undef,

    $config_dir     = undef,
    $config_owner   = undef,
    $config_group   = undef,

    $service_class  = undef,

    $install_path   = undef,
) {

    class { $install_class: }

    anchor { 'serf::install': }

    File {
        ensure  => present,
        owner   => $config_owner,
        group   => $config_group,
        mode    => '0640',
    }

    file { $config_dir:
        ensure  => directory,
        mode    => '0755',
        require => Anchor['serf::install'],
        before  => Anchor['serf::config'],
        notify  => Service['serf'],
    }

    file { 'serf.conf':
        path    => "${config_dir}/serf.conf",
        content => template('serf/serf.conf.erb'),
        require => Anchor['serf::install'],
        before  => Anchor['serf::config'],
        notify  => Service['serf'],
    }

    if $service_class {
        class { $service_class: }
    }

    anchor { 'serf::config': }

    service { 'serf':
        ensure  => running,
        enable  => true,
        require => Anchor['serf::install', 'serf::config']
    }
}
