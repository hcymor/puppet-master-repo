node default{
  file { '/root/README':
    ensure => absent,
    }
  }
  
node slave1.puppet{
  package { 'httpd':
    ensure => installed,
    name => httpd,
    }
  
  package { 'php':
    ensure => installed,
    name => php,
    }
  
  file { '/var/www/html/index.php':
    source => "https://raw.githubusercontent.com/Fenikks/itacademy-devops-files/master/01-demosite-php/index.php",
    }
    
  file { '/var/www/html/index.html':
    ensure => absent,
    }
    
  service { 'httpd':
    ensure => 'running',
    }
  }
  
node slave2.puppet{
  package { 'httpd':
    ensure => installed,
    name => httpd,
    }
  
  file { '/var/www/html/index.html':
    source => "https://raw.githubusercontent.com/Fenikks/itacademy-devops-files/master/01-demosite-static/index.html",
    }
    
  service { 'httpd':
    ensure => 'running',
    }
  }

node 'master.puppet'{

  include nginx

  nginx::resource::server { 'static':
    listen_port => 9080,
    proxy => 'http://192.168.50.10:80',
    }

  nginx::resource::server { 'dynamic':
    listen_port => 9081,
    proxy => 'http://192.168.50.11:80',
    }
    
  exec { 'selinux_to_permissive':
    command     => 'setenforce 0',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    user       => 'root',
    }
  
  exec { 'reboot_nginx':
    command     => 'systemctl restart nginx',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    user => 'root',
    }

}
