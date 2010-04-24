Puppet htpasswd type
====================

This type provides a htpasswd type for Puppet.

Copyright - James Turnbull <james@lovedthanlost.net>

License: GPLv3

Requirements
------------

* webrick

Usage
-----

    htpasswd { 'user':
      file     => '/path/to/htpassword/file',
      password => 'password',
      ensure => present,
    }
