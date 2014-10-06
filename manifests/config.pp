class idmapd::config (
  $ensure = 'running',
  $enable = 'true',
  $idmapd_domain = undef,
  $kerberos_realm = undef,
  $rpcidmapd_opts = '-v',
  $idmapd_method = 'static',
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
      # Augeas['rhel_sysconfig_nfs_set_idmapd'] gives a warning because another file that is parsed by the same lens is broken.  See https://tickets.puppetlabs.com/browse/PUP-1158 It doesn't stop the catalog and the correct value does get set.  Possible workaround is to create a new lens that only parses this file.
      augeas {
        'rhel_sysconfig_nfs_set_idmapd':
          context => '/files/etc/sysconfig/nfs',
          changes => [ 'set RPCIDMAPDARGS "-v"', ];
      }  
      file {"/usr/share/augeas/lenses/dist/idmapd.aug":
        ensure => "present",
        source => "puppet:///modules/idmapd/usr/share/augeas/lenses/dist/idmapd.aug",
        before => Concat["/etc/idmapd.conf"], 
      }
      augeas {'idmapd_set_method':
        context => '/files/etc/idmapd.conf/Translation',
        changes => "set Method ${idmapd_method}",
        require => [Package["augeas"],Concat["/etc/idmapd.conf"],File["/usr/share/augeas/lenses/dist/idmapd.aug"],],
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
