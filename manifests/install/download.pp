# ex: syntax=puppet sw=4 ts=4 si et
class serf::install::download (
    $version       = undef,
    $install_path  = $::serf::install_path,
    $checksum_type = undef,
    $checksum      = undef,
) {
    hashicorp::download { 'serf':
        version       => $version,
        target_dir    => $install_path,
        before        => Anchor['serf::install'],
        notify        => Service['serf'],
    }
}
