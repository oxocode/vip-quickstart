# PHP 5.4 + extensions
include php

class {
  'php::cli':
    ensure  => latest;
  'php::composer':;
  'php::dev':
    ensure  => latest;
  'php::fpm':;
  'php::pear':;
  'php::phpunit':;

  # Extensions
  'php::extension::apc':
    ensure => absent;
  'php::extension::curl':;
  'php::extension::gd':;
  'php::extension::imagick':;
  'php::extension::mcrypt':;
  'php::extension::memcache':;
  'php::extension::mysql':;
  'php::extension::xdebug':;
}

# Install PHP_CodeSniffer and the WordPress coding standard
package { 'pear.php.net/PHP_CodeSniffer':
  ensure   => 'installed',
  provider => 'pear',
}

vcsrepo { '/usr/share/php/PHP/CodeSniffer/Standards/WordPress':
  source   => 'https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards',
  provider => 'git',
  ensure   => 'present',
  require  => Package['pear.php.net/PHP_CodeSniffer'],
}

php::fpm::conf { 'www': user => 'vagrant' }

file { '/etc/php5/conf.d/apc.ini': ensure => absent }

# Turn on html_errors
exec { 'html_errors = On':
  command => 'sed -i "s/html_errors = Off/html_errors = On/g" /etc/php5/fpm/php.ini',
  unless  => 'cat /etc/php5/fpm/php.ini | grep "html_errors = On"',
  user    => root,
  notify  => Service['php5-fpm']
}
