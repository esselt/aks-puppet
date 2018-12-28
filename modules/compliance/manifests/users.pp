class compliance::users {
  ## CLEAN UNNECESSARY USERS ##
  user { 'games':
    ensure => 'absent'
  }
}
