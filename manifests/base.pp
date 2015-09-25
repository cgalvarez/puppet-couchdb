class couchdb::base {

  package {'couchdb':
    ensure => $couchdb::ensure,
  }

  service {'couchdb':
    ensure    => running,
    hasstatus => true,
    enable    => true,
    require   => Package['couchdb'],
  }

}
