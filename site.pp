node default {
  include puppet_cron

  import 'auditd.pp'
}
