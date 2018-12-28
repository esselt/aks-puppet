class compliance {
  include compliance::audit
  include compliance::modules
  include compliance::users
  include compliance::docker_icc
  include compliance::night_sentinel
}
