# puppet-aptdater

This module will install [apt-dater](https://github.com/DE-IBH/apt-dater), an
ncurses-frontend to apt on multiple hosts, backed by SSH.

## Setup

To set things up, you'll have to create a private/public key pair for SSH access
to the nodes managed by `apt-dater`. It's wise to also create a dedicated user
on each host and (at least somewhat) limit what the user can do with `sudo` by
restricting usable commands to `apt-get` and `aptitude` (for dependency mgmt).

### What `puppet-aptdater` affects

* one host holds a SSH private key to log in to all configured clients
* all clients hold the public corresponding SSH pubkey
* client hosts have users with limited sudo access to `apt-get` for running
  updates and regular access to everything else
* on the central node, there's an ncurses frontend to view and manage available
  updates on each host.

### How to set up a central and several client nodes

* Assign the `aptdater` class to each node
* set the `$ishost` attribute to `true` for one of them

Additional requirements:
* Create a private key, install it to `/etc/apt-dater/ssh/id_rsa` and distribute
  the corresponding public key to the `apt-dater` user on each client node.

```puppet
node central.example.com {

  class { 'aptdater':
    ishost => true,
  }

  file { 'apt-dater-private-key':
    ensure => 'present',
    path   => '/etc/apt-dater/ssh/id_rsa',
    owner  => 'apt-dater',
    group  => 'apt-dater',
    mode   => '0600',
    content => file('aptdater/obviouslyyouneedtocreateaprivatekeyyourself')
  }
}

node client1.example.com {

  include ::aptdater

  ssh_authorized_key { "apt-dater-${::facts['fqdn']}":
    ensure => 'present',
    user   => 'apt-dater',
    type   => 'ssh-rsa',
    key    => file('aptdater/alsoheregoesthepublickeypath'),
    target => ['from="central.example.com"]
  }
}
```

## Usage

Having installed `apt-dater` on all hosts, just run the frontend `apt-dater`
on your central node and manage updates from there.

## Reference

There's only one class:

### Class `aptdater`

* `ishost` (Boolean): Install this host as a management node
* `username` (String) **Default**: `apt-dater`: The username that should hold `sudo` rights on the client nodes. If you change this, make sure to change `apt-dater`'s app config, too.
* `homedir` (String) **Default**: `/home/apt-dater`: Used only for holding the pubkey

## Limitations

* This module currently just installs pretty vanilla settings for `apt-dater`,
  if you want a lot of customization, feel free to add it.

## Links

* [Github project](https://github.com/fheinle/puppet-aptdater')
* [Github issues](https://github.com/fheinle/puppet-aptdater/issues')
