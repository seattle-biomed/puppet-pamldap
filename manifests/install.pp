class pamldap::install (
  $package_names = $pamldap::params::package_names
) inherits pamldap::params {

  # Function from stdlib
  ensure_packages($package_names)

}
