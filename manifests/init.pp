# directory_type set some options required for OpenLDAP or Active Directory
# - 'openldap'
# - 'ad'

class pamldap (
  $base_dn        = hiera('pamldap::base_dn'),
  $uris           = hiera('pamldap::uris'),
  $directory_type = hiera('pamldap::directory_type'),
  $bind_dn        = hiera('pamldap::bind_dn'),
  $bind_pw        = hiera('pamldap::bind_pw'),
  $pam_filter     = hiera('pamldap::pam_filter')
) inherits pamldap::params {
  class { 'pamldap::config':
    base_dn         => $base_dn,
    uris            => $uris,
    directory_type  => $directory_type,
    bind_dn         => $bind_dn,
    bind_pw         => $bind_pw,
    pam_filter      => $pam_filter
  }
  include pamldap::install
  include pamldap::service
}
