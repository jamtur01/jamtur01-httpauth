Puppet HTTP Authentication type
===============================

This provides a HTTP Authentication type for Puppet that support Basic and Digest authentication.

Copyright - James Turnbull <james@lovedthanlost.net>

License: GPLv3

Requirements
------------

* webrick

Usage
-----

    httpauth { 'user':
      file     => '/path/to/password/file',
      password => 'password',
      realm => 'realm',
      mechanism => basic,
      ensure => present,
    }
