node default{
  file { '/root/README':
    ensure => absent,
    }
  }
  
node slave1.puppet{
  package { 'httpd':
    ensure => installed,
    name   => httpd,
    }
  
  package { 'php':
    ensure => installed,
    name   => php,
    }
  }
  
  file { '/var/www/index.php':
    source => "https://raw.githubusercontent.com/Fenikks/itacademy-devops-files/master/01-demosite-php/index.php",
    }
    
    file { '/var/www/index.html':
    ensure => absent,
    }
  }
  
node slave2.puppet{
  package { 'httpd':
    ensure => installed,
    name   => httpd,
    }
  
  file { '/var/www/index.html':
    source => "https://raw.githubusercontent.com/Fenikks/itacademy-devops-files/master/01-demosite-static/index.html",
    }
    
  }
    
