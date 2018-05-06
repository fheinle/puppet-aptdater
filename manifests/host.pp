# install and configure this node as apt-dater host
class aptdater::host {

  ensure_packages(['apt-dater', 'imvirt', 'needrestart'])

  file { 'apt-dater-config':
    ensure => 'present',
    path => '/etc/apt-dater/apt-dater.xml',
    owner => $aptdater::username,
    group => $aptdater::username,
    mode => "0640",
    content => file('aptdater/apt-dater.xml')
  }

  concat { 'apt-dater-hosts':
    ensure => 'present',
    path   => '/etc/apt-dater/hosts.xml',
    owner  => $aptdater::username,
    group  => $aptdater::username,
    mode   => '0640',
    order  => 'numeric',
  }

  concat::fragment { 'apt-dater-dtd':
    target => 'apt-dater-hosts',
    order => "05",
    content => '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE hosts SYSTEM "file://usr/share/xml/schema/apt-dater/hosts.dtd">'
  }

  concat::fragment { 'apt-dater-hosts-head':
    target => 'apt-dater-hosts',
    order => '10',
    content => "<hosts><group name=\"puppet_managed\" ssh-user=\"${aptdater::username}\">",
  }

  Concat::Fragment <<| tag == 'aptdater' |>>

  concat::fragment { 'apt-dater-hosts-foot':
    target => 'apt-dater-hosts',
    order => '30',
    content => '</group></hosts>'
  }
}