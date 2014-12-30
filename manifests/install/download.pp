# ex: syntax=puppet sw=4 ts=4 si et
class serf::install::download (
    $version       = undef,
    $install_path  = $::serf::install_path,
    $unzip_package = undef,
) {

    # mitchellh refers to anything 64bit as amd64, anything 32bit as 386, and
    # all arm variations as arm.
    $_architecture = $::architecture ? {
        'x86_64' => 'amd64',
        'i386'   => '386',
        'i486'   => '386',
        'armel'  => 'arm',
        'armhf'  => 'arm',
        'armv6l' => 'arm',
        default  => $::architecture,
    }

    # There are probably variations that need to be accounted for
    $_os = downcase($::kernel)

    if ! defined(Package['unzip']) {
        package { 'unzip':
            ensure => present,
            name   => $unzip_package,
        }
    }

    $url = "https://dl.bintray.com/mitchellh/serf/${version}_${_os}_${_architecture}.zip"

    exec { 'download_serf':
        command => "wget ${url} -qO - | funzip > ${install_path}/serf-${version}",
        path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        creates => "${install_path}/serf-${version}",
        before  => File["serf-${version}"],
    }

    File {
        ensure => present,
        owner  => 'root',
        group  => 'root',
        notify => Service['serf'],
    }

    file { "serf-${version}":
        path => "${install_path}/serf-${version}",
        mode => '0755',
    }

    file { 'serf':
        ensure  => link,
        path    => "${install_path}/serf",
        target  => "${install_path}/serf-${version}",
        require => File["serf-${version}"],
        before  => Anchor['serf::install'],
        notify  => Service['serf'],
    }
}
