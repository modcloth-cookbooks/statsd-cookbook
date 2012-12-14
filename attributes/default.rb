default[:statsd][:repo] = "git://github.com/etsy/statsd.git"
default[:statsd][:revision] = "master"
default[:statsd][:config] = "/etc/statsd/config.js"
default[:statsd][:node_executable] = "node"

case node[:platform]
  when "ubuntu", "debian"
    default[:statsd][:path] = "/usr/share/statsd"
  when "smartos", "solaris"
  	default[:statsd][:path] = "/usr/local/statsd"
  	default[:statsd][:node_executable] = "/opt/local/bin/node"
end

default[:statsd][:log_file] = "/var/log/statsd.log"

default[:statsd][:flush_interval_msecs] = 10000
default[:statsd][:port] = 8125

# Is the graphite backend enabled?
default[:statsd][:graphite_enabled] = true
default[:statsd][:graphite_port] = 2003
default[:statsd][:graphite_host] = "localhost"

# Gossip Girl backend
default[:statsd][:gossip_girl_enabled] = false
default[:statsd][:gossip_girl_host] = "localhost"
default[:statsd][:gossip_girl_port] = 8125

#
# Add all NPM module backends here. Each backend should be a
# hash of the backend's name to the NPM module's version. If we
# should just use the latest, set the hash to null.
#
# For example, to use version 0.0.1 of statsd-librato-backend:
#
#   attrs[:statsd][:backends] = { 'statsd-librato-backend' => '0.0.1' }
#
# To use the latest version of statsd-librato-backend:
#
#   attrs[:statsd][:backends] = { 'statsd-librato-backend' => nil }
#
default[:statsd][:backends] = {}

#
# Add any additional backend configuration here.
#
default[:statsd][:extra_config] = {}
