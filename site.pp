node default {
  include puppet_cron

  ## DISABLE DOCKER ICC ##
  augeas { 'disable icc':
    incl => '/etc/systemd/system/docker.service.d/exec_start.conf',
    lens => 'Systemd.lns',
    context => '/files/etc/systemd/system/docker.service.d/exec_start.conf/Service',
    changes => "set ExecStart[ command = '/usr/bin/dockerd' ]/arguments/01 '--icc=false'",
    onlyif => "match ExecStart[ command = '/usr/bin/dockerd' ]/arguments/*[ . = '--icc=false' ] size == 0"
  }

  ## CLEAN UNNECESSARY USERS ##
  user { 'games':
    ensure => 'absent'
  }

  ## BLACKLIST KERNEL MODULES ##
  $module_blacklist = @(EOT)
    # File managed by Puppet
    # Modules disabled per Azure baseline
    install dccp /bin/true
    install sctp /bin/true
    install rds /bin/true
    install tipc /bin/true
    install cramfs /bin/true
    install freevxfs /bin/true
    install hfs /bin/true
    install hfsplus /bin/true
    install jffs2 /bin/true
    install squashfs /bin/true
    | EOT
  file { '/etc/modprobe.d/blacklist-azurebaseline.conf':
    ensure => file,
    content => $module_blacklist,
    owner => 'root',
    group => 'root',
    mode => '0644'
  }

  ## DOCKER RULES ##
  include auditd
  auditd::rule { 'watch /usr/bin/docker':
    content => '-w /usr/bin/docker -p wa',
    order   => 101
  }
  auditd::rule { 'watch /var/lib/docker':
    content => '-w /var/lib/docker -p wa',
    order   => 102
  }
  auditd::rule { 'watch /etc/docker':
    content => '-w /etc/docker -p wa',
    order   => 103
  }
  auditd::rule { 'watch /lib/systemd/system/docker.service':
    content => '-w /lib/systemd/system/docker.service -p wa',
    order   => 104
  }
  auditd::rule { 'watch /lib/systemd/system/docker.socket':
    content => '-w /lib/systemd/system/docker.socket -p wa',
    order   => 105
  }
  auditd::rule { 'watch /etc/default/docker':
    content => '-w /etc/default/docker -p wa',
    order   => 106
  }
  auditd::rule { 'watch /etc/docker/daemon.json':
    content => '-w /etc/docker/daemon.json -p wa',
    order   => 107
  }
  auditd::rule { 'watch /usr/bin/docker-containerd':
    content => '-w /usr/bin/docker-containerd -p wa',
    order   => 108
  }
  auditd::rule { 'watch /usr/bin/docker-runc':
    content => '-w /usr/bin/docker-runc -p wa',
    order   => 109
  }

  ## KURED REBOOT AT NIGHT ##
  cron { 'kured-night-reboot':
    ensure => present,
    command => '[ -f "/var/run/reboot-required" ] && touch /var/run/reboot-required-night',
    user => 'root',
    minute => '0',
    hour => '1'
  }
}
