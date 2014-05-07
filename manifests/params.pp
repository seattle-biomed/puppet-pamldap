# Defaults for pamldap
class pamldap::params {
  $directory_type             = 'openldap'
  $timelimit                  = '30'
  $bind_timelimit             = '5'
  $bind_policy                = 'hard'
  $idle_timelimit             = '3600'
  $pam_login_attribute        = 'uid'
  $pam_member_attribute       = 'memberUid'
  $pam_filter                 = 'objectclass=posixAccount'
  $pam_min_uid                = '1000'
  $nss_reconnect_tries        = '2'
  $nss_reconnect_sleeptime    = '1'
  $nss_reconnect_maxsleeptime = '4'
  $nss_reconnect_maxconntries = '2'
  $nss_initgroups_ignoreusers = 'root,daemon,adm,nobody,mysql,avahi,haldaemon,apache,pgsql'

  $ldap_conf_file = $::osfamily ? {
    'Debian'  => '/etc/ldap/ldap.conf',
    'RedHat'  => '/etc/ldap.conf',
    default   => '/etc/ldap.conf',
  }
  $service_name = $::osfamily ? {
    'Debian'  => 'sssd',
    'RedHat'  => 'sssd',
    default   => 'sssd',
  }
  $package_names = $::osfamily ? {
    'Debian'  => ['sssd', 'libnss-sss', 'libpam-sss', 'ldap-utils'],
    'RedHat'  => ['sssd', 'sssd-client', 'openldap-clients'],
    default   => ['sssd']
  }

}
