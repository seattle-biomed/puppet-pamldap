class pamldap::config (
  $base_dn                    = undef,
  $uris                       = undef,
  $bind_dn                    = undef,
  $bind_pw                    = undef,
  $krb5_realm                 = undef,
  $krb5_servers               = [],
  $directory_type             = $pamldap::params::directory_type,
  $ldap_conf_file             = $pamldap::params::ldap_conf_file,
  $timelimit                  = $pamldap::params::timelimit,
  $bind_timelimit             = $pamldap::params::bind_timelimit,
  $bind_policy                = $pamldap::params::bind_policy,
  $idle_timelimit             = $pamldap::params::idle_timelimit,
  $nss_reconnect_tries        = $pamldap::params::nss_reconnect_tries,
  $nss_reconnect_sleeptime    = $pamldap::params::nss_reconnect_sleeptime,
  $nss_reconnect_maxsleeptime = $pamldap::params::nss_reconnect_maxsleeptime,
  $nss_reconnect_maxconntries = $pamldap::params::nss_reconnect_maxconntries,
  $pam_login_attribute        = $pamldap::params::pam_login_attribute,
  $pam_member_attribute       = $pamldap::params::pam_member_attribute,
  $pam_filter                 = $pamldap::params::pam_filter,
  $pam_min_uid                = $pamldap::params::pam_min_uid,
  $nss_initgroups_ignoreusers = $pamldap::params::nss_initgroups_ignoreusers,
  $extra_ldap_options         = [],
  $extra_sss_options          = []
) inherits pamldap::params {
  $uris_space = join($uris, ' ')
  $uris_comma = join($uris, ',')

  # defaults
  File {
    ensure  => present,
    owner => 'root',
    group => 'root',
    mode  => '0444',
  }

  file { '/etc/pam.d/system-auth-ac':
    content => template('pamldap/system-auth.erb'),
    require => Class['pamldap::install'],
    notify  => Class['pamldap::service'],
  }
  file { '/etc/pam.d/system-auth':
    target  => 'system-auth-ac',
    require => File['/etc/pam.d/system-auth-ac'],
  }
  file { '/etc/pam.d/password-auth-ac':
    content => template('pamldap/password-auth.erb'),
    require => Class['pamldap::install'],
    notify  => Class['pamldap::service'],
  }
  file { '/etc/pam.d/password-auth':
    target  => 'password-auth-ac',
    require => File['/etc/pam.d/password-auth-ac'],
  }
  file { '/etc/nsswitch.conf':
    content => template('pamldap/nsswitch.conf.erb'),
    require => Class['pamldap::install'],
    notify  => Class['pamldap::service'],
  }
  file { '/etc/sssd/sssd.conf':
    mode    => '0600',
    content => template('pamldap/sssd.conf.erb'),
    require => Class['pamldap::install'],
    notify  => Class['pamldap::service'],
  }

  file { $ldap_conf_file:
    content => template('pamldap/ldap.conf.erb'),
    require => Class['pamldap::install'],
    notify  => Class['pamldap::service'],
  }

  case $::osfamily {
    'RedHat': {
      file { [ '/etc/pam_ldap.conf', '/etc/openldap/ldap.conf' ]:
        ensure  => link,
        target  => '/etc/ldap.conf',
        require => File['/etc/ldap.conf'],
        notify  => Class['pamldap::service'],
      }
    }
  }

  if $directory_type == 'ad' {
    file { '/etc/krb5.conf':
      content => template('pamldap/krb5.conf.erb'),
      require => Class['pamldap::install'],
      notify  => Class['pamldap::service'],
    }
  }
}
