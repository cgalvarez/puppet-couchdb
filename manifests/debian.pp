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

  apt::pin { 'pin_couchdb':
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

}
