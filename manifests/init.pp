class idmapd (
  $ensure,
  $enable,
  $idmapd_domain,
  $kerberos_realm,
  $rpcidmapd_opts,
) inherits idmapd::params {

  anchor { 'idmapd::begin': }
  anchor { 'idmapd::end': }

# formerly puppet::end -- don't know why
Anchor[ 'idmapd::begin' ] -> class { 'idmapd::install': } -> Class['idmapd::config'] ~> class {'idmapd::service': } -> Anchor[ 'idmapd::end' ]
  
  class { 'idmapd::config':
    ensure		=> $ensure,
    enable              => $enable,
    idmapd_domain	=> $idmapd_domain,
    kerberos_realm	=> $kerberos_realm,
    rpcidmapd_opts      => $rpcidmapd_opts,
  }
}
