class puppet_cron {

  // Let's make sure the Puppet daemon isn't running.
  service { "puppet":
    ensure => stopped,
    enable => false,
  } ->

  // Pull the latest commits to our Puppet module repository every 4 minutes.
  cron { 'puppet-pull':
    ensure => present,
    command => "cd /etc/puppetlabs/code/modules ; /usr/bin/git pull",
    user => 'root',
    minute => '*/4',
  } ~>

  cron { 'puppet-apply':
    ensure => present,
    command => "/opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/site.pp",
    user => 'root',
    minute => '*/5',
  }
}
