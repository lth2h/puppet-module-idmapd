class { 'idmapd':
	ensure => 'running',
	idmapd_domain => 'foo.example.com',
	kerberos_realm => 'FOO.EXAMPLE.COM',
        rpcidmapd_opts => '-v',
}
