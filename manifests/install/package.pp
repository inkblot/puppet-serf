# ex: syntax=puppet sw=4 ts=4 si et
class serf::install::package (
    $version      = undef,
    $package_name = undef,
) {
    package { 'serf':
        ensure => $version,
        name   => $package_name,
        before => Anchor['serf::install'],
        notify => Service['serf'],
    }
}
