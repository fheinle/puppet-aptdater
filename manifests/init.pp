# install and configure apt-dater to centrally manage apt updates
class aptdater (
  Boolean $ishost,
  Boolean $isclient,
  String  $username    = 'apt-dater',
  String  $homedir     = "/home/${username}",
) {

  if !$isclient and !$ishost {
    fail("Node ${::facts['fqdn']} needs to be either host or client")
  }

  include aptdater::install

  if $ishost {
    include aptdater::host
  } else {
    include aptdater::client
  }
}

