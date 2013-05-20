class pamldap::service (
  $service_name = $pamldap::params::service_name
) inherits pamldap::params {
  service { $service_name:
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => Class['pamldap::config'],
  }
}
