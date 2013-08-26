class idmapd::config (
  $ensure = 'running',
  $enable = 'true',
  $idmapd_domain = undef,
  $kerberos_realm = undef,
  $rpcidmapd_opts = '-v',
  ) {

  case $::operatingsystem {
    redhat, centos, fedora: {   
      concat { '/etc/idmapd.conf':
	warn    => true,
	mode    => '0644',
	owner	=> 'root',
	group	=> 'root',
      }
      concat::fragment { 'rhel-idmapd.conf.base':
	target  => '/etc/idmapd.conf',
	order   => 02,
	content => template('idmapd/redhat-idmapd.conf.erb'),
      }
      augeas {
        'rhel_sysconfig_nfs_set_idmapd':
          context => '/files/etc/sysconfig/nfs',
          changes => [ 'set RPCIDMAPDARGS "-v"', ];
      }
    }
    debian, ubuntu: {

  #       '/etc/idmapd.conf':
  #         context => '/files/etc/idmapd.conf/General',
  #         lens    => 'Puppet.lns',
  #         incl    => '/etc/idmapd.conf',
  #         changes => ["set Domain ${nfs::client::debian::nfs_v4_idmap_domain}"],
      
      concat { '/etc/idmapd.conf':
        warn    => true,
        mode    => '0644',
        owner	=> 'root',
        group	=> 'root',
      }
      concat::fragment { 'debian-idmapd.conf.base':
        target  => '/etc/idmapd.conf',
        order   => 02,
        content => template('idmapd/debian-idmapd.conf.erb'),
      }

      augeas {
        'debian_nfscommon_set_idmapd':
          context => '/files/etc/default/nfs-common',
          changes => [ 'set NEED_IDMAPD yes', ];
      }      
    }
  }
 }
