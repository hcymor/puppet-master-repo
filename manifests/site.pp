node default{
  file { '/root/README':
    ensure => absent,
    }
  }
