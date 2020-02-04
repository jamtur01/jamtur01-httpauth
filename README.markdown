Puppet HTTP Authentication type
===============================

This provides a HTTP Authentication type for Puppet that support Basic and Digest authentication.

Copyright - James Turnbull <james@lovedthanlost.net>

License: Apache 2.0

Thanks to John Ferlito and JKur (https://github.com/jkur) for patches.

Requirements
------------

* webrick

Usage
-----

    httpauth { 'name':
      username => 'username',
      file     => '/path/to/password/file',
      mode     => 0644,
      password => 'password',
      realm => 'realm',
      mechanism => basic,
      ensure => present,
    }
