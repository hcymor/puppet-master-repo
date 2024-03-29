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
    
  nginx::resource::server { 'dynamic':
    listen_port => 25565,
    proxy => 'http://192.168.50.12:25565',
    }
    
  exec { 'selinux_to_permissive':
    command => 'setenforce 0',
    path => [ '/usr/bin', '/bin', '/usr/sbin' ],
    user => 'root',
    }
  
  exec { 'reboot_nginx':
    command => 'systemctl restart nginx',
    path => [ '/usr/bin', '/bin', '/usr/sbin' ],
    user => 'root',
    }
}

node 'mineserver.puppet'{
    
  package {'java-17-openjdk':
    ensure => installed
    }

  file {'/opt/minecraft':
    ensure => directory
    }
    
  file { '/opt/minecraft/server.jar':
    ensure => file,
    source => 'https://launcher.mojang.com/v1/objects/c8f83c5655308435b3dcf03c06d9fe8740a77469/server.jar',
    }
    
  file {'/opt/minecraft/eula.txt':
    ensure => file,
    content => 'eula=true'
    }
  
  systemd::unit_file { 'minecraft.service':
    source => "puppet:///modules/minecraft/minecraft.service",
    }
    ~> service {'minecraft':
    ensure => 'running',
    }

}
