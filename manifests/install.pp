# install package and config common to client and host
class aptdater::install {

  ensure_packages(['apt-dater-host'])

  group { $aptdater::username:
    ensure => present,
    system => true,
  } ->
  user { $aptdater::username:
    ensure         => present,
    system         => true,
    comment        => 'centrally managed updates',
    gid            => $aptdater::username,
    home           => $aptdater::homedir,
    managehome     => true,
    purge_ssh_keys => true,
  }
}