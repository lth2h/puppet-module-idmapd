class idmapd::service {

  case $::operatingsystem {
    centos, rhel: {
      service { 'rpcidmapd':
        ensure    => $idmapd::ensure,
        enable    => $idmapd::enable,
        hasstatus => true,
        subscribe => File['/etc/idmapd.conf'],
      }
    }
    fedora: { # 17+
      service { nfs-idmap-service:
        provider => "systemd",
        name => "nfs-idmap.service",
        ensure => $idmapd::ensure,
        enable => $idmapd::enable,
      }
    }
    debian, ubuntu: {
      service { 'idmapd':
        ensure    => $idmapd::ensure,
        enable    => $idmapd::enable,
        hasstatus => true,
        subscribe => File['/etc/idmapd.conf'],
      }
    }
  }
}
