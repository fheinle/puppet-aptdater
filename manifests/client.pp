# configure this node as an apt-dater client
class aptdater::client {
  sudo::conf { 'apt-dater':
    ensure   => present,
    priority => 20,
    content  => "${aptdater::username} ALL=NOPASSWD: /usr/bin/aptitude, /usr/bin/apt-get",
  }

  @@concat::fragment { "aptdater::host::${facts['fqdn']}":
    target  => 'apt-dater-hosts',
    order   => '20',
    content => "<host name=\"${facts['fqdn']}\" />",
    tag     => 'aptdater'
  }
}