class couchdb::debian {
  include ::couchdb::base

  package {'libjs-jquery':
    ensure => present,
  }

  apt::source { 'apt_apache':
    architecture  => "${::architecture}",
    release       => "${::lsbdistcodename}",
    repos         => 'main',
    ensure        => 'present',
    comment       => 'PPA for latest stable official CouchDB packages by Apache CouchDB team',
    location      => 'http://ppa.launchpad.net/couchdb/stable/ubuntu',
    key           => {
      id          => '15866BAFD9BCC4F3C1E0DFC7D69548E1C17EAB57',
      server      => 'keyserver.ubuntu.com',
    },
    before        => Package['couchdb'],
  }

  $pin_defs = {
    packages => 'couchdb',
    ensure   => $couchdb::ensure ? {
      /(absent|purged|latest)/              => 'absent',
      default                               => 'present',
    },
    priority => 1001,
    version  => $couchdb::version ? {
      /(\d\.[xX]|\d\.\d\.[xX]|\d\.\d\.\d)/  => "${couchdb::version}*",
      default                               => '',
    },
    before   => Package['couchdb'],
  }
  $rm_pin = $couchdb::ensure != 'held' and $couchdb::version
  $pin_extra = $rm_pin ? {
    true    => { notify => Exec['unhold_couchdb'] },
    default => {},
  }
  create_resources(apt::pin, { 'pin_couchdb' => $pin_extra }, $pin_defs)

  if $rm_pin {
    # More info:
    # - http://www.astarix.co.uk/2014/02/easily-exclude-packages-apt-get-upgrades/
    # - https://docs.puppetlabs.com/puppet/latest/reference/upgrade_minor.html
    exec { 'unhold_couchdb':
      path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin'],
      logoutput   => 'on_failure',
      command     => 'apt-mark unhold couchdb',
      user        => 'root',
      before      => Package['couchdb'],
      require     => Apt::Pin['pin_couchdb'],
      refreshonly => true,
    }
  }

}
