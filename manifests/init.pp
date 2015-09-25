class couchdb (
  $ensure = $couchdb::params::ensure,
  $version = $couchdb::params::version,
  $bind_address = $couchdb::params::bind_address,
  $port = $couchdb::params::port,
  $backupdir = $couchdb::params::backupdir,
) inherits ::couchdb::params {

  validate_string($ensure)
  validate_string($version)

  case $::osfamily {
    'Debian': { include ::couchdb::debian }
    'RedHat': { include ::couchdb::redhat }
    default:  { fail "couchdb not available for ${::operatingsystem}" }
  }
}
