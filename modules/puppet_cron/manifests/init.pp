class puppet_cron {

  service { 'puppet':
    ensure => stopped,
    enable => false,
  } ->

  cron { 'puppet-pull':
    ensure => present,
    command => 'cd /etc/puppetlabs/code/modules ; /usr/bin/git pull',
    user => 'root',
    minute => '*/4',
  } ~>

  cron { 'puppet-apply':
    ensure => present,
    command => '/opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/site.pp',
    user => 'root',
    minute => '*/5',
  }
}
