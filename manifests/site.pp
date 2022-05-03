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

node master.puppet{

  include nginx

  package { 'nginx':
    ensure => installed,
    name => nginx,
    }
  
  nginx::resource::server { 'slave1':
    listen_port => 9080,
    proxy => 'http://192.168.50.10:80',
    }

  nginx::resource::server { 'slave2':
    listen_port => 9081,
    proxy => 'http://192.168.50.11:80',
    }
  
  service { 'nginx':
    ensure => 'running',
    } 
    
  }
