puppet-module-idmapd
=========
v0.1 - 26-Aug-2013 - Initial release.


Manage rpc.idmapd on Linux NFSv4 clients and servers.


Tested on
-

- Ubuntu 12.04 LTS, 13.04 (should work on Debian)
- CentOS/RHEL 6
- Fedora 17, 18


Usage
-
```
class { 'idmapd':
     ensure => 'running',
     enable => 'true',
     idmapd_domain => 'ad.example.com',
     kerberos_realm => 'AD.EXAMPLE.COM',
     rpcidmapd_opts => '-v',
 }
 ```